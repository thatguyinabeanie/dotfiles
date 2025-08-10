#!/usr/bin/env bash
set -euo pipefail

# Cargo packages are now managed by mise
# This script is deprecated - cargo packages are now in:
# .chezmoidata/packages/mise/packages/tools.yaml

echo "⚠️  Cargo packages are now managed by mise"
echo "📁 Config location: .chezmoidata/packages/mise/packages/tools.yaml" 
echo "🚀 Install with: mise install"
echo ""
echo "This script is deprecated and will be removed in the future."

exit 0 