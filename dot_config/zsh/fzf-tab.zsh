# FZF-Tab Enhanced Configuration
# Requires: fzf, fzf-tab, eza, bat, tmux 3.2+
#
# This file configures fzf-tab with:
# - Tmux popup mode for completions
# - Rich previews for files, directories, git, and processes
# - LS_COLORS integration for file colorization
# - Grouped completions with colored headers
# - Optimized keybindings

# =============================================================================
# GENERAL SETTINGS
# =============================================================================

# Use tmux popup for completions (requires tmux 3.2+)
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup

# Popup window settings
zstyle ':fzf-tab:*' popup-min-size 80 20
zstyle ':fzf-tab:*' popup-pad 0 0

# Disable sort for certain commands where order matters
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*:git-switch:*' sort false
zstyle ':completion:*:git-branch:*' sort false

# Set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'

# Set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# Force zsh not to show completion menu, allowing fzf-tab to capture it
zstyle ':completion:*' menu no

# Show all groups
zstyle ':fzf-tab:*' show-group full

# Color prefix for groups
zstyle ':fzf-tab:*' prefix '· '

# =============================================================================
# KEYBINDINGS
# =============================================================================

# Switch groups with < and >
zstyle ':fzf-tab:*' switch-group '<' '>'

# Accept with enter, use current input with alt-enter
zstyle ':fzf-tab:*' print-query alt-enter

# Continuous completion trigger (useful for deep paths)
zstyle ':fzf-tab:*' continuous-trigger '/'

# Additional fzf bindings
zstyle ':fzf-tab:*' fzf-bindings \
    'ctrl-space:toggle' \
    'ctrl-a:toggle-all' \
    'ctrl-/:toggle-preview'

# =============================================================================
# DIRECTORY PREVIEWS (cd, ls, z, etc.)
# =============================================================================

# Preview directories with eza (tree view with icons)
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always --icons=always $realpath 2>/dev/null || ls -la $realpath'
zstyle ':fzf-tab:complete:cd:*' popup-min-size 80 20

# Same for pushd, z, zoxide
zstyle ':fzf-tab:complete:pushd:*' fzf-preview 'eza -1 --color=always --icons=always $realpath 2>/dev/null || ls -la $realpath'
zstyle ':fzf-tab:complete:z:*' fzf-preview 'eza -1 --color=always --icons=always $realpath 2>/dev/null || ls -la $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza -1 --color=always --icons=always $realpath 2>/dev/null || ls -la $realpath'

# =============================================================================
# FILE PREVIEWS
# =============================================================================

# Preview files with bat (syntax highlighting)
# Use for commands that work with files
zstyle ':fzf-tab:complete:*:*' fzf-preview '
if [[ -d $realpath ]]; then
    eza -1 --color=always --icons=always $realpath 2>/dev/null || ls -la $realpath
elif [[ -f $realpath ]]; then
    bat --color=always --style=numbers --line-range=:100 $realpath 2>/dev/null || cat $realpath
else
    echo $realpath
fi'

# Specific file operation commands with larger preview
zstyle ':fzf-tab:complete:(cat|bat|less|more|head|tail):*' fzf-preview 'bat --color=always --style=numbers --line-range=:200 $realpath 2>/dev/null || cat $realpath'
zstyle ':fzf-tab:complete:(cat|bat|less|more|head|tail):*' popup-min-size 100 30

zstyle ':fzf-tab:complete:(nvim|vim|vi|nano|code):*' fzf-preview 'bat --color=always --style=numbers --line-range=:200 $realpath 2>/dev/null || cat $realpath'
zstyle ':fzf-tab:complete:(nvim|vim|vi|nano|code):*' popup-min-size 100 30

# =============================================================================
# GIT PREVIEWS
# =============================================================================

# Preview git branches
zstyle ':fzf-tab:complete:git-(checkout|switch|merge|rebase|branch|diff):*' fzf-preview \
    'git log --oneline --graph --color=always --date=short --pretty="format:%C(auto)%cd %h%d %s" ${(Q)word} -- 2>/dev/null || echo "No commits yet"'

# Preview git log entries
zstyle ':fzf-tab:complete:git-log:*' fzf-preview \
    'git show --color=always ${(Q)word} 2>/dev/null | head -100'

# Preview git diff files
zstyle ':fzf-tab:complete:git-(add|restore|diff):*' fzf-preview \
    'git diff --color=always ${(Q)word} 2>/dev/null || git diff --color=always HEAD -- ${(Q)word} 2>/dev/null'

# Preview git stash
zstyle ':fzf-tab:complete:git-stash:*' fzf-preview \
    'git stash show -p --color=always ${(Q)word} 2>/dev/null'

# =============================================================================
# PROCESS PREVIEWS (kill, etc.)
# =============================================================================

# Preview processes for kill command
zstyle ':fzf-tab:complete:(kill|killall):argument-rest' fzf-preview \
    'ps -p ${(Q)word} -o pid,ppid,user,%cpu,%mem,start,time,command 2>/dev/null || echo "Process not found"'
zstyle ':fzf-tab:complete:(kill|killall):argument-rest' fzf-flags '--preview-window=down:3:wrap'

# =============================================================================
# ENVIRONMENT VARIABLE PREVIEWS
# =============================================================================

# Preview environment variables
zstyle ':fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' fzf-preview \
    'echo ${(P)word}'

# =============================================================================
# COMMAND HELP PREVIEWS
# =============================================================================

# Show man page or --help for commands
zstyle ':fzf-tab:complete:-command-:*' fzf-preview \
    '(out=$(tldr --color=always "$word" 2>/dev/null) && echo "$out") || (out=$(man -P cat "$word" 2>/dev/null) && echo "$out") || (out=$("$word" --help 2>/dev/null) && echo "$out") || echo "No help available"'
zstyle ':fzf-tab:complete:-command-:*' popup-min-size 100 30

# =============================================================================
# SYSTEMD PREVIEWS (Linux)
# =============================================================================

# Preview systemd units
zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word 2>/dev/null'

# =============================================================================
# DOCKER PREVIEWS
# =============================================================================

# Preview docker images
zstyle ':fzf-tab:complete:docker-image:*' fzf-preview 'docker image inspect ${(Q)word} 2>/dev/null | head -50'

# Preview docker containers  
zstyle ':fzf-tab:complete:docker-container:*' fzf-preview 'docker container inspect ${(Q)word} 2>/dev/null | head -50'

# =============================================================================
# HOMEBREW PREVIEWS (macOS)
# =============================================================================

# Preview brew packages
zstyle ':fzf-tab:complete:brew-(install|info|upgrade|uninstall):*' fzf-preview 'brew info $word 2>/dev/null'
