# Shell Aliases

**Quick-reference for all shell aliases**—active in Fish (as abbreviations) and Zsh.

## 🌿 Git

| Alias | Command |
|-------|---------|
| `g` | `git` |
| `ga` | `git add` |
| `gaa` | `git add --all` |
| `gap` | `git add --patch` |
| `gau` | `git add --update` |
| `gb` | `git branch` |
| `gba` | `git branch --all` |
| `gbd` | `git branch --delete` |
| `gbD` | `git branch --delete --force` |
| `gc` | `git commit` |
| `gcm` | `git commit --message` |
| `gca` | `git commit --amend` |
| `gcan` | `git commit --amend --no-edit` |
| `gcam` | `git commit -am` |
| `gcsm` | `git commit -S -m` |
| `gwip` | `git add -A && git commit --no-verify -m "--wip--"` |
| `gcl` | `git clone` |
| `gclr` | `git clone --recurse-submodules` |
| `gco` | `git checkout` |
| `gcob` | `git checkout -b` |
| `gsw` | `git switch` |
| `gswc` | `git switch --create` |
| `gcp` | `git cherry-pick` |
| `gcpa` | `git cherry-pick --abort` |
| `gcpc` | `git cherry-pick --continue` |
| `gd` | `git diff` |
| `gds` | `git diff --staged` |
| `gdc` | `git diff --cached` |
| `gdw` | `git diff --word-diff` |
| `gf` | `git fetch` |
| `gfa` | `git fetch --all --prune` |
| `gfo` | `git fetch origin` |
| `gl` | `git log --oneline` |
| `gla` | `git log --oneline --all --graph` |
| `glog` | `git log --oneline --graph` |
| `gloga` | `git log --oneline --graph --all` |
| `glg` | Pretty graph log |
| `glgp` | `git log --stat --patch` |
| `gm` | `git merge` |
| `gma` | `git merge --abort` |
| `gmc` | `git merge --continue` |
| `gp` | `git push` |
| `gpf` | `git push --force-with-lease` |
| `gpff` | `git push --force` |
| `gpsup` | `git push --set-upstream origin HEAD` |
| `gpl` | `git pull` |
| `gplr` | `git pull --rebase` |
| `gplra` | `git pull --rebase --autostash` |
| `gr` | `git remote` |
| `grv` | `git remote -v` |
| `gra` | `git remote add` |
| `grrm` | `git remote remove` |
| `grb` | `git rebase` |
| `grbc` | `git rebase --continue` |
| `grba` | `git rebase --abort` |
| `grbs` | `git rebase --skip` |
| `grbi` | `git rebase --interactive` |
| `grs` | `git reset` |
| `grsh` | `git reset --hard` |
| `grss` | `git reset --soft` |
| `grhh` | `git reset HEAD --hard` |
| `groh` | `git reset origin/HEAD --hard` |
| `grt` | `git restore` |
| `grts` | `git restore --staged` |
| `grev` | `git revert` |
| `greva` | `git revert --abort` |
| `grevc` | `git revert --continue` |
| `gst` | `git stash` |
| `gsta` | `git stash push` |
| `gstaa` | `git stash apply` |
| `gstp` | `git stash pop` |
| `gstl` | `git stash list` |
| `gstd` | `git stash drop` |
| `gstc` | `git stash clear` |
| `gsts` | `git stash show --patch` |
| `gs` | `git status` |
| `gss` | `git status --short` |
| `gsb` | `git status --short --branch` |
| `gsh` | `git show` |
| `gbl` | `git blame` |
| `gt` | `git tag` |
| `gta` | `git tag -a` |
| `gtd` | `git tag -d` |
| `gclean` | `git clean -fd` |
| `gpristine` | `git reset --hard && git clean -fdx` ⚠️ |
| `gwt` | `git worktree` |
| `gwtl` | `git worktree list` |
| `gwtlv` | `git worktree list --verbose` |
| `gwta` | `git worktree add` |
| `gwtac` | `git worktree add` (workspace under `.claude/worktrees`, auto-`cd`, branch defaults to path, auto-created if missing) |
| `gwtab` | `git worktree add -b` |
| `gwtrm` | `git worktree remove` |
| `gwtmv` | `git worktree move` |
| `gwtpr` | `git worktree prune` |

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

