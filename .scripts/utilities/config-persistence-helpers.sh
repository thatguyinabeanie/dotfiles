#!/bin/bash

# Runtime wrapper for templated config persistence helpers
# This script generates the platform-specific helper functions on demand

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CHEZMOI_SOURCE_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"

# Change to source directory and generate the helper functions
cd "$CHEZMOI_SOURCE_DIR"
eval "$(chezmoi execute-template < .chezmoitemplates/config-persistence-helpers.sh)"

# Run the main function with all arguments
main "$@"