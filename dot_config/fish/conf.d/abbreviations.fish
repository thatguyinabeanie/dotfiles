# Fish abbreviations
# Managed by chezmoi - edit the source file, not the generated file
#
# Abbreviations expand inline as you type, unlike aliases which are functions.
# This gives you command history with the full expanded command.

if status is-interactive

    # ─────────────────────────────────────────────────────────────────────────
    # Git abbreviations
    # ─────────────────────────────────────────────────────────────────────────
    abbr -a g git
    abbr -a ga 'git add'
    abbr -a gaa 'git add --all'
    abbr -a gap 'git add --patch'
    abbr -a gb 'git branch'
    abbr -a gba 'git branch --all'
    abbr -a gbd 'git branch --delete'
    abbr -a gc 'git commit'
    abbr -a gcm 'git commit --message'
    abbr -a gca 'git commit --amend'
    abbr -a gcan 'git commit --amend --no-edit'
    abbr -a gcl 'git clone'
    abbr -a gco 'git checkout'
    abbr -a gcob 'git checkout -b'
    abbr -a gcp 'git cherry-pick'
    abbr -a gd 'git diff'
    abbr -a gds 'git diff --staged'
    abbr -a gf 'git fetch'
    abbr -a gfa 'git fetch --all --prune'
    abbr -a gl 'git log --oneline'
    abbr -a gla 'git log --oneline --all --graph'
    abbr -a glg 'git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset"'
    abbr -a gm 'git merge'
    abbr -a gp 'git push'
    abbr -a gpf 'git push --force-with-lease'
    abbr -a gpl 'git pull'
    abbr -a gplr 'git pull --rebase'
    abbr -a gr 'git remote'
    abbr -a grv 'git remote -v'
    abbr -a grb 'git rebase'
    abbr -a grbc 'git rebase --continue'
    abbr -a grba 'git rebase --abort'
    abbr -a grs 'git reset'
    abbr -a grsh 'git reset --hard'
    abbr -a grss 'git reset --soft'
    abbr -a gs 'git status'
    abbr -a gss 'git status --short'
    abbr -a gst 'git stash'
    abbr -a gstp 'git stash pop'
    abbr -a gstl 'git stash list'
    abbr -a gsw 'git switch'
    abbr -a gswc 'git switch --create'

    # ─────────────────────────────────────────────────────────────────────────
    # Docker abbreviations
    # ─────────────────────────────────────────────────────────────────────────
    abbr -a d docker
    abbr -a dc 'docker compose'
    abbr -a dcu 'docker compose up'
    abbr -a dcud 'docker compose up -d'
    abbr -a dcd 'docker compose down'
    abbr -a dcb 'docker compose build'
    abbr -a dcl 'docker compose logs'
    abbr -a dclf 'docker compose logs -f'
    abbr -a dce 'docker compose exec'
    abbr -a dcr 'docker compose restart'
    abbr -a dps 'docker ps'
    abbr -a dpsa 'docker ps -a'
    abbr -a di 'docker images'
    abbr -a drm 'docker rm'
    abbr -a drmi 'docker rmi'
    abbr -a dsp 'docker system prune'
    abbr -a dspa 'docker system prune --all --volumes'

    # ─────────────────────────────────────────────────────────────────────────
    # Navigation abbreviations
    # ─────────────────────────────────────────────────────────────────────────
    abbr -a .. 'cd ..'
    abbr -a ... 'cd ../..'
    abbr -a .... 'cd ../../..'
    abbr -a ..... 'cd ../../../..'
    abbr -a - 'cd -'

    # ─────────────────────────────────────────────────────────────────────────
    # Common tools abbreviations
    # ─────────────────────────────────────────────────────────────────────────
    abbr -a v nvim
    abbr -a vim nvim
    abbr -a c clear
    abbr -a h history
    abbr -a j jobs
    abbr -a q exit
    abbr -a mk 'mkdir -p'
    abbr -a rd rmdir

    # Modern CLI tool replacements (if installed)
    abbr -a cat bat
    abbr -a ls eza
    abbr -a ll 'eza -l'
    abbr -a la 'eza -la'
    abbr -a lt 'eza --tree'
    abbr -a tree 'eza --tree'

    # ─────────────────────────────────────────────────────────────────────────
    # Chezmoi abbreviations
    # ─────────────────────────────────────────────────────────────────────────
    abbr -a cz chezmoi
    abbr -a cza 'chezmoi apply'
    abbr -a czaf 'chezmoi apply --force'
    abbr -a czd 'chezmoi diff'
    abbr -a cze 'chezmoi edit'
    abbr -a czcd 'chezmoi cd'
    abbr -a czu 'chezmoi update'
    abbr -a czs 'chezmoi status'
    abbr -a czdr 'chezmoi apply --dry-run'

    # ─────────────────────────────────────────────────────────────────────────
    # Mise abbreviations
    # ─────────────────────────────────────────────────────────────────────────
    abbr -a mx mise
    abbr -a mxi 'mise install'
    abbr -a mxu 'mise use'
    abbr -a mxr 'mise run'
    abbr -a mxl 'mise ls'
    abbr -a mxt 'mise trust'

    # ─────────────────────────────────────────────────────────────────────────
    # Homebrew abbreviations (macOS)
    # ─────────────────────────────────────────────────────────────────────────
    abbr -a bi 'brew install'
    abbr -a bic 'brew install --cask'
    abbr -a bu 'brew upgrade'
    abbr -a bs 'brew search'
    abbr -a bl 'brew list'
    abbr -a binfo 'brew info'
    abbr -a bdr 'brew doctor'
    abbr -a bcu 'brew cleanup'

    # ─────────────────────────────────────────────────────────────────────────
    # Tmux abbreviations
    # ─────────────────────────────────────────────────────────────────────────
    abbr -a t tmux
    abbr -a ta 'tmux attach'
    abbr -a tat 'tmux attach -t'
    abbr -a tns 'tmux new-session -s'
    abbr -a tls 'tmux list-sessions'
    abbr -a tks 'tmux kill-session -t'

end
