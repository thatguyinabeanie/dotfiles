#!/bin/zsh

alias y="yazi"

alias ls="eza"
alias l="eza -l"
alias la="eza -la"

# --- Git Commit Emoji Selector (requires fzf) ---
function git_emoji_commit() {
  local emojis=(
    "✨ feat: A new feature"
    "🐛 fix: A bug fix"
    "📝 docs: Documentation only changes"
    "🎨 style: Code style changes"
    "🔥 remove: Remove code or files"
    "🚀 perf: Performance improvements"
    "✅ test: Adding tests"
    "🔧 chore: Maintenance"
    "🔀 merge: Merge branches"
    "⬆️ upgrade: Dependency upgrades"
  )
  local choice=$(printf '%s\n' "${emojis[@]}" | fzf)
  local emoji=$(echo $choice | awk '{print $1}')
  git commit -m "$emoji $*"
}

# --- Spotify Controller (macOS) ---
alias spotify_play='osascript -e "tell application \"Spotify\" to play"'
alias spotify_pause='osascript -e "tell application \"Spotify\" to pause"'
alias spotify_next='osascript -e "tell application \"Spotify\" to next track"'
alias spotify_prev='osascript -e "tell application \"Spotify\" to previous track"'
# alias claude="~/.claude/local/claude"

##
## CHEZMOI
##

# Navigate to the chezmoi source directory
alias dotfiles_cd="cd ~/.local/share/chezmoi"

# Open nvim at the chezmoi source directory
function dotfiles() {
  nvim ~/.local/share/chezmoi
}

##
## DOCKER MANAGEMENT
##

# Purge all Docker containers, volumes, and images
function docker_purge() {
    local force=false
    
    # Check for force flag
    if [[ "$1" == "-f" || "$1" == "--force" ]]; then
        force=true
    fi
    
    if [[ "$force" != true ]]; then
        echo -n "This will remove ALL Docker containers, volumes, and images. Continue? (y/N): "
        read confirm
        if [[ "$confirm" != "y" && "$confirm" != "Y" && "$confirm" != "yes" ]]; then
            echo "Operation cancelled."
            return 1
        fi
    fi
    
    echo "🧹 Purging Docker containers..."
    docker container prune -f 2>/dev/null || echo "No containers to remove"
    
    echo "🧹 Purging Docker volumes..."
    docker volume prune -a -f 2>/dev/null || echo "No volumes to remove"
    
    echo "🧹 Purging Docker images..."
    docker image prune -a -f 2>/dev/null || echo "No images to remove"
    
    echo "🧹 Purging Docker networks..."
    docker network prune -f 2>/dev/null || echo "No networks to remove"
    
    echo "🧹 Purging Docker build cache..."
    docker builder prune -a -f 2>/dev/null || echo "No build cache to remove"
    
    echo "✅ Docker purge complete!"
    
    # Show remaining usage
    docker system df 2>/dev/null || echo "Could not display disk usage"
}

# Quick alias for docker purge with force flag
alias docker_nuke="docker_purge -f"


