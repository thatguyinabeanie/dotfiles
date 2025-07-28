#!/bin/bash

set -euo pipefail

echo "🔧 Setting up persistent machine identity"

# Get current values
CURRENT_HOSTNAME="$(hostname)"
WORK_ENV="${WORK_ENVIRONMENT:-false}"
WORK_ORG="${WORK_ORG:-}"
MACHINE_TYPE="${MACHINE_TYPE:-laptop}"
NEW_HOSTNAME="${HOSTNAME:-$CURRENT_HOSTNAME}"

# Interactive prompts if not set via environment variables
if [[ "${WORK_ENV}" == "false" ]] && [[ -z "${WORK_ENVIRONMENT:-}" ]]; then
    echo "Current hostname: $CURRENT_HOSTNAME"
    read -p "Is this a work environment? (y/N): " is_work
    [[ "${is_work,,}" == "y" ]] && WORK_ENV="true"
fi

if [[ "${WORK_ENV}" == "true" ]] && [[ -z "${WORK_ORG}" ]]; then
    read -p "Enter work organization: " WORK_ORG
fi

if [[ -z "${MACHINE_TYPE:-}" ]]; then
    echo "Select machine type:"
    echo "1) laptop"
    echo "2) desktop" 
    echo "3) server"
    read -p "Choice (1-3): " choice
    case $choice in
        1) MACHINE_TYPE="laptop" ;;
        2) MACHINE_TYPE="desktop" ;;
        3) MACHINE_TYPE="server" ;;
        *) MACHINE_TYPE="laptop" ;;
    esac
fi

if [[ -z "${HOSTNAME:-}" ]]; then
    if [[ "${WORK_ENV}" == "true" ]]; then
        suggested="${USER}-${WORK_ORG,,}-work"
    else
        suggested="${USER}-personal"
    fi
    read -p "Enter hostname [$suggested]: " input_hostname
    NEW_HOSTNAME="${input_hostname:-$suggested}"
fi

# Set hostname if it's different
if [[ "${NEW_HOSTNAME}" != "${CURRENT_HOSTNAME}" ]]; then
    echo "🔧 Setting hostname to: ${NEW_HOSTNAME}"
    sudo scutil --set ComputerName "${NEW_HOSTNAME}"
    sudo scutil --set LocalHostName "${NEW_HOSTNAME}"
    sudo scutil --set HostName "${NEW_HOSTNAME}"
    
    # Flush DNS cache
    sudo dscacheutil -flushcache
    echo "✅ Hostname set to: ${NEW_HOSTNAME}"
    echo "ℹ️  You may need to restart Terminal for hostname changes to take effect"
fi

# Persist to macOS defaults
echo "💾 Saving machine identity to system defaults..."
defaults write com.chezmoi.machine work_environment -bool "${WORK_ENV}"
defaults write com.chezmoi.machine work_org -string "${WORK_ORG}"
defaults write com.chezmoi.machine machine_type -string "${MACHINE_TYPE}"
defaults write com.chezmoi.machine setup_date -string "$(date -Iseconds)"

echo ""
echo "✅ Machine identity persisted:"
echo "   Work Environment: ${WORK_ENV}"
echo "   Work Org: ${WORK_ORG}"
echo "   Machine Type: ${MACHINE_TYPE}"
echo "   Hostname: $(hostname)"
echo ""
echo "🚀 You can now run: chezmoi init --apply thatguyinabeanie"