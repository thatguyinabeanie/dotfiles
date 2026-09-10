# Git Aliases

**Shell aliases for git**—defined in `.chezmoidata/aliases.yaml`.

## ⚡ Base

| Alias | Command |
|-------|---------|
| `g` | `git` |

## ➕ Add

| Alias | Command |
|-------|---------|
| `ga` | `git add` |
| `gaa` | `git add --all` |
| `gap` | `git add --patch` |
| `gau` | `git add --update` |

## 🌿 Branch

| Alias | Command |
|-------|---------|
| `gb` | `git branch` |
| `gba` | `git branch --all` |
| `gbd` | `git branch --delete` |
| `gbD` | `git branch --delete --force` |

## 💬 Commit

| Alias | Command |
|-------|---------|
| `gc` | `git commit` |
| `gcm` | `git commit --message` |
| `gca` | `git commit --amend` |
| `gcan` | `git commit --amend --no-edit` |
| `gcam` | `git commit -am` |
| `gcsm` | `git commit -S -m` (signed) |
| `gwip` | Stage all + commit `--wip--` (no verify) |

## 📦 Clone

| Alias | Command |
|-------|---------|
| `gcl` | `git clone` |
| `gclr` | `git clone --recurse-submodules` |

## 🔀 Checkout / Switch

| Alias | Command |
|-------|---------|
| `gco` | `git checkout` |
| `gcob` | `git checkout -b` |
| `gsw` | `git switch` |
| `gswc` | `git switch --create` |

## 🍒 Cherry-pick

| Alias | Command |
|-------|---------|
| `gcp` | `git cherry-pick` |
| `gcpa` | `git cherry-pick --abort` |
| `gcpc` | `git cherry-pick --continue` |

## 🔍 Diff

| Alias | Command |
|-------|---------|
| `gd` | `git diff` |
| `gds` | `git diff --staged` |
| `gdc` | `git diff --cached` |
| `gdw` | `git diff --word-diff` |

## 📡 Fetch

| Alias | Command |
|-------|---------|
| `gf` | `git fetch` |
| `gfa` | `git fetch --all --prune` |
| `gfo` | `git fetch origin` |

## 📜 Log

| Alias | Command |
|-------|---------|
| `gl` | `git log --oneline` |
| `gla` | `git log --oneline --all --graph` |
| `glog` | `git log --oneline --graph` |
| `gloga` | `git log --oneline --graph --all` |
| `glg` | Pretty graph log (hash · branch · message · time · author) |
| `glgp` | `git log --stat --patch` |

## 🔀 Merge

| Alias | Command |
|-------|---------|
| `gm` | `git merge` |
| `gma` | `git merge --abort` |
| `gmc` | `git merge --continue` |

## 🚀 Push

| Alias | Command |
|-------|---------|
| `gp` | `git push` |
| `gpf` | `git push --force-with-lease` |
| `gpff` | `git push --force` |
| `gpsup` | `git push --set-upstream origin HEAD` |

## ⬇️ Pull

| Alias | Command |
|-------|---------|
| `gpl` | `git pull` |
| `gplr` | `git pull --rebase` |
| `gplra` | `git pull --rebase --autostash` |

## 🌐 Remote

| Alias | Command |
|-------|---------|
| `gr` | `git remote` |
| `grv` | `git remote -v` |
| `gra` | `git remote add` |
| `grrm` | `git remote remove` |

## ♻️ Rebase

| Alias | Command |
|-------|---------|
| `grb` | `git rebase` |
| `grbc` | `git rebase --continue` |
| `grba` | `git rebase --abort` |
| `grbs` | `git rebase --skip` |
| `grbi` | `git rebase --interactive` |

## ↩️ Reset

| Alias | Command |
|-------|---------|
| `grs` | `git reset` |
| `grsh` | `git reset --hard` |
| `grss` | `git reset --soft` |
| `grhh` | `git reset HEAD --hard` |
| `groh` | `git reset origin/HEAD --hard` |

## 🔄 Restore

| Alias | Command |
|-------|---------|
| `grt` | `git restore` |
| `grts` | `git restore --staged` |

## ⏪ Revert

