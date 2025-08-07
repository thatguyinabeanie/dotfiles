#!/bin/zsh
# Platform environment variable management
# Work machines: macOS defaults, Personal machines: 1Password (future)
#
# Usage examples:
#   platform_storage_setenv API_KEY "sk-1234567890"         # or: pssetenv API_KEY "sk-1234567890"
#   platform_storage_setenv --apply API_KEY "sk-1234567890" # or: pssetenv --apply API_KEY "sk-1234567890"
#   platform_storage_getenv API_KEY                         # or: psgetenv API_KEY
#   platform_storage_listenv                                # or: pslistenv
#   platform_storage_delenv API_KEY                         # or: psdelenv API_KEY
#
# The --apply flag automatically runs 'chezmoi apply' to load the variable into your current environment

# Detect environment type
_platform_env_backend() {
  if [[ "${WORK_ENVIRONMENT:-false}" == "true" ]]; then
    echo "defaults"
  else
    echo "1password" # Future implementation
  fi
}

# Set environment variable in platform storage
# Example: platform_storage_setenv API_KEY "sk-1234567890"
# Example: platform_storage_setenv --apply API_KEY "sk-1234567890"
platform_storage_setenv() {
  local apply_flag=false
  local key value
  
  # Parse arguments
  while [[ $# -gt 0 ]]; do
    case $1 in
      --apply)
        apply_flag=true
        shift
        ;;
      *)
        if [[ -z "$key" ]]; then
          key="$1"
        elif [[ -z "$value" ]]; then
          value="$1"
        else
          echo "Usage: platform_storage_setenv [--apply] KEY VALUE"
          return 1
        fi
        shift
        ;;
    esac
  done
  
  if [[ -z "$key" || -z "$value" ]]; then
    echo "Usage: platform_storage_setenv [--apply] KEY VALUE"
    return 1
  fi

  case "$(_platform_env_backend)" in
  "defaults")
    defaults write com.chezmoi.env "$key" -string "$value"
    echo "✓ Set $key in platform storage"
    
    if [[ "$apply_flag" == true ]]; then
      echo "Running chezmoi apply..."
      chezmoi apply
      echo "Reloading environment..."
      source ~/.zshenv
      echo "✓ $key has been applied and environment reloaded"
    fi
    ;;
  "1password")
    echo "1Password integration not yet implemented"
    return 1
    ;;
  esac
}

# Get environment variable from platform storage
# Example: platform_storage_getenv API_KEY
platform_storage_getenv() {
  local key="$1"
  if [[ -z "$key" ]]; then
    echo "Usage: platform_storage_getenv KEY"
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

# List all environment variables stored in platform storage
# Example: platform_storage_listenv
platform_storage_listenv() {
  case "$(_platform_env_backend)" in
  "defaults")
    if ! command -v jq >/dev/null 2>&1; then
      echo "Error: 'jq' is required to list environment variables but is not installed."
      echo "Please install jq (e.g., 'brew install jq') and try again."
      return 1
    fi
    
    local output
    output=$(defaults export com.chezmoi.env - | plutil -convert json -o - - 2>/dev/null | jq -r 'to_entries[] | "\(.key)=\(.value)"' 2>/dev/null)
    if [[ -n "$output" ]]; then
      echo "$output" | while IFS='=' read -r key value; do
        printf "\033[36m%s\033[0m=\033[33m%s\033[0m\n" "$key" "$value"
      done
    else
      echo "No environment variables stored in platform storage"
    fi
    ;;
  "1password")
    echo "1Password integration not yet implemented"
    return 1
    ;;
  esac
}

# Delete environment variable from platform storage
# Example: platform_storage_delenv API_KEY
platform_storage_delenv() {
  local key="$1"
  if [[ -z "$key" ]]; then
    echo "Usage: platform_storage_delenv KEY"
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

# Shorter aliases for convenience
alias pssetenv=platform_storage_setenv
alias psgetenv=platform_storage_getenv
alias pslistenv=platform_storage_listenv
alias psdelenv=platform_storage_delenv
