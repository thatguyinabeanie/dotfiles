# Machine Identity System

A comprehensive system for managing dotfiles across multiple machines with persistent environment detection and hostname management.

## Overview

This system provides:
- **Persistent machine identity** that survives chezmoi resets
- **Automatic environment detection** (work vs personal)
- **Hostname management** with mapping configurations
- **Machine-specific configurations** based on type and environment
- **Environment variable overrides** for flexibility

## Architecture

### 1. System-Level Persistence

Machine identity is stored in macOS defaults database, which persists through:
- Chezmoi configuration resets
- User directory cleanup
- Dotfiles repository changes
- System updates (but not OS reinstalls)

```bash
# Machine identity storage
defaults write com.chezmoi.machine work_environment -bool true
defaults write com.chezmoi.machine work_org -string "mycompany"
defaults write com.chezmoi.machine machine_type -string "work-laptop"
defaults write com.chezmoi.machine setup_date -string "$(date -Iseconds)"
```

### 2. Hostname Configuration Mapping

Centralized mapping in `.chezmoi.toml.tmpl` defines machine-specific settings:

```toml
{{/* Hostname-based configuration mapping */}}
{{- $hostname_configs := dict
  "gmendoza-personal" (dict
    "work_environment" false
    "work_org" ""
    "git_email" "personal@email.com"
    "shell" "nu"
    "catppuccin_flavor" "mocha"
    "theme_mode" "system"
    "machine_type" "personal-laptop"
  )
  "gmendoza-work-mbp" (dict
    "work_environment" true
    "work_org" "mycompany"
    "git_email" "gmendoza@mycompany.com"
    "shell" "zsh"
    "catppuccin_flavor" "frappe"
    "theme_mode" "dark"
    "machine_type" "work-laptop"
  )
  "gmendoza-homelab" (dict
    "work_environment" false
    "work_org" ""
    "git_email" "personal@email.com"
    "shell" "nu"
    "catppuccin_flavor" "mocha"
    "theme_mode" "dark"
    "machine_type" "server"
  )
  "gmendoza-gaming-rig" (dict
    "work_environment" false
    "work_org" ""
    "git_email" "personal@email.com"
    "shell" "nu"
    "catppuccin_flavor" "macchiato"
    "theme_mode" "dark"
    "machine_type" "desktop"
  )
-}}
```

### 3. Configuration Precedence

Settings are resolved in order of precedence:

1. **Environment variables** (highest priority)
2. **Hostname mapping** (from config above)
3. **System defaults** (persistent machine identity)
4. **Interactive prompts** (during initial setup)
5. **Hardcoded defaults** (fallback)

## Implementation

### Enhanced `.chezmoi.toml.tmpl`

