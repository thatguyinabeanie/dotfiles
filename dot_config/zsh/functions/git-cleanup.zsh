# ─────────────────────────────────────────────────────────────────────────────
# git-cleanup: tidy a repository after PRs land.
#
# Removes linked worktrees, prunes stale remote-tracking refs, and deletes local
# branches whose remote branch is gone — the usual state after a PR is
# squash-merged and the forge auto-deletes the head branch.
#
# Portable across bash and zsh (no zparseopts, no arrays, no glob qualifiers),
# so this file can be sourced from either. Sourced from .zshrc.
#
# Usage:
#   git-cleanup              # dry run: report what would be removed
#   git-cleanup -f           # apply
#   git-cleanup -a           # also branches merged by ancestry
#   git-cleanup -w           # also prune stale worktree metadata
#   git-cleanup -W           # also remove ALL linked worktrees (implies -w)
#   git-cleanup -f -a -W     # flags combine
# ─────────────────────────────────────────────────────────────────────────────

git-cleanup() {
  # --- options -------------------------------------------------------------
  local force=0 include_merged=0 prune_worktrees=0 rm_worktrees=0

  while [ $# -gt 0 ]; do
    case "$1" in
      -f|--force)           force=1 ;;
      -a|--all)             include_merged=1 ;;
      -w|--prune-worktrees) prune_worktrees=1 ;;
      # -W implies -w: once the worktrees are gone their metadata is stale, and
      # leaving it behind would just require a second invocation to clear.
      -W|--rm-worktrees)    rm_worktrees=1; prune_worktrees=1 ;;
      -h|--help)
        printf 'git-cleanup [-f] [-a] [-w] [-W]\n\n'
        printf 'Removes linked worktrees, prunes stale remote-tracking refs, and\n'
        printf 'deletes local branches whose remote branch is gone.\n\n'
        printf '  -f, --force            apply (default is a dry run)\n'
        printf '  -a, --all              also branches merged by ancestry\n'
        printf '  -w, --prune-worktrees  also prune stale worktree metadata\n'
        printf '  -W, --rm-worktrees     also remove ALL linked worktrees (implies -w)\n'
        printf '  -h, --help             this message\n'
        return 0
        ;;
      *)
        printf 'git-cleanup: unknown option: %s\n' "$1" >&2
        return 2
        ;;
    esac
    shift
  done

  # --- guard: must be inside a git repo -------------------------------------
  if ! git rev-parse --git-dir >/dev/null 2>&1; then
    echo "❌ git-cleanup: not inside a git repository" >&2
    return 1
  fi

  # --- work out the default branch (never assume "main") --------------------
  # origin/HEAD is a symbolic ref pointing at the remote's default branch.
  local default_branch
  default_branch=$(git symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>/dev/null)
  default_branch=${default_branch#origin/}

  # Fall back to whichever of main/master exists locally.
  if [ -z "$default_branch" ]; then
    if git show-ref --verify --quiet refs/heads/main; then
      default_branch=main
    elif git show-ref --verify --quiet refs/heads/master; then
      default_branch=master
    else
      echo "❌ git-cleanup: cannot determine the default branch." >&2
      echo "   Try: git remote set-head origin --auto" >&2
      return 1
    fi
  fi

  # Empty when HEAD is detached, which is fine: there's nothing to protect.
  local current_branch
  current_branch=$(git symbolic-ref --quiet --short HEAD 2>/dev/null)

  echo "🧹 git-cleanup — default branch: $default_branch"
  [ "$force" -eq 0 ] && echo "   dry run — re-run with -f to apply"

  # Loop scratch variables, declared exactly once. Re-declaring an existing
  # local without an assignment makes zsh *print* its current value (bash stays
  # quiet), which leaked a stray "line=''" into the output.
  local line branch track wt

  # --- worktrees ------------------------------------------------------------
  # Deliberately ahead of the branch phase: `git branch -D` refuses a branch
  # that is checked out in a worktree, so the branches most likely to fail are
  # exactly the ones this step frees. Doing it first is what lets `-f -W`
  # finish in a single pass.
  local wt_failed=0

  if [ "$rm_worktrees" -eq 1 ]; then
    local here worktrees="" is_first=1
    # Empty in a bare repo; the first-entry guard below still covers main.
    here=$(git rev-parse --show-toplevel 2>/dev/null)

    while IFS= read -r line; do
      case "$line" in
        'worktree '*)
          wt=${line#worktree }
          # The main worktree is always the first entry (verified against
          # git 2.50) and is never a candidate.
          if [ "$is_first" -eq 1 ]; then
            is_first=0
            continue
          fi
          # Never remove the worktree we are standing in. git does NOT refuse
          # this — it removes the directory and returns 0, leaving the shell in
          # a deleted cwd. Verified, not assumed.
          [ "$wt" = "$here" ] && continue
          # A path that no longer exists is stale metadata; `git worktree prune`
          # (implied by -W) clears those, `remove` errors on them.
          [ -d "$wt" ] || continue
          worktrees="${worktrees}${wt}"$'\n'
          ;;
      esac
    done <<EOF
$(git worktree list --porcelain 2>/dev/null)
EOF

    if [ -z "$worktrees" ]; then
      echo
      echo "🌲 No linked worktrees to remove."
    else
      echo
      echo "🌲 Linked worktrees:"
      while IFS= read -r wt; do
        [ -z "$wt" ] && continue
        if [ -n "$(git -C "$wt" status --porcelain 2>/dev/null)" ]; then
          printf '  %-55s ⚠️  uncommitted changes\n' "$wt"
        else
          printf '  %s\n' "$wt"
        fi
      done <<EOF
$worktrees
EOF

      if [ "$force" -eq 1 ]; then
        echo
        # No --force, on purpose. git already refuses a worktree with
        # uncommitted or untracked changes, and that refusal is the guard worth
        # keeping: a deleted branch is recoverable from the reflog, but a
        # deleted worktree directory holding uncommitted work is not.
        while IFS= read -r wt; do
          [ -z "$wt" ] && continue
          if git worktree remove "$wt" 2>/dev/null; then
            printf '  🗑  removed  %s\n' "$wt"
          else
            printf '  ⚠️  SKIPPED  %s\n' "$wt"
            printf '              git worktree remove --force %s\n' "$wt"
            wt_failed=$((wt_failed + 1))
          fi
        done <<EOF
$worktrees
EOF
      fi
    fi
  fi

  if [ "$prune_worktrees" -eq 1 ]; then
    if [ "$force" -eq 1 ]; then
      echo
      echo "🌲 Pruning stale worktree metadata..."
      git worktree prune -v
    else
      local stale
      # 2>&1, not 2>/dev/null: `git worktree prune -v` writes its report to
      # stderr, so discarding stderr made this block permanently dead.
      stale=$(git worktree prune --dry-run -v 2>&1)
      if [ -n "$stale" ]; then
        echo
        echo "🌲 Stale worktree metadata:"
        printf '%s\n' "$stale"
      fi
    fi
  fi

  # --- refresh remote state and drop stale remote-tracking refs -------------
  # This is what makes upstream branches render as "[gone]" below. --all so a
  # branch tracking a non-origin remote is marked too; guarded because a
  # local-only repo has no remote to fetch from.
  echo
  if git remote | grep -q .; then
    echo "📡 Fetching and pruning remote-tracking refs..."
    git fetch --all --prune --quiet || echo "⚠️  fetch failed; working from local state"
  else
    echo "📡 No remote configured; skipping fetch."
  fi

  # Prefer the remote's default branch as the ancestry base: a local default
  # branch that has not been pulled is stale and under-reports what's merged.
  local base="$default_branch"
  if git show-ref --verify --quiet "refs/remotes/origin/$default_branch"; then
    base="origin/$default_branch"
  fi

  # --- collect branch candidates -------------------------------------------
  # Newline-delimited string rather than an array: bash and zsh index arrays
  # differently, and this keeps the function portable without an emulate shim.
  local candidates=""

  # 1. Branches whose upstream is gone. %(upstream:track) renders "[gone]" once
  #    the remote branch has been deleted. This is the reliable signal for
  #    squash-merged work, which ancestry checks miss entirely.
  while IFS= read -r line; do
    branch=${line%% *}
    track=${line#* }
    [ -z "$branch" ] && continue
    [ "$branch" = "$default_branch" ] && continue
    [ "$branch" = "$current_branch" ] && continue
    case "$track" in
      *'[gone]'*) candidates="${candidates}${branch}"$'\n' ;;
    esac
  done <<EOF
$(git for-each-ref --format='%(refname:short) %(upstream:track)' refs/heads/)
EOF

  # 2. Optionally add branches already merged into the base by ancestry. These
  #    are true merges, not squashes. for-each-ref rather than `git branch
  #    --merged` to avoid parsing the "* " current-branch marker.
  if [ "$include_merged" -eq 1 ]; then
    while IFS= read -r branch; do
      [ -z "$branch" ] && continue
      [ "$branch" = "$default_branch" ] && continue
      [ "$branch" = "$current_branch" ] && continue
      # Anchored on both sides. An unanchored match would skip "feat/foo"
      # because an unrelated "xfeat/foo" is already in the list.
      case $'\n'"$candidates" in
        *$'\n'"$branch"$'\n'*) continue ;;
      esac
      candidates="${candidates}${branch}"$'\n'
    done <<EOF
