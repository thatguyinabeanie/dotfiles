#!/bin/bash

# config-persistence.sh
# Configuration persistence helper functions for chezmoi
# Provides cross-platform storage and retrieval of configuration values

set -euo pipefail

# Detect the best storage method for the current platform
detect_storage_method() {
  local os_type="$(uname -s)"

  case "${os_type}" in
  Darwin*)
    echo "defaults"
    ;;
  Linux*)
    # Check for available storage methods in order of preference
    if command -v dconf >/dev/null 2>&1; then
      echo "dconf"
    elif command -v gsettings >/dev/null 2>&1; then
      echo "gsettings"
    else
      echo "xdg_config"
    fi
    ;;
  *)
    echo "xdg_config" # Fallback to XDG for other Unix-like systems
    ;;
  esac
}

# Write a configuration value to persistent storage
write_persistent_config() {
  local key="$1"
  local value="$2"
  local storage_method="${3:-$(detect_storage_method)}"

  case "${storage_method}" in
  defaults)
    defaults write com.chezmoi.config "${key}" -string "${value}"
    ;;
  dconf)
    local dconf_key="/com/chezmoi/config/${key//_/-}"
    dconf write "${dconf_key}" "'${value}'"
    ;;
  gsettings)
    gsettings set com.chezmoi.config "${key//_/-}" "${value}"
    ;;
  xdg_config)
    local config_file="${XDG_CONFIG_HOME:-$HOME/.config}/chezmoi/persistent-config"
    local config_dir="$(dirname "${config_file}")"

    # Ensure directory exists
    mkdir -p "${config_dir}"

    # Remove existing key if present
    if [[ -f "${config_file}" ]]; then
      grep -v "^${key}=" "${config_file}" >"${config_file}.tmp" 2>/dev/null || true
      mv "${config_file}.tmp" "${config_file}"
    fi

    # Add new value
    echo "${key}=\"${value}\"" >>"${config_file}"
    ;;
  esac
}

# Read a configuration value from persistent storage
read_persistent_config() {
  local key="$1"
  local storage_method="${2:-$(detect_storage_method)}"

  case "${storage_method}" in
  defaults)
    defaults read com.chezmoi.config "${key}" 2>/dev/null || echo ""
    ;;
  dconf)
    local dconf_key="/com/chezmoi/config/${key//_/-}"
    dconf read "${dconf_key}" 2>/dev/null | sed 's/^.\(.*\).$/\1/' || echo ""
    ;;
  gsettings)
    gsettings get com.chezmoi.config "${key//_/-}" 2>/dev/null | sed 's/^.\(.*\).$/\1/' || echo ""
    ;;
  xdg_config)
    local config_file="${XDG_CONFIG_HOME:-$HOME/.config}/chezmoi/persistent-config"
    if [[ -f "${config_file}" ]]; then
      grep "^${key}=" "${config_file}" 2>/dev/null | cut -d'=' -f2- | sed 's/^"\(.*\)"$/\1/' || echo ""
    else
      echo ""
    fi
    ;;
  esac
}

