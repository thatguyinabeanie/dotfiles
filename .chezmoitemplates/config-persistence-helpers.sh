#!/bin/bash

set -euo pipefail

# Persistent Configuration System Helpers
# Provides cross-platform storage for chezmoi configuration values
# Namespace: com.chezmoi.config

# Detect the best storage method for the current platform
detect_storage_method() {
{{- if eq .chezmoi.os "darwin" }}
  echo "macos_defaults"
{{- else if eq .chezmoi.os "linux" }}
  # Check for available storage methods in order of preference
  if command -v dconf >/dev/null 2>&1; then
    echo "dconf"
  elif command -v gsettings >/dev/null 2>&1; then
    echo "gsettings"
  else
    echo "xdg_config"
  fi
{{- else }}
  echo "xdg_config"  # Fallback to XDG for other Unix-like systems
{{- end }}
}

# Read a persistent config value
read_persistent_config() {
  local key="$1"
{{- if eq .chezmoi.os "darwin" }}
  defaults read com.chezmoi.config "${key}" 2>/dev/null || echo ""
{{- else if eq .chezmoi.os "linux" }}
  # Use detected storage method at runtime
  local storage_method="${2:-$(detect_storage_method)}"
  
  case "${storage_method}" in
    dconf)
      local dconf_key="/com/chezmoi/config/${key//_/-}"
      dconf read "${dconf_key}" 2>/dev/null | sed 's/^.\(.*\).$/\1/' || echo ""
      ;;
    gsettings)
      gsettings get com.chezmoi.config "${key//_/-}" 2>/dev/null | sed 's/^.\(.*\).$/\1/' || echo ""
      ;;
    *)
      local config_file="${XDG_CONFIG_HOME:-$HOME/.config}/chezmoi/persistent-config"
      if [[ -f "${config_file}" ]]; then
        grep "^${key}=" "${config_file}" 2>/dev/null | cut -d'=' -f2- | sed 's/^"\(.*\)"$/\1/' || echo ""
      else
        echo ""
      fi
      ;;
  esac
{{- else }}
  # XDG fallback for other systems
  local config_file="${XDG_CONFIG_HOME:-$HOME/.config}/chezmoi/persistent-config"
  if [[ -f "${config_file}" ]]; then
    grep "^${key}=" "${config_file}" 2>/dev/null | cut -d'=' -f2- | sed 's/^"\(.*\)"$/\1/' || echo ""
  else
    echo ""
  fi
{{- end }}
}

# Write a persistent config value
write_persistent_config() {
  local key="$1"
  local value="$2"
{{- if eq .chezmoi.os "darwin" }}
  # Detect value type and write accordingly
  if [[ "${value}" == "true" ]] || [[ "${value}" == "false" ]]; then
    defaults write com.chezmoi.config "${key}" -bool "${value}"
  elif [[ "${value}" =~ ^[0-9]+$ ]]; then
    defaults write com.chezmoi.config "${key}" -int "${value}"
  else
    defaults write com.chezmoi.config "${key}" -string "${value}"
  fi
{{- else if eq .chezmoi.os "linux" }}
  # Use detected storage method at runtime
  local storage_method="${3:-$(detect_storage_method)}"
  
  case "${storage_method}" in
    dconf)
      local dconf_key="/com/chezmoi/config/${key//_/-}"
      if [[ "${value}" == "true" ]] || [[ "${value}" == "false" ]]; then
        dconf write "${dconf_key}" "${value}"
      else
        dconf write "${dconf_key}" "'${value}'"
      fi
      ;;
    gsettings)
      gsettings set com.chezmoi.config "${key//_/-}" "${value}"
      ;;
    *)
      local config_file="${XDG_CONFIG_HOME:-$HOME/.config}/chezmoi/persistent-config"
      local config_dir="$(dirname "${config_file}")"
      mkdir -p "${config_dir}"
      
      # Remove existing key and add new value
      if [[ -f "${config_file}" ]]; then
        grep -v "^${key}=" "${config_file}" > "${config_file}.tmp" 2>/dev/null || true
        mv "${config_file}.tmp" "${config_file}"
      fi
      echo "${key}=\"${value}\"" >> "${config_file}"
      ;;
  esac
{{- else }}
  # XDG fallback for other systems
  local config_file="${XDG_CONFIG_HOME:-$HOME/.config}/chezmoi/persistent-config"
  local config_dir="$(dirname "${config_file}")"
  mkdir -p "${config_dir}"
  
  # Remove existing key and add new value
  if [[ -f "${config_file}" ]]; then
    grep -v "^${key}=" "${config_file}" > "${config_file}.tmp" 2>/dev/null || true
    mv "${config_file}.tmp" "${config_file}"
  fi
  echo "${key}=\"${value}\"" >> "${config_file}"
{{- end }}
}