$(git for-each-ref --format='%(refname:short)' --merged "$base" refs/heads/ 2>/dev/null)
EOF
  fi

  if [ -z "$candidates" ]; then
    echo
    echo "✅ No branches to clean up."
    [ "$wt_failed" -gt 0 ] && return 1
    return 0
  fi

  # --- report, flagging anything carrying commits not in the base ----------
  echo
  echo "🌿 Branch candidates:"
  local ahead count=0
  while IFS= read -r branch; do
    [ -z "$branch" ] && continue
    count=$((count + 1))
    ahead=$(git rev-list --count "$base".."$branch" 2>/dev/null) || ahead=0
    if [ "${ahead:-0}" -gt 0 ]; then
      printf '  %-55s %s commit(s) not in %s\n' "$branch" "$ahead" "$base"
    else
      printf '  %s\n' "$branch"
    fi
  done <<EOF
$candidates
EOF

  # --- dry run stops here ---------------------------------------------------
  if [ "$force" -eq 0 ]; then
    echo
    printf '%s branch(es) would be deleted. Re-run with -f to apply.\n' "$count"
    echo "   A squash-merged branch normally shows commits \"not in $base\" — its"
    echo "   original commits never landed there. Read that as a prompt to check"
    echo "   unfamiliar names, not as proof that work would be lost."
    return 0
  fi

  # --- delete ---------------------------------------------------------------
  # -D rather than -d: squash-merged branches fail the ancestry check that -d
  # enforces, so -d would refuse nearly everything listed above.
  echo
  echo "🌿 Deleting branches..."
  local failed=0
  while IFS= read -r branch; do
    [ -z "$branch" ] && continue
    if git branch -D "$branch" >/dev/null 2>&1; then
      printf '  🗑  deleted  %s\n' "$branch"
    else
      printf '  ⚠️  SKIPPED  %s (checked out in a worktree? try -W)\n' "$branch"
      failed=$((failed + 1))
    fi
  done <<EOF
$candidates
EOF

  if [ "$failed" -gt 0 ]; then
    echo
    echo "⚠️  $failed branch(es) skipped. Check: git worktree list"
  fi

  echo
  echo "♻️  Recover a branch you wanted to keep:"
  echo "   git reflog | grep <branch-name>"
  echo "   git branch <branch-name> <sha>"

  [ $((failed + wt_failed)) -gt 0 ] && return 1
  return 0
}
