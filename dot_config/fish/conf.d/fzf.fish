# FZF Enhanced Configuration for Fish
# Requires: fzf, fzf.fish plugin (PatrickF1/fzf.fish), eza, bat
#
# This file configures fzf.fish with:
# - Rich previews for files, directories, git, and processes
# - Custom keybindings for fuzzy search features
# - Integration with eza, bat, and fd

# =============================================================================
# FZF.FISH FEATURE TOGGLES
# =============================================================================

# Enable all fzf.fish features
set -g fzf_preview_dir_cmd 'eza -1 --color=always --icons=always'
set -g fzf_preview_file_cmd 'bat --color=always --style=numbers --line-range=:100'

# =============================================================================
# KEYBINDINGS (fzf.fish defaults, can be customized)
# =============================================================================

# Ctrl+Alt+F - Search files (recursive)
# Ctrl+Alt+L - Search git log
# Ctrl+Alt+S - Search git status
# Ctrl+Alt+P - Search processes
# Ctrl+R     - Search command history
# Ctrl+V     - Search environment variables

# Custom key bindings (override defaults if needed)
set -g fzf_history_opts --preview-window=hidden
set -g fzf_directory_opts --preview-window=right:50%

# =============================================================================
# FZF DEFAULT OPTIONS
# =============================================================================

# General fzf appearance and behavior
set -gx FZF_DEFAULT_OPTS "\
--height=80% \
--layout=reverse \
--border=rounded \
--info=inline \
--multi \
--preview-window=right:60%:wrap \
--bind='ctrl-/:toggle-preview' \
--bind='ctrl-space:toggle' \
--bind='ctrl-a:toggle-all' \
--bind='ctrl-y:execute-silent(echo -n {+} | pbcopy)+abort' \
--bind='ctrl-d:preview-page-down' \
--bind='ctrl-u:preview-page-up'"

# =============================================================================
# FD OPTIONS FOR FILE SEARCH
# =============================================================================

# Use fd for file searching if available (faster than find)
if type -q fd
    set -gx FZF_DEFAULT_COMMAND 'fd --type f --hidden --follow --exclude .git'
    set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
    set -gx FZF_ALT_C_COMMAND 'fd --type d --hidden --follow --exclude .git'
end

# =============================================================================
# DIRECTORY PREVIEW
# =============================================================================

# fzf.fish uses fzf_preview_dir_cmd (set above)
# Additional customization for Alt+C directory jumping
set -gx FZF_ALT_C_OPTS "--preview 'eza -1 --color=always --icons=always {} 2>/dev/null || ls -la {}'"

# =============================================================================
# FILE PREVIEW (Ctrl+T)
# =============================================================================

set -gx FZF_CTRL_T_OPTS "\
--preview 'if test -d {}; eza -1 --color=always --icons=always {}; else; bat --color=always --style=numbers --line-range=:100 {} 2>/dev/null || cat {}; end' \
--preview-window=right:60%:wrap"

# =============================================================================
# HISTORY SEARCH (Ctrl+R)
# =============================================================================

set -gx FZF_CTRL_R_OPTS "\
--preview 'echo {}' \
--preview-window=down:3:wrap \
--bind='ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'"

# =============================================================================
# GIT INTEGRATION
# =============================================================================

# Git log preview options (for fzf.fish Ctrl+Alt+L)
set -g fzf_git_log_opts --preview-window=right:60%

# Git status preview options (for fzf.fish Ctrl+Alt+S)
set -g fzf_git_status_opts --preview-window=right:60%

# =============================================================================
# PROCESS SEARCH (Ctrl+Alt+P)
# =============================================================================

set -g fzf_processes_opts --preview-window=down:5:wrap

# =============================================================================
# CUSTOM FISH FUNCTIONS FOR ENHANCED FZF
# =============================================================================

# These functions are automatically available in functions/*.fish
# - fzf_git_branch: Fuzzy search git branches
# - fzf_git_stash: Fuzzy search git stashes  
# - fzf_docker: Fuzzy search docker containers/images
# - fzf_brew: Fuzzy search homebrew packages
