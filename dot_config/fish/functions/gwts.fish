# Create a git worktree, mirroring `git worktree add`'s flags, under .claude/worktrees
# (if .claude/ exists at the repo root) or .worktrees/ otherwise. Auto-runs mise trust
# if mise.toml is present, auto-symlinks .env* files, and cd's into the new worktree.
# Usage: gwts [git-worktree-add flags] <path> [<commit-ish>]

# Ensure the repo's committed .gitignore excludes the worktrees dir (idempotent)
# Use git's own ignore resolution (not a literal grep) so an existing
# broader pattern already committed to the repo (e.g. ".claude/") is
# recognized and we don't add a redundant duplicate entry. The global
# excludes file is deliberately disabled for this check because it's
# machine-local, so relying on it would skip writing the repo's own
# .gitignore and leave teammates without that global file unprotected.
# Trailing slash matters: check-ignore only matches a directory-only
# pattern (e.g. ".worktrees/") against a queried path that itself ends
# in "/", since the target directory doesn't exist on disk yet for
# git to stat and infer that itself.
function _gwt_ensure_gitignore
    set -l main_root $argv[1]
    set -l subdir $argv[2]
    set -l entry "$subdir/"

    if git -C "$main_root" -c core.excludesFile= check-ignore -q "$entry" 2>/dev/null
        return 0
    end

    set -l gi "$main_root/.gitignore"
    if test -f "$gi"; or touch "$gi"
        if printf '%s\n' "$entry" >>"$gi"
            echo "📝 Taught .gitignore to skip '$entry'"
        else
            echo "⚠️ Could not write to $gi"
        end
    else
        echo "⚠️ Could not write to $gi"
    end
end