## 🐳 Docker

| Alias | Command |
|-------|---------|
| `d` | `docker` |
| `dc` | `docker compose` |
| `dcu` | `docker compose up` |
| `dcud` | `docker compose up -d` |
| `dcd` | `docker compose down` |
| `dcb` | `docker compose build` |
| `dcl` | `docker compose logs` |
| `dclf` | `docker compose logs -f` |
| `dce` | `docker compose exec` |
| `dcr` | `docker compose restart` |
| `dcps` | `docker compose ps` |
| `dps` | `docker ps` |
| `dpsa` | `docker ps -a` |
| `dr` | `docker run` |
| `drit` | `docker run -it` |
| `drm` | `docker rm` |
| `drmf` | `docker rm -f` |
| `dst` | `docker start` |
| `dstp` | `docker stop` |
| `drs` | `docker restart` |
| `dex` | `docker exec` |
| `deit` | `docker exec -it` |
| `dlo` | `docker logs` |
| `dlof` | `docker logs -f` |
| `dins` | `docker inspect` |
| `dsts` | `docker stats` |
| `di` | `docker images` |
| `dpl` | `docker pull` |
| `dph` | `docker push` |
| `drmi` | `docker rmi` |
| `dtag` | `docker tag` |
| `dbld` | `docker build` |
| `dipr` | `docker image prune -a` |
| `dvls` | `docker volume ls` |
| `dvrm` | `docker volume rm` |
| `dvpr` | `docker volume prune` |
| `dnls` | `docker network ls` |
| `dnc` | `docker network create` |
| `dnrm` | `docker network rm` |
| `dsp` | `docker system prune` |
| `dspa` | `docker system prune --all --volumes` |

## 🗂️ Navigation

| Alias | Command |
|-------|---------|
| `..` | `cd ..` |
| `...` | `cd ../..` |
| `....` | `cd ../../..` |
| `.....` | `cd ../../../..` |
| `-` | `cd -` (Fish only) |

## 🛠️ Common Utilities

| Alias | Command |
|-------|---------|
| `c` | `clear` |
| `h` | `history` |
| `j` | `jobs` |
| `q` | `exit` |
| `mk` | `mkdir -p` |
| `rd` | `rmdir` |

## ✏️ Editor

| Alias | Command |
|-------|---------|
| `v` | `nvim` |
| `vim` | `nvim` |

## 🦾 Modern CLI Replacements

| Alias | Replaces | Tool |
|-------|----------|------|
| `cat` | `cat` | `bat` |
| `ls` | `ls` | `eza` |
| `ll` | `ls -l` | `eza -l` |
| `la` | `ls -la` | `eza -la` |
| `lt` | `tree` | `eza --tree` |
| `tree` | `tree` | `eza --tree` |

## 🏠 Chezmoi

| Alias | Command |
|-------|---------|
| `cz` | `chezmoi` |
| `cza` | `chezmoi apply` |
| `czaf` | `chezmoi apply --force` |
| `czd` | `chezmoi diff` |
| `cze` | `chezmoi edit` |
| `czcd` | `chezmoi cd` |
| `czu` | `chezmoi update` |
| `czs` | `chezmoi status` |
| `czdr` | `chezmoi apply --dry-run` |

## 🎛️ Mise

| Alias | Command |
|-------|---------|
| `mx` | `mise` |
| `mxi` | `mise install` |
| `mxu` | `mise use` |
| `mxr` | `mise run` |
| `mxl` | `mise ls` |
| `mxt` | `mise trust` |

## 🍺 Homebrew

| Alias | Command |
|-------|---------|
| `bi` | `brew install` |
| `bic` | `brew install --cask` |
| `bu` | `brew upgrade` |
| `bs` | `brew search` |
| `bl` | `brew list` |
| `binfo` | `brew info` |
| `bdr` | `brew doctor` |
| `bcu` | `brew cleanup` |

## 📟 Tmux

| Alias | Command |
|-------|---------|
| `t` | `tmux` |
| `ta` | `tmux attach` |
| `tat` | `tmux attach -t` |
| `tns` | `tmux new-session -s` |
| `tls` | `tmux list-sessions` |
| `tks` | `tmux kill-session` |
