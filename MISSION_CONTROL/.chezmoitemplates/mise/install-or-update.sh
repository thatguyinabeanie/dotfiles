#!/bin/bash
# Unified mise installer/updater - uses official installer
#
# Environment variables:
#   MISE_INSTALL_ARCH="x64|arm64|auto"   (default: auto-detected)
#   MISE_INSTALL_PATH="/path/to/mise"     (default: ~/.local/bin/mise)
#   MISE_QUIET="true|false"               (default: false)

set -euo pipefail

# Only run on Apple Silicon when installing x64 variant
if [[ "${MISE_INSTALL_ARCH}" == "x64" && "$(uname -m)" != "arm64" ]]; then
	exit 0
fi

# Use official installer, suppress progress bars if quiet mode
curl -fsSL https://mise.run | sh 2>/dev/null

# Always upgrade after install if system architecture matches MISE_INSTALL_ARCH
if [[ "$(uname -m)" == "${MISE_INSTALL_ARCH}" ]]; then
	mise upgrade --yes
fi