function gwts --description "Create a git worktree under .claude/worktrees or .worktrees, mise trust + .env symlink + cd"
    set -l toplevel (git rev-parse --show-toplevel 2>/dev/null)
    # The main worktree is always listed first by `git worktree list --porcelain`,
    # with any linked worktrees following, so main_root anchors here regardless
    # of which worktree the caller is standing in. Do not swap this for
    # `git rev-parse --git-common-dir` + dirname: inside a submodule that
    # resolves to `.git/modules/<name>`, whose dirname is not a worktree root.
    set -l main_root (git worktree list --porcelain 2>/dev/null | head -1 | sed 's/^worktree //')
    if test -z "$main_root"
        echo "❌ Not inside a git repository — nothing to branch from"
        return 1
    end

    # `head -1` truncates at an embedded newline, which a pathological repo path
    # could contain, silently handing us the wrong directory. Rather than hand-roll
    # a NUL-delimited porcelain parse, verify the result round-trips through git
    # itself and refuse cleanly if it doesn't.
    if not test -d "$main_root"
        echo "❌ Could not determine the main checkout reliably (unusual characters in the repo path?)"
        return 1
    end
    set -l verified_root (git -C "$main_root" rev-parse --show-toplevel 2>/dev/null)
    if test "$verified_root" != "$main_root"
        echo "❌ Could not determine the main checkout reliably (unusual characters in the repo path?)"
        return 1
    end

    if test -n "$toplevel"; and test "$toplevel" != "$main_root"
        echo "🧭 Anchoring at the main checkout: $main_root"
    end

    # zparseopts has no built-in concept of "--" as an end-of-options marker
    # either, so split it out ourselves before parsing: everything after the
    # first literal "--" is forced positional, and "--" itself is never
    # treated as the path.
    set -l before_dd
    set -l after_dd
    set -l seen_dd 0
    for a in $argv
        if test $seen_dd -eq 0; and test "$a" = --
            set seen_dd 1
            continue
        end
        if test $seen_dd -eq 1
            set -a after_dd $a
        else
            set -a before_dd $a
        end
    end

    # No zparseopts in fish: walk $before_dd once, routing only RECOGNIZED
    # flags -- the exact set zsh's zparseopts spec above lists, no more and no
    # less -- into $passthrough. Anything else, including a mistyped flag like
    # -h, falls through to $positionals, exactly like zparseopts -E leaves an
    # unrecognized option in $@ rather than silently eating it. Scanning the
    # whole of argv (not stopping at the first positional) matches zsh's
    # permuting `zparseopts -D -E`, so a flag after the path works the same in
    # both shells.
    set -l passthrough
    set -l positionals
    set -l saw_b
    set -l saw_B
    set -l i 1
    set -l n (count $before_dd)
    while test $i -le $n
        set -l tok $before_dd[$i]
        switch $tok
            case -f --force --no-force -d --detach --no-detach --checkout --no-checkout \
                 --orphan --no-orphan --lock --no-lock -q --quiet --no-quiet --track --no-track \
                 --guess-remote --no-guess-remote --relative-paths --no-relative-paths
                set -a passthrough $tok
            case '-b*' '-B*'
                # zsh's zparseopts accepts the attached form -bfoo == -b foo (and
                # -Bfoo == -B foo); fish must too, or the -b/-B conflict guard
                # below never sees it.
                set -l flag (string sub -l 2 -- $tok)
                set -l value (string sub -s 3 -- $tok)
                if test -z "$value"
                    set i (math $i + 1)
                    if test $i -gt $n
                        echo "gwts: missing argument for option: $flag" >&2
                        echo "❌ Failed to parse options"
                        return 1
                    end
                    set value $before_dd[$i]
                end
                set -a passthrough $flag $value
                test $flag = -b; and set saw_b 1
                test $flag = -B; and set saw_B 1
            case --reason '--reason=*'
                if test "$tok" = --reason
                    set i (math $i + 1)
                    if test $i -gt $n
                        echo "gwts: missing argument for option: --reason" >&2
                        echo "❌ Failed to parse options"
                        return 1
                    end
                    set -a passthrough --reason $before_dd[$i]
                else
                    # zsh's zparseopts keeps the "=" in the attached value verbatim
                    # (--reason=stash -> "--reason" "=stash"); match that quirk so
                    # both shells hand git the exact same argv.
                    set -l value (string sub -s 10 -- $tok)
                    set -a passthrough --reason "=$value"
                end
            case '-*'
                # A run of only recognized single-char flags (f/d/q) clusters just
                # like zparseopts does (-fd == -f -d); anything else starting with
                # "-" is unrecognized and falls through as a positional.
                if string match -qr '^-[fdq]+$' -- $tok
                    for c in (string split '' (string sub -s 2 -- $tok))
                        set -a passthrough "-$c"
                    end
                else
                    set -a positionals $tok
                end
            case '*'
                set -a positionals $tok
        end
        set i (math $i + 1)
    end
    set -a positionals $after_dd

    if test -n "$saw_b" -a -n "$saw_B"
        echo "❌ Cannot combine -b and -B"
        return 1
    end

    if test (count $positionals) -lt 1
        echo "❌ Usage: gwts [flags] <path> [<commit-ish>]"
        return 1
    end
    set -l wt_path $positionals[1]
    set -l commit_ish $positionals[2]
    # An explicit empty string is "no commit-ish", matching zsh's
    # ${commit_ish:+"$commit_ish"}, which drops an empty value the same way it
    # drops an absent one.
    test -z "$commit_ish"; and set commit_ish

    if string match -q -- '-*' $wt_path
        echo "❌ Worktree path cannot start with '-': $wt_path"
        return 1
    end

    set -l worktrees_subdir ".worktrees"
    test -d "$main_root/.claude"; and set worktrees_subdir ".claude/worktrees"
    set -l full_path "$main_root/$worktrees_subdir/$wt_path"

    if test -d "$full_path"
        echo "🌲 Already grown — hopping over to $full_path"
        cd "$full_path"; or return $status
        return 0
    end

    _gwt_ensure_gitignore "$main_root" "$worktrees_subdir"

    echo "🌱 Planting a worktree at $full_path..."
    git worktree add $passthrough $full_path $commit_ish
    or return $status

    # If a mise.toml is present at the repo root, run `mise trust` in the worktree
    if test -f "$main_root/mise.toml"
        if command -v mise >/dev/null 2>&1
            echo "🔒 Trusting the mise config..."
            mise trust "$full_path"; or echo "⚠️ mise trust failed"
        else
            echo "⚠️ 'mise' not found in PATH; cannot run mise trust"
        end
    end

    # Symlink any .env* files from the repo root into the new worktree (if they exist).
    # A bare `.env*` glob with no matches is silently empty in a fish `for`, so no
    # null-glob qualifier (zsh's `(N)`) is needed here.
    for env in $main_root/.env*
        test -e "$env"; or continue
        set -l fname (basename "$env")
        set -l dest "$full_path/$fname"

        if test -L "$dest"
            set -l target (readlink "$dest")
            if test "$target" = "$env"
                echo "🔗 $fname already linked"
                continue
            else
                echo "⚠️ $dest exists as symlink to $target; skipping"
                continue
            end
        else if test -e "$dest"
            echo "⚠️ $dest already exists and is not a symlink; skipping"
            continue
        else
            ln -s "$env" "$dest"; and echo "🔗 Linked $fname"; or echo "❌ Failed to create symlink $dest"
        end
    end

    cd "$full_path"; or return $status
    echo "🌲 Landed in $full_path"
end
