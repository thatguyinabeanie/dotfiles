#!/bin/zsh
# Platform environment variable management
# Work machines: macOS defaults, Personal machines: 1Password (future)

# Detect environment type
_platform_env_backend() {
    if [[ "${WORK_ENVIRONMENT:-false}" == "true" ]]; then
        echo "defaults"
    else
        echo "1password"  # Future implementation
    fi
}

# Set environment variable
setenv() {
    local key="$1" value="$2"
    if [[ -z "$key" || -z "$value" ]]; then
        echo "Usage: setenv KEY VALUE"
        return 1
    fi
    
    case "$(_platform_env_backend)" in
        "defaults")
            defaults write com.chezmoi.env "$key" -string "$value"
            echo "✓ Set $key in platform storage (defaults)"
            ;;
        "1password")
            echo "1Password integration not yet implemented"
            return 1
            ;;
    esac
}

# Get environment variable
getenv() {
    local key="$1"
    if [[ -z "$key" ]]; then
        echo "Usage: getenv KEY"
        return 1
    fi
    
    case "$(_platform_env_backend)" in
        "defaults")
            defaults read com.chezmoi.env "$key" 2>/dev/null
            ;;
        "1password")
            echo "1Password integration not yet implemented"
            return 1
            ;;
    esac
}

# List all environment variables
listenv() {
    case "$(_platform_env_backend)" in
        "defaults")
            echo "Platform environment variables (defaults):"
            if defaults read com.chezmoi.env >/dev/null 2>&1; then
                defaults read com.chezmoi.env 2>/dev/null | \
                    grep -E '^\s*"[A-Za-z_][A-Za-z0-9_]*"\s*=' | \
                    sed 's/^\s*//' | sed 's/"//g' | cut -d'=' -f1 | sed 's/[[:space:]]*$//' | sort
            else
                echo "  (none set)"
            fi
            ;;
        "1password")
            echo "1Password integration not yet implemented"
            return 1
            ;;
    esac
}

# Delete environment variable
delenv() {
    local key="$1"
    if [[ -z "$key" ]]; then
        echo "Usage: delenv KEY"
        return 1
    fi
    
    case "$(_platform_env_backend)" in
        "defaults")
            if defaults read com.chezmoi.env "$key" >/dev/null 2>&1; then
                defaults delete com.chezmoi.env "$key"
                echo "✓ Removed $key from platform storage"
            else
                echo "Key $key not found"
                return 1
            fi
            ;;
        "1password")
            echo "1Password integration not yet implemented"
            return 1
            ;;
    esac
}