| Alias | Command |
|-------|---------|
| `grev` | `git revert` |
| `greva` | `git revert --abort` |
| `grevc` | `git revert --continue` |

## 🗄️ Stash

| Alias | Command |
|-------|---------|
| `gst` | `git stash` |
| `gsta` | `git stash push` |
| `gstaa` | `git stash apply` |
| `gstp` | `git stash pop` |
| `gstl` | `git stash list` |
| `gstd` | `git stash drop` |
| `gstc` | `git stash clear` |
| `gsts` | `git stash show --patch` |

## 📊 Status

| Alias | Command |
|-------|---------|
| `gs` | `git status` |
| `gss` | `git status --short` |
| `gsb` | `git status --short --branch` |

## 🔎 Show / Blame

| Alias | Command |
|-------|---------|
| `gsh` | `git show` |
| `gbl` | `git blame` |

## 🏷️ Tags

| Alias | Command |
|-------|---------|
| `gt` | `git tag` |
| `gta` | `git tag -a` |
| `gtd` | `git tag -d` |

## 🧹 Clean

| Alias | Command |
|-------|---------|
| `gclean` | `git clean -fd` |
| `gpristine` | Hard reset + `git clean -fdx` ⚠️ |

## 🧹 git-cleanup

Tidies up after PRs land: removes worktrees, prunes stale remote refs, deletes
branches whose remote branch is gone. Dry run unless you pass `-f`.

| Command | What it does |
|---------|--------------|
| `git-cleanup` | Show what would be removed. Deletes nothing |
| `git-cleanup -f` | Apply it |
| `git-cleanup -a` | Also branches merged by ancestry (true merges, not squashes) |
| `git-cleanup -w` | Also prune stale worktree metadata |
| `git-cleanup -W` | Also remove **all** linked worktrees. Implies `-w` |
| `git-cleanup -f -a -W` | Everything, for real. Flags combine |

Notes:

- Every run does a `git fetch --all --prune` first, because that is what makes a
  deleted upstream show up as gone. Even the dry run therefore refreshes your
  remote-tracking refs. No branch, worktree or commit is touched without `-f`.
- Worktrees are removed before branches, so a branch held by a worktree gets
  deleted in the same run.
- A worktree with uncommitted changes is reported `SKIPPED` and left alone. It
  tells you the `git worktree remove --force` command if you want it gone.
- The worktree you are standing in, and the main worktree, are never removed.
- Deleted a branch you wanted? `git reflog | grep <branch>` then
  `git branch <branch> <sha>`.

## 🌲 Worktree

| Alias | Command |
|-------|---------|
| `gwt` | `git worktree` |
| `gwtl` | `git worktree list` |
| `gwtlv` | `git worktree list --verbose` |
| `gwta` | `git worktree add` under `.claude/worktrees/` (or `.worktrees/` if no `.claude/` dir), auto-adds it to `.gitignore`, runs `mise trust` + symlinks `.env*` if present, then `cd`s in. Accepts real `git worktree add` flags (`-b`, `-B`, `-f`, `--detach`, etc.) |
| `gwtab` | `git worktree add -b BRANCH PATH` (create + checkout) |
| `gwtrm` | `git worktree remove PATH` |
| `gwtmv` | `git worktree move PATH NEW-PATH` |
| `gwtpr` | `git worktree prune` (clean up stale metadata) |

## 🐙 GitHub CLI

| Alias | Command |
|-------|---------|
| `ghpr` | `gh pr list` |
| `ghprc` | `gh pr create` |
| `ghprv` | `gh pr view` |
| `ghprco` | `gh pr checkout` |
| `ghprm` | `gh pr merge` |
| `ghprd` | `gh pr diff` |
| `ghi` | `gh issue list` |
| `ghic` | `gh issue create` |
| `ghiv` | `gh issue view` |
| `ghr` | `gh repo view --web` |
| `ghrc` | `gh repo clone` |
| `ghrf` | `gh repo fork` |
| `ghs` | `gh status` |
| `ghw` | `gh workflow list` |
| `ghwr` | `gh workflow run` |
| `ghrl` | `gh release list` |