```toml
{{- /* Determine if we're in an interactive session */ -}}
{{- $interactive := false -}}
{{- if eq (env "CHEZMOI_INTERACTIVE") "1" -}}
  {{- $interactive = true -}}
{{- else if eq (env "CHEZMOI_INTERACTIVE") "0" -}}
  {{- $interactive = false -}}
{{- else -}}
  {{- $interactive = stdinIsATTY -}}
{{- end -}}

{{- $current_hostname := output "hostname" | trim -}}

{{/* Read from system defaults */}}
{{- $system_work_env := false -}}
{{- $system_work_org := "" -}}
{{- $system_machine_type := "unknown" -}}

{{- with output "defaults" "read" "com.chezmoi.machine" "work_environment" 2>/dev/null | trim -}}
  {{- if eq . "1" -}}
    {{- $system_work_env = true -}}
  {{- end -}}
{{- end -}}

{{- with output "defaults" "read" "com.chezmoi.machine" "work_org" 2>/dev/null | trim -}}
  {{- $system_work_org = . -}}
{{- end -}}

{{- with output "defaults" "read" "com.chezmoi.machine" "machine_type" 2>/dev/null | trim -}}
  {{- $system_machine_type = . -}}
{{- end -}}

{{/* Define hostname mappings */}}
{{- $hostname_configs := dict
  "gmendoza-personal" (dict
    "work_environment" false
    "work_org" ""
    "git_email" "personal@email.com"
    "shell" "nu"
    "catppuccin_flavor" "mocha"
    "theme_mode" "system"
    "machine_type" "personal-laptop"
  )
  "gmendoza-work-mbp" (dict
    "work_environment" true
    "work_org" "mycompany"
    "git_email" "gmendoza@mycompany.com"
    "shell" "zsh"
    "catppuccin_flavor" "frappe"
    "theme_mode" "dark"
    "machine_type" "work-laptop"
  )
  "gmendoza-homelab" (dict
    "work_environment" false
    "work_org" ""
    "git_email" "personal@email.com"
    "shell" "nu"
    "catppuccin_flavor" "mocha"
    "theme_mode" "dark"
    "machine_type" "server"
  )
  "gmendoza-gaming-rig" (dict
    "work_environment" false
    "work_org" ""
    "git_email" "personal@email.com"
    "shell" "nu"
    "catppuccin_flavor" "macchiato"
    "theme_mode" "dark"
    "machine_type" "desktop"
  )
-}}

{{/* Get config for current hostname */}}
{{- $host_config := get $hostname_configs $current_hostname | default dict -}}

{{/* Resolve configuration with precedence */}}
{{- $WORK_ENVIRONMENT := env "WORK_ENVIRONMENT" | default ($host_config.work_environment | default $system_work_env) -}}
{{- $WORK_ORG := env "WORK_ORG" | default ($host_config.work_org | default $system_work_org) -}}
{{- $SHELL := env "SHELL_PREF" | default ($host_config.shell | default "nu") -}}
{{- $CATPPUCCIN_FLAVOR := env "CATPPUCCIN_FLAVOR" | default ($host_config.catppuccin_flavor | default "mocha") -}}
{{- $THEME_MODE := env "THEME_MODE" | default ($host_config.theme_mode | default "system") -}}
{{- $GIT_EMAIL := env "GIT_EMAIL" | default ($host_config.git_email | default "") -}}
{{- $MACHINE_TYPE := env "MACHINE_TYPE" | default ($host_config.machine_type | default $system_machine_type) -}}

{{/* Git configuration */}}
{{- $GIT_NAME := env "GIT_NAME" | default "GitHub Actions" -}}
{{- $GITHUB_USERNAME := env "GITHUB_USERNAME" | default "github-actions" -}}

{{/* Interactive prompts for missing values */}}
{{- if $interactive -}}
  {{- if not $GIT_NAME -}}
    {{- $GIT_NAME = promptStringOnce . "git.config.name" "👥 Git Config 👥 - Name" -}}
  {{- end -}}
  {{- if not $GITHUB_USERNAME -}}
    {{- $GITHUB_USERNAME = promptStringOnce . "git.config.username" "👥 Git Config 👥 - Github Username" -}}
  {{- end -}}
  {{- if not $GIT_EMAIL -}}
    {{- if $WORK_ENVIRONMENT -}}
      {{- $GIT_EMAIL = promptStringOnce . "git.config.email" "👥 Git Config 👥 - Work Email" -}}
    {{- else -}}
      {{- $GIT_EMAIL = promptStringOnce . "git.config.email" "👥 Git Config 👥 - Email" -}}
    {{- end -}}
  {{- end -}}
{{- end -}}

[data]
hostname = {{ $current_hostname | quote }}
machine_type = {{ $MACHINE_TYPE | quote }}
SHELL = {{ $SHELL | quote }}
WORK_ENVIRONMENT = {{ $WORK_ENVIRONMENT }}
WORK_ORG = {{ $WORK_ORG | quote }}
CATPPUCCIN_FLAVOR = {{ $CATPPUCCIN_FLAVOR | quote }}
THEME_MODE = {{ $THEME_MODE | quote }}
THEME_LIGHT = "catppuccin-latte"
THEME_DARK = "catppuccin-mocha"
INTERACTIVE = {{ $interactive }}

{{/* Machine-specific configurations */}}
[data.ghostty]
{{- if eq $MACHINE_TYPE "server" }}
font_size = "18"
window_width = "120" 
window_height = "40"
{{- else if eq $MACHINE_TYPE "desktop" }}
font_size = "26"
window_width = "180"
window_height = "80"
{{- else }}
font_size = "24"
window_width = "160"
window_height = "65"
{{- end }}
opacity = "0.8"
blur = "20"
font_thicken = true
font_family = "Dank Mono"
cursor_style = "block_hollow"

[data.tmux]
{{- if eq $MACHINE_TYPE "server" }}
show_hostname = true
status_right_length = 150
{{- else }}
show_hostname = false
status_right_length = 100
{{- end }}

[data.git.config]
name = {{ $GIT_NAME | quote }}
username = {{ $GITHUB_USERNAME | quote }}
email = {{ $GIT_EMAIL | quote }}
work_org = {{ $WORK_ORG | quote }}

[data.k9s]
transparent = true

[warnings]
configFileTemplateHasChanged = false
```

### Machine Identity Setup Script

Create `scripts/setup-machine-identity.sh`:

