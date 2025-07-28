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

##
## LASTPASS CLI
##

# Basic LastPass aliases
alias lp="lpass"
alias lpl="lpass ls"
alias lps="lpass show"
alias lpe="lpass edit"
alias lpa="lpass add"
alias lpg="lpass generate"
alias lpsync="lpass sync"

# Enhanced LastPass functions
function lpass_search() {
    if [[ -z "$1" ]]; then
        echo "Usage: lpass_search <search_term>"
        return 1
    fi
    lpass ls | grep -i "$1"
}

function lpass_copy() {
    if [[ -z "$1" ]]; then
        echo "Usage: lpass_copy <site_name>"
        return 1
    fi
    lpass show -c --password "$1"
    echo "Password copied to clipboard"
}

function lpass_show_user() {
    if [[ -z "$1" ]]; then
        echo "Usage: lpass_show_user <site_name>"
        return 1
    fi
    lpass show --username "$1"
}

function lpass_show_url() {
    if [[ -z "$1" ]]; then
        echo "Usage: lpass_show_url <site_name>"
        return 1
    fi
    lpass show --url "$1"
}

# Interactive LastPass search with fzf
function lpass_fzf() {
    local selected=$(lpass ls | fzf --height 40% --reverse)
    if [[ -n "$selected" ]]; then
        local name=$(echo "$selected" | sed 's/.*\[id: [0-9]*\] *//')
        lpass show -c --password "$name"
        echo "Password for '$name' copied to clipboard"
    fi
}

# Quick login check
function lpass_status() {
    if lpass status &>/dev/null; then
        echo "✅ Logged in to LastPass"
        lpass status
    else
        echo "❌ Not logged in to LastPass"
        echo "Run: lpass login <username>"
    fi
}

# Quick login function with your email
function lpass_login() {
    echo "🔐 Logging in to LastPass..."
    lpass login --trust gmendoza@civisanalytics.com
    if [[ $? -eq 0 ]]; then
        echo "✅ Successfully logged in to LastPass"
        lpass sync
    else
        echo "❌ Login failed"
    fi
}

# Store password in macOS Keychain (safer)
function lpass_store_password() {
    echo "This will store your LastPass master password in macOS Keychain"
    echo -n "Enter your LastPass master password: "
    read -s password
    echo
    echo "$password" | security add-generic-password -a "gmendoza@civisanalytics.com" -s "lastpass-cli" -w
    echo "✅ Password stored in macOS Keychain"
}

# Login using stored password from Keychain
function lpass_login_keychain() {
    echo "🔐 Logging in to LastPass using stored password..."
    local password=$(security find-generic-password -a "gmendoza@civisanalytics.com" -s "lastpass-cli" -w 2>/dev/null)
    if [[ -n "$password" ]]; then
        echo "$password" | lpass login --trust gmendoza@civisanalytics.com
        if [[ $? -eq 0 ]]; then
            echo "✅ Successfully logged in to LastPass"
            lpass sync
        else
            echo "❌ Login failed"
        fi
    else
        echo "❌ No password found in Keychain. Run 'lpass_store_password' first."
    fi
}

# ⚠️ RISKY: Login using environment variable (NOT RECOMMENDED)
function lpass_login_env() {
    if [[ -z "$LPASS_PASSWORD" ]]; then
        echo "❌ LPASS_PASSWORD environment variable not set"
        echo "Set it with: export LPASS_PASSWORD='your_password'"
        echo "⚠️  WARNING: This is insecure!"
        return 1
    fi
    echo "🔐 Logging in to LastPass using environment variable..."
    echo "$LPASS_PASSWORD" | lpass login --trust gmendoza@civisanalytics.com
    if [[ $? -eq 0 ]]; then
        echo "✅ Successfully logged in to LastPass"
        lpass sync
    else
        echo "❌ Login failed"
    fi
}

# Handle 2FA if enabled
function lpass_login_2fa() {
    echo "🔐 Logging in to LastPass with 2FA..."
    echo "You'll be prompted for your master password and 2FA code"
    lpass login --trust gmendoza@civisanalytics.com
    if [[ $? -eq 0 ]]; then
        echo "✅ Successfully logged in to LastPass"
        lpass sync
    else
        echo "❌ Login failed"
    fi
}

# Auto-login check on shell startup (optional)
function lpass_check_auth() {
    if ! lpass status &>/dev/null; then
        echo "💡 LastPass not authenticated. Run 'lpass_login' to log in."
    fi
}
