#!/bin/sh

# This script ensures that the CHEZMOI_INTERACTIVE environment variable is set
# based on whether we're in an interactive terminal session

# Check if we're in an interactive terminal session
if [ -t 0 ] && [ -t 1 ]; then
  # We're in an interactive terminal session
  export CHEZMOI_INTERACTIVE=1
  echo "Interactive terminal session detected, setting CHEZMOI_INTERACTIVE=1"
else
  # We're not in an interactive terminal session
  export CHEZMOI_INTERACTIVE=0
  echo "Non-interactive session detected, setting CHEZMOI_INTERACTIVE=0"
fi

# Check for CI/CD environments where we want to force non-interactive mode
if [ -n "${CI:-}" ] || [ -n "${GITHUB_ACTIONS:-}" ]; then
  export CHEZMOI_INTERACTIVE=0
  echo "CI/CD environment detected, forcing CHEZMOI_INTERACTIVE=0"
fi

# Check for Codespaces but allow it to be interactive if in a terminal
if [ -n "${CODESPACES:-}" ] || [ -n "${GITHUB_CODESPACE_TOKEN:-}" ]; then
  if [ -t 0 ] && [ -t 1 ]; then
    export CHEZMOI_INTERACTIVE=1
    echo "Interactive Codespace session detected, setting CHEZMOI_INTERACTIVE=1"
  else
    export CHEZMOI_INTERACTIVE=0
    echo "Non-interactive Codespace session detected, setting CHEZMOI_INTERACTIVE=0"
  fi
fi

# Make the environment variable available to child processes
echo "CHEZMOI_INTERACTIVE=${CHEZMOI_INTERACTIVE}" > "${HOME}/.config/chezmoi/interactive"