```bash
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
```

### Hostname Setting Script

Create `.chezmoiscripts/run_once_before_00-set-hostname.sh.tmpl`:

```bash
#!/bin/bash
{{- /* Only run if hostname needs to be set and we have the info */ -}}
{{- $target_hostname := "" -}}
{{- $current_hostname := output "hostname" | trim -}}

{{- /* Determine target hostname from various sources */ -}}
{{- if env "HOSTNAME" -}}
  {{- $target_hostname = env "HOSTNAME" -}}
{{- else if hasKey . "hostname" -}}
  {{- $target_hostname = .hostname -}}
{{- end -}}

{{- if and $target_hostname (ne $target_hostname $current_hostname) }}

set -euo pipefail

TARGET_HOSTNAME="{{ $target_hostname }}"
CURRENT_HOSTNAME="{{ $current_hostname }}"

echo "🔧 Setting hostname from $CURRENT_HOSTNAME to $TARGET_HOSTNAME"

# Set all hostname variants on macOS
sudo scutil --set ComputerName "$TARGET_HOSTNAME"
sudo scutil --set LocalHostName "$TARGET_HOSTNAME"
sudo scutil --set HostName "$TARGET_HOSTNAME"

# Flush DNS cache
sudo dscacheutil -flushcache

echo "✅ Hostname set to: $TARGET_HOSTNAME"
echo "ℹ️  You may need to restart Terminal for all changes to take effect"

{{- else }}
echo "✅ Hostname already correct: {{ $current_hostname }}"
{{- end }}
```

## Usage Examples

### Initial Setup

```bash
# Work laptop setup
WORK_ENVIRONMENT=true WORK_ORG=mycompany HOSTNAME=gmendoza-work-mbp ./scripts/setup-machine-identity.sh
chezmoi init --apply thatguyinabeanie

# Personal machine setup  
HOSTNAME=gmendoza-personal ./scripts/setup-machine-identity.sh
chezmoi init --apply thatguyinabeanie

# Interactive setup (will prompt for values)
./scripts/setup-machine-identity.sh
chezmoi init --apply thatguyinabeanie
```

### Adding New Machines

1. **Add to hostname mapping** in `.chezmoi.toml.tmpl`
2. **Run setup script** with appropriate environment variables
3. **Initialize chezmoi** as normal

```bash
# Example: New work desktop
WORK_ENVIRONMENT=true WORK_ORG=mycompany MACHINE_TYPE=desktop HOSTNAME=gmendoza-work-desktop ./scripts/setup-machine-identity.sh
chezmoi init --apply thatguyinabeanie
```

### Runtime Overrides

```bash
# Temporarily override theme for this session
THEME_MODE=light chezmoi apply

# Switch shell preference
SHELL_PREF=zsh chezmoi apply
```

### Reset Scenarios

```bash
# Complete chezmoi reset - machine identity persists!
chezmoi purge
rm -rf ~/.config/chezmoi
chezmoi init --apply thatguyinabeanie  # Still detects work environment

# Check current machine identity
defaults read com.chezmoi.machine

# Reset machine identity (start fresh)
defaults delete com.chezmoi.machine
./scripts/setup-machine-identity.sh
```

## Management Commands

### Query Machine Identity
```bash
# View all machine settings
defaults read com.chezmoi.machine

# View specific setting
defaults read com.chezmoi.machine work_environment
defaults read com.chezmoi.machine work_org
```

### Update Machine Identity
```bash
# Change work org
defaults write com.chezmoi.machine work_org -string "newcompany"

# Change machine type
defaults write com.chezmoi.machine machine_type -string "desktop"

# Apply changes
chezmoi apply
```

### Reset Machine Identity
```bash
# Complete reset
defaults delete com.chezmoi.machine

# Run setup again
./scripts/setup-machine-identity.sh
```

## Benefits

1. **Persistent Identity**: Machine configuration survives any chezmoi reset
2. **Multi-Machine Support**: Each machine can have different configurations
3. **Flexible Overrides**: Environment variables can override any setting
4. **Automatic Detection**: New setups automatically detect the environment
5. **Easy Management**: Simple commands to query and update machine identity
6. **Work/Personal Separation**: Clean separation of configurations
7. **Machine-Specific Tuning**: Different settings for laptops, desktops, servers

## Future Enhancements

- **Cloud sync**: Sync machine configurations across devices
- **Migration helpers**: Scripts to migrate configurations between machines
- **Health checks**: Verify machine identity consistency
- **Backup/restore**: Export/import machine configurations
- **Team sharing**: Share work configurations across team members