# Extract a value from a TOML file
extract_toml_value() {
  local toml_file="$1"
  local key="$2"
  local section="${3:-}"

  if [[ ! -f "$toml_file" ]]; then
    echo ""
    return
  fi

  # Build the full key path
  local full_key="$key"
  if [[ -n "$section" ]]; then
    full_key="${section}.${key}"
  fi

  # Use a simple approach to extract TOML values
  # This handles basic string and boolean values
  local value=""

  if [[ "$full_key" == *.* ]]; then
    # Handle nested keys like data.git.config.name
    local section_part="${full_key%.*}"
    local key_part="${full_key##*.}"

    # Find the section and extract the key
    awk -v section="$section_part" -v key="$key_part" '
        BEGIN { in_section = 0; found = 0 }
        /^\[/ { 
            if ($0 ~ "\\[" section "\\]") {
                in_section = 1
            } else {
                in_section = 0
            }
        }
        in_section && $0 ~ "^" key " *= *" {
            gsub(/^[^=]*= */, "")
            gsub(/^"/, "")
            gsub(/"$/, "")
            print
            found = 1
            exit
        }
        ' "$toml_file"
  else
    # Handle simple keys
    awk -v key="$key" '
        $0 ~ "^" key " *= *" {
            gsub(/^[^=]*= */, "")
            gsub(/^"/, "")
            gsub(/"$/, "")
            print
            exit
        }
        ' "$toml_file"
  fi
}

# List all stored configuration values
list_persistent_config() {
  local storage_method="${1:-$(detect_storage_method)}"

  case "${storage_method}" in
  defaults)
    defaults export com.chezmoi.config - 2>/dev/null | plutil -convert json -o - - 2>/dev/null || echo "{}"
    ;;
  dconf)
    dconf dump /com/chezmoi/config/ 2>/dev/null || echo ""
    ;;
  gsettings)
    # gsettings doesn't have a direct way to list all keys, so we'll try common ones
    echo "gsettings listing not fully implemented"
    ;;
  xdg_config)
    local config_file="${XDG_CONFIG_HOME:-$HOME/.config}/chezmoi/persistent-config"
    if [[ -f "${config_file}" ]]; then
      cat "${config_file}"
    else
      echo ""
    fi
    ;;
  esac
}

# Clear all stored configuration values
clear_persistent_config() {
  local storage_method="${1:-$(detect_storage_method)}"

  case "${storage_method}" in
  defaults)
    defaults delete com.chezmoi.config 2>/dev/null || true
    ;;
  dconf)
    dconf reset -f /com/chezmoi/config/ 2>/dev/null || true
    ;;
  gsettings)
    # gsettings doesn't have a direct way to clear all keys
    echo "gsettings clearing not fully implemented"
    ;;
  xdg_config)
    local config_file="${XDG_CONFIG_HOME:-$HOME/.config}/chezmoi/persistent-config"
    rm -f "${config_file}"
    ;;
  esac
}

# List all stored configuration values as JSON (cross-platform)
list_persistent_config_json() {
  local storage_method="${1:-$(detect_storage_method)}"

  case "${storage_method}" in
  defaults)
    defaults export com.chezmoi.config - 2>/dev/null | plutil -convert json -o - - 2>/dev/null || echo "{}"
    ;;
  dconf)
    # Convert dconf dump to JSON
    local dump
    dump=$(dconf dump /com/chezmoi/config/ 2>/dev/null || echo "")
    if [[ -z "$dump" ]]; then
      echo "{}"
      return
    fi
    # Parse key=value pairs (dconf uses 'key=value' under [/] section)
    echo "$dump" | awk '
      BEGIN { printf "{"; first=1 }
      /^[^[]/ && /=/ {
        key=$1; gsub(/-/, "_", key)
        val=$0; sub(/^[^=]*=/, "", val)
        gsub(/^'\''|'\''$/, "", val)
        if (!first) printf ","
        printf "\"%s\":\"%s\"", key, val
        first=0
      }
      END { printf "}" }
    '
    ;;
  gsettings)
    echo "{}"
    ;;
  xdg_config)
    local config_file="${XDG_CONFIG_HOME:-$HOME/.config}/chezmoi/persistent-config"
    if [[ -f "${config_file}" ]]; then
      # Convert key="value" lines to JSON
      awk '
        BEGIN { printf "{"; first=1 }
        /^[^#]/ && /=/ {
          split($0, parts, "=")
          key=parts[1]
          val=$0; sub(/^[^=]*=/, "", val)
          gsub(/^"|"$/, "", val)
          if (!first) printf ","
          printf "\"%s\":\"%s\"", key, val
          first=0
        }
        END { printf "}" }
      ' "${config_file}"
    else
      echo "{}"
    fi
    ;;
  esac
}

# Main function for command-line usage
main() {
  case "${1:-}" in
  read)
    if [[ $# -lt 2 ]]; then
      echo "Usage: $0 read KEY [STORAGE_METHOD]" >&2
      exit 1
    fi
    read_persistent_config "$2" "${3:-}"
    ;;
  write)
    if [[ $# -lt 3 ]]; then
      echo "Usage: $0 write KEY VALUE [STORAGE_METHOD]" >&2
      exit 1
    fi
    write_persistent_config "$2" "$3" "${4:-}"
    ;;
  list)
    list_persistent_config "${2:-}"
    ;;
  list-json)
    list_persistent_config_json "${2:-}"
    ;;
  clear)
    clear_persistent_config "${2:-}"
    ;;
  detect)
    detect_storage_method
    ;;
  *)
    echo "Usage: $0 {read|write|list|list-json|clear|detect} [args...]" >&2
    echo "Functions available when sourced: read_persistent_config, write_persistent_config, detect_storage_method, extract_toml_value, list_persistent_config_json" >&2
    exit 1
    ;;
  esac
}

# Only run main if script is executed directly (not sourced)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main "$@"
fi
