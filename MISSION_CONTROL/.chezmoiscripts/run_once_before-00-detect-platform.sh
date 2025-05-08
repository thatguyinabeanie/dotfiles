#!/bin/sh

# Platform detection script
# This script detects the current platform and sets appropriate variables
# Results are saved to ~/.config/chezmoi/platform.yaml

set -eu

# Create config directory if it doesn't exist
mkdir -p "${HOME}/.config/chezmoi"

# Default values
IS_MAC=false
IS_LINUX=false
IS_CODESPACE=false
IS_WSL=false
IS_DEBIAN=false
IS_FEDORA=false
IS_ARCH=false
IS_UBUNTU=false
IS_ALPINE=false
IS_TERMUX=false
HAS_APT=false
HAS_DNF=false
HAS_PACMAN=false
HAS_APK=false
HAS_PKG=false
HAS_BREW=false
HAS_MISE=false
HAS_RUSTUP=false
HAS_GUI=false
INTERACTIVE=false

# Detect OS
case "$(uname -s)" in
  Darwin*)
    IS_MAC=true
    ;;
  Linux*)
    IS_LINUX=true
    ;;
esac

# Detect if running in GitHub Codespaces
if [ -n "${CODESPACES:-}" ] || [ -n "${GITHUB_CODESPACE_TOKEN:-}" ]; then
  IS_CODESPACE=true
fi

# Detect if running in WSL
if [ "$IS_LINUX" = "true" ] && grep -q Microsoft /proc/version 2>/dev/null; then
  IS_WSL=true
fi

# Detect Linux distribution
if [ "$IS_LINUX" = "true" ]; then
  if [ -f /etc/os-release ]; then
    . /etc/os-release
    case "$ID" in
      debian)
        IS_DEBIAN=true
        ;;
      ubuntu)
        IS_UBUNTU=true
        IS_DEBIAN=true
        ;;
      fedora)
        IS_FEDORA=true
        ;;
      arch|manjaro)
        IS_ARCH=true
        ;;
      alpine)
        IS_ALPINE=true
        ;;
    esac
  fi

  # Check for Termux
  if [ -d /data/data/com.termux ]; then
    IS_TERMUX=true
  fi
fi

# Detect package managers
if command -v apt-get >/dev/null 2>&1; then
  HAS_APT=true
fi

if command -v dnf >/dev/null 2>&1; then
  HAS_DNF=true
fi

if command -v pacman >/dev/null 2>&1; then
  HAS_PACMAN=true
fi

if command -v apk >/dev/null 2>&1; then
  HAS_APK=true
fi

if command -v pkg >/dev/null 2>&1; then
  HAS_PKG=true
fi

if command -v brew >/dev/null 2>&1; then
  HAS_BREW=true
fi

if command -v mise >/dev/null 2>&1; then
  HAS_MISE=true
fi

if command -v rustup >/dev/null 2>&1; then
  HAS_RUSTUP=true
fi

# Detect GUI environment
if [ -n "${DISPLAY:-}" ] || [ -n "${WAYLAND_DISPLAY:-}" ] || [ "$IS_MAC" = "true" ]; then
  # On macOS, assume GUI is available
  # For Linux, check for X11 or Wayland
  if [ "$IS_CODESPACE" = "false" ] && [ "$IS_WSL" = "false" ]; then
    HAS_GUI=true
  fi
fi

# Set interactive mode based on CHEZMOI_INTERACTIVE environment variable
if [ -n "${CHEZMOI_INTERACTIVE:-}" ]; then
  # Use the environment variable if set
  if [ "${CHEZMOI_INTERACTIVE}" = "1" ]; then
    INTERACTIVE=true
    echo "Using CHEZMOI_INTERACTIVE=1, setting interactive mode"
  else
    INTERACTIVE=false
    echo "Using CHEZMOI_INTERACTIVE=0, setting non-interactive mode"
  fi
else
  # Default to interactive if in a terminal
  INTERACTIVE=false
  if [ -t 0 ] && [ -t 1 ]; then
    INTERACTIVE=true
  fi

  # Force non-interactive in CI/CD environments
  if [ -n "${CI:-}" ] || [ -n "${GITHUB_ACTIONS:-}" ]; then
    INTERACTIVE=false
  fi

  # Set the environment variable for consistency
  if [ "$INTERACTIVE" = "true" ]; then
    export CHEZMOI_INTERACTIVE=1
  else
    export CHEZMOI_INTERACTIVE=0
  fi

  echo "Set INTERACTIVE=$INTERACTIVE and CHEZMOI_INTERACTIVE=$CHEZMOI_INTERACTIVE"
fi

# Write to platform.yaml
cat > "${HOME}/.config/chezmoi/platform.yaml" << EOF
platform:
  is_mac: ${IS_MAC}
  is_linux: ${IS_LINUX}
  is_codespace: ${IS_CODESPACE}
  is_wsl: ${IS_WSL}
  is_debian: ${IS_DEBIAN}
  is_fedora: ${IS_FEDORA}
  is_arch: ${IS_ARCH}
  is_ubuntu: ${IS_UBUNTU}
  is_alpine: ${IS_ALPINE}
  is_termux: ${IS_TERMUX}
  has_apt: ${HAS_APT}
  has_dnf: ${HAS_DNF}
  has_pacman: ${HAS_PACMAN}
  has_apk: ${HAS_APK}
  has_pkg: ${HAS_PKG}
  has_brew: ${HAS_BREW}
  has_mise: ${HAS_MISE}
  has_rustup: ${HAS_RUSTUP}
  has_gui: ${HAS_GUI}
  interactive: ${INTERACTIVE}
EOF

echo "Platform detection complete. Results saved to ~/.config/chezmoi/platform.yaml"
