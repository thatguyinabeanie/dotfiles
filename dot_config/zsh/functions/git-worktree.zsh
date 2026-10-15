# Git worktree helpers: gwts (create/enter), gwtrm (remove by path or branch), and their _gwt_* helpers.

# Ensure the repo's committed .gitignore excludes the worktrees dir (idempotent)
_gwt_ensure_gitignore() {
  local main_root="${1-}" subdir="${2-}"
  local entry="${subdir}/"

  # Use git's own ignore resolution (not a literal grep) so an existing
  # broader pattern already committed to the repo (e.g. ".claude/") is
  # recognized and we don't add a redundant duplicate entry. The global
  # excludes file is deliberately disabled for this check — it's
  # machine-local, so relying on it would skip writing the repo's own
  # .gitignore and leave teammates without that global file unprotected.
  # Trailing slash matters: check-ignore only matches a directory-only
  # pattern (e.g. ".worktrees/") against a queried path that itself ends
  # in "/", since the target directory doesn't exist on disk yet for
  # git to stat and infer that itself.
  if git -C "$main_root" -c core.excludesFile= check-ignore -q "$entry" 2>/dev/null; then
    return 0
  fi

  local gi="$main_root/.gitignore"
  if { [ -f "$gi" ] || : > "$gi"; } && printf '%s\n' "$entry" >> "$gi"; then
    echo "📝 Taught .gitignore to skip '$entry'"
  else
    echo "⚠️ Could not write to $gi"
  fi
}

# Fetch <branch> from origin into refs/remotes/origin/<branch>. Silent failure (returns 1):
# the argument may be a SHA or tag, or the branch may not exist on origin yet.
_gwt_fetch_branch() {
  local main_root="${1-}" branch="${2-}"
  [ -n "$branch" ] || return 1
  # The leading + lets force-pushed branches still update the remote-tracking ref.
  # Braces matter: bare "$branch:r..." is zsh's :r (strip extension) modifier.
  git -C "$main_root" fetch --quiet origin "+refs/heads/${branch}:refs/remotes/origin/${branch}" 2>/dev/null || return 1
  echo "📡 Fetched $branch from origin"
}

# Create a git worktree, mirroring `git worktree add`'s flags, under .claude/worktrees
# (if .claude/ exists at the repo root) or .worktrees/ otherwise. Auto-runs mise trust
# if mise.toml is present, auto-symlinks .env* files, and cd's into the new worktree.
# Usage: gwts [git-worktree-add flags] <path> [<commit-ish>]
gwts() {
  local toplevel main_root
  toplevel=$(git rev-parse --show-toplevel 2>/dev/null)
  # The main worktree is always listed first by `git worktree list --porcelain`,
  # with any linked worktrees following, so main_root anchors here regardless
  # of which worktree the caller is standing in. Do not swap this for
  # `git rev-parse --git-common-dir` + dirname: inside a submodule that
  # resolves to `.git/modules/<name>`, whose dirname is not a worktree root.
  main_root=$(git worktree list --porcelain 2>/dev/null | head -1 | sed 's/^worktree //')
  if [ -z "$main_root" ]; then
    echo "❌ Not inside a git repository — nothing to branch from"
    return 1
  fi

  # `head -1` truncates at an embedded newline, which a pathological repo path
  # could contain, silently handing us the wrong directory. Rather than hand-roll
  # a NUL-delimited porcelain parse, verify the result round-trips through git
  # itself and refuse cleanly if it doesn't.
  if [ ! -d "$main_root" ]; then
    echo "❌ Could not determine the main checkout reliably (unusual characters in the repo path?)"
    return 1
  fi
  local verified_root
  verified_root=$(git -C "$main_root" rev-parse --show-toplevel 2>/dev/null)
  if [ "$verified_root" != "$main_root" ]; then
    echo "❌ Could not determine the main checkout reliably (unusual characters in the repo path?)"
    return 1
  fi

  if [ -n "$toplevel" ] && [ "$toplevel" != "$main_root" ]; then
    echo "🧭 Anchoring at the main checkout: $main_root"
  fi

  # zparseopts has no built-in concept of "--" as an end-of-options marker, so
  # split it out ourselves before parsing: everything after the first literal
  # "--" is forced positional, and "--" itself is never treated as the path.
  local -a before_dd after_dd
  local seen_dd=0 a
  for a in "$@"; do
    if [ "$seen_dd" = 0 ] && [ "$a" = "--" ]; then
      seen_dd=1
      continue
    fi
    if [ "$seen_dd" = 1 ]; then
      after_dd+=("$a")
    else
      before_dd+=("$a")
    fi
  done
  set -- "${before_dd[@]}"

  local -a passthrough newbranch resetbranch
  zparseopts -D -E -a passthrough -- \
    f -force -no-force \
    d -detach -no-detach \
    -checkout -no-checkout \
    -orphan -no-orphan \
    -lock -no-lock \
    -reason: \
    q -quiet -no-quiet \
    -track -no-track \
    -guess-remote -no-guess-remote \
    -relative-paths -no-relative-paths \
    b:=newbranch \
    B:=resetbranch \
    || { echo "❌ Failed to parse options"; return 1; }

  set -- "$@" "${after_dd[@]}"

  if [ -n "$newbranch" ] && [ -n "$resetbranch" ]; then
    echo "❌ Cannot combine -b and -B"
    return 1
  fi

  if [ $# -lt 1 ]; then
    echo "❌ Usage: gwts [flags] <path> [<commit-ish>]"
    return 1
  fi
  local wt_path="${1-}"
  local commit_ish="${2-}"

  case "$wt_path" in
    -*)
      echo "❌ Worktree path cannot start with '-': $wt_path"
      return 1
      ;;
  esac

  local worktrees_subdir=".worktrees"
  [ -d "$main_root/.claude" ] && worktrees_subdir=".claude/worktrees"
  local full_path="$main_root/$worktrees_subdir/$wt_path"

  if [ -d "$full_path" ]; then
    echo "🌲 Already grown — hopping over to $full_path"
    cd "$full_path" || return $?
    return 0
  fi

  _gwt_ensure_gitignore "$main_root" "$worktrees_subdir"

  # Refresh the branch from origin first, unless a flag creates or ignores branches.
  if [ -z "$newbranch" ] && [ -z "$resetbranch" ] && (( ${passthrough[(I)(-d|--detach|--orphan)]} == 0 )); then
    local candidate="${commit_ish:-$(basename "$wt_path")}"
    if _gwt_fetch_branch "$main_root" "$candidate" \
      && [ -z "$commit_ish" ] \
      && ! git -C "$main_root" show-ref --verify --quiet "refs/heads/$candidate"; then
      # Path-only form: git ignores the remote branch unless asked to guess it.
      passthrough+=(--guess-remote)
    fi
  fi

  echo "🌱 Planting a worktree at $full_path..."
  local add_output
  add_output=$(LC_ALL=C git worktree add "${passthrough[@]}" "${newbranch[@]}" "${resetbranch[@]}" \
    "$full_path" ${commit_ish:+"$commit_ish"} 2>&1)
  local add_status=$?
  print -r -- "$add_output"

  if [ "$add_status" -ne 0 ]; then
    # git already has this branch checked out elsewhere; hop there instead of
    # just relaying the fatal error, mirroring the already-a-directory case above.
    local existing_path
    existing_path=$(print -r -- "$add_output" | sed -n "s/.*already used by worktree at '\(.*\)'.*/\1/p")
    if [ -n "$existing_path" ] && [ -d "$existing_path" ]; then
      echo "🌲 Already grown elsewhere — hopping over to $existing_path"
      cd "$existing_path" || return $?
      return 0
    fi
    return $add_status
  fi

  # If a mise.toml is present at the repo root, run `mise trust` in the worktree
  if [ -f "$main_root/mise.toml" ]; then
    if command -v mise >/dev/null 2>&1; then
      echo "🔒 Trusting the mise config..."
      mise trust "$full_path" || echo "⚠️ mise trust failed"
    else
      echo "⚠️ 'mise' not found in PATH; cannot run mise trust"
    fi
  fi

  # Symlink any .env* files from the repo root into the new worktree (if they exist)
  for env in "$main_root"/.env*(N); do
    [ -e "$env" ] || continue
    local fname
    fname=$(basename "$env")
    local dest="$full_path/$fname"

    if [ -L "$dest" ]; then
      local target
      target=$(readlink "$dest")
      if [ "$target" = "$env" ]; then
        echo "🔗 $fname already linked"
        continue
      else
        echo "⚠️ $dest exists as symlink to $target; skipping"
        continue
      fi
    elif [ -e "$dest" ]; then
      echo "⚠️ $dest already exists and is not a symlink; skipping"
      continue
    else
      ln -s "$env" "$dest" && echo "🔗 Linked $fname" || echo "❌ Failed to create symlink $dest"
    fi
  done

  cd "$full_path" || return $?
  echo "🌲 Landed in $full_path"
}

# Print the path of the worktree that has <branch> checked out (nothing if none).
_gwt_path_for_branch() {
  # porcelain prints "worktree <path>" before that worktree's "branch refs/heads/<name>"
  git worktree list --porcelain 2>/dev/null | awk -v b="branch refs/heads/$1" '
    /^worktree / { p = substr($0, 10) }
    $0 == b { print p; exit }'
}

# `git worktree remove`, but the last argument may also be a branch name: when it
# isn't an existing directory, remove whichever worktree has that branch checked out.
# Usage: gwtrm [-f] <path|branch>
gwtrm() {
  local target="${@[-1]}" wt_path
  if [ -n "$target" ] && [ ! -d "$target" ]; then
    wt_path=$(_gwt_path_for_branch "$target")
    [ -n "$wt_path" ] && set -- "${@[1,-2]}" "$wt_path"
  fi
  git worktree remove "$@"
}
