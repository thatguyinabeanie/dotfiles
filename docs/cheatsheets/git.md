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

## 🌲 Worktree

| Alias | Command |
|-------|---------|
| `gwt` | `git worktree` |
| `gwtl` | `git worktree list` |
| `gwtlv` | `git worktree list --verbose` |
| `gwta` | `git worktree add PATH [BRANCH]` |
| `gwtac` | `git worktree add PATH [BRANCH]` under `.claude/worktrees/`, then `cd`s in (BRANCH defaults to PATH, created with `-b` if it doesn't exist) |
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
