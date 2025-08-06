#!/bin/bash
# Unified mise installer/updater - uses official installer
#
# Environment variables:
#   MISE_INSTALL_ARCH="x64|arm64"        (default: auto-detected)
#   MISE_INSTALL_PATH="/path/to/mise"     (default: ~/.local/bin/mise)
#   MISE_QUIET="true|false"               (default: false)
#   MISE_VERSION="v2025.8.4"              (default: latest)

set -euo pipefail

# Set defaults for environment variables  
MISE_INSTALL_ARCH="${MISE_INSTALL_ARCH:-}"
MISE_INSTALL_PATH="${MISE_INSTALL_PATH:-$HOME/.local/bin/mise}"
MISE_QUIET="${MISE_QUIET:-false}"

# Auto-detect architecture if not provided
if [[ -z "${MISE_INSTALL_ARCH}" ]]; then
	case "$(uname -m)" in
		"arm64") MISE_INSTALL_ARCH="arm64" ;;
		"x86_64") MISE_INSTALL_ARCH="x64" ;;
		*) echo "❌ Unsupported architecture: $(uname -m)"; exit 1 ;;
	esac
fi

# Only install x64 variant on Apple Silicon when specifically requested
# On other architectures, let the official installer handle compatibility
if [[ "${MISE_INSTALL_ARCH}" == "x64" && "$(uname -m)" != "arm64" && "$(uname -m)" != "x86_64" ]]; then
	echo "⚠️ Skipping x64 mise installation on $(uname -m) architecture"
	exit 0
fi

# Export environment variables for official installer
export MISE_INSTALL_ARCH
export MISE_INSTALL_PATH
export MISE_QUIET

# Only export MISE_VERSION if it was explicitly set
if [[ -n "${MISE_VERSION:-}" ]]; then
	export MISE_VERSION
fi

# Use official installer - it handles all the complexity
if [[ "${MISE_QUIET}" == "true" ]]; then
	curl -fsSL https://mise.run | sh >/dev/null 2>&1
else
	curl -fsSL https://mise.run | sh
fi

# The official installer handles installation, no need for separate upgrade logic
echo "✅ mise installed/updated at ${MISE_INSTALL_PATH}"