# Delete a persistent config value
delete_persistent_config() {
  local key="$1"
{{- if eq .chezmoi.os "darwin" }}
  defaults delete com.chezmoi.config "${key}" 2>/dev/null || true
{{- else if eq .chezmoi.os "linux" }}
  local storage_method="${2:-$(detect_storage_method)}"
  
  case "${storage_method}" in
    dconf)
      local dconf_key="/com/chezmoi/config/${key//_/-}"
      dconf reset "${dconf_key}" 2>/dev/null || true
      ;;
    gsettings)
      gsettings reset com.chezmoi.config "${key//_/-}" 2>/dev/null || true
      ;;
    *)
      local config_file="${XDG_CONFIG_HOME:-$HOME/.config}/chezmoi/persistent-config"
      if [[ -f "${config_file}" ]]; then
        grep -v "^${key}=" "${config_file}" > "${config_file}.tmp" 2>/dev/null || true
        mv "${config_file}.tmp" "${config_file}"
      fi
      ;;
  esac
{{- else }}
  local config_file="${XDG_CONFIG_HOME:-$HOME/.config}/chezmoi/persistent-config"
  if [[ -f "${config_file}" ]]; then
    grep -v "^${key}=" "${config_file}" > "${config_file}.tmp" 2>/dev/null || true
    mv "${config_file}.tmp" "${config_file}"
  fi
{{- end }}
}

# List all persistent config values
list_persistent_config() {
{{- if eq .chezmoi.os "darwin" }}
  defaults read com.chezmoi.config 2>/dev/null || echo "No persistent config found"
{{- else if eq .chezmoi.os "linux" }}
  local storage_method="${1:-$(detect_storage_method)}"
  
  case "${storage_method}" in
    dconf)
      dconf dump /com/chezmoi/config/ 2>/dev/null || echo "No persistent config found"
      ;;
    gsettings)
      gsettings list-recursively com.chezmoi.config 2>/dev/null || echo "No persistent config found"
      ;;
    *)
      local config_file="${XDG_CONFIG_HOME:-$HOME/.config}/chezmoi/persistent-config"
      if [[ -f "${config_file}" ]]; then
        cat "${config_file}"
      else
        echo "No persistent config found"
      fi
      ;;
  esac
{{- else }}
  local config_file="${XDG_CONFIG_HOME:-$HOME/.config}/chezmoi/persistent-config"
  if [[ -f "${config_file}" ]]; then
    cat "${config_file}"
  else
    echo "No persistent config found"
  fi
{{- end }}
}

# Clear all persistent config
clear_persistent_config() {
{{- if eq .chezmoi.os "darwin" }}
  defaults delete com.chezmoi.config 2>/dev/null || true
{{- else if eq .chezmoi.os "linux" }}
  local storage_method="${1:-$(detect_storage_method)}"
  
  case "${storage_method}" in
    dconf)
      dconf reset -f /com/chezmoi/config/ 2>/dev/null || true
      ;;
    gsettings)
      # gsettings doesn't have a direct way to clear all keys
      echo "Manual reset required for gsettings"
      ;;
    *)
      local config_file="${XDG_CONFIG_HOME:-$HOME/.config}/chezmoi/persistent-config"
      rm -f "${config_file}"
      ;;
  esac
{{- else }}
  local config_file="${XDG_CONFIG_HOME:-$HOME/.config}/chezmoi/persistent-config"
  rm -f "${config_file}"
{{- end }}
}

# Main CLI interface
main() {
  local command="${1:-}"
  
  case "${command}" in
    read)
      shift
      read_persistent_config "$@"
      ;;
    write)
      shift
      write_persistent_config "$@"
      ;;
    delete)
      shift
      delete_persistent_config "$@"
      ;;
    list)
      shift
      list_persistent_config "$@"
      ;;
    clear)
      shift
      clear_persistent_config "$@"
      ;;
    detect)
      detect_storage_method
      ;;
    *)
      echo "Usage: $0 {read|write|delete|list|clear|detect} [args...]"
      echo ""
      echo "Commands:"
      echo "  read KEY              Read persistent config value"
      echo "  write KEY VALUE       Write persistent config value"
      echo "  delete KEY            Delete persistent config value"
      echo "  list                  List all persistent config values"
      echo "  clear                 Clear all persistent config"
      echo "  detect                Show detected storage method"
      echo ""
      echo "Examples:"
      echo "  $0 read shell_pref"
      echo "  $0 write shell_pref nu"
      echo "  $0 list"
      exit 1
      ;;
  esac
}