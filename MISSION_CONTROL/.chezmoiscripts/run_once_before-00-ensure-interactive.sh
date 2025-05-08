#!/bin/sh

# This script ensures that the CHEZMOI_INTERACTIVE environment variable is set
# based on whether we're in an interactive terminal session

# If CHEZMOI_INTERACTIVE is already set, use that value
if [ -n "${CHEZMOI_INTERACTIVE:-}" ]; then
  echo "Using existing CHEZMOI_INTERACTIVE=$CHEZMOI_INTERACTIVE"
else
  # Default to non-interactive
  export CHEZMOI_INTERACTIVE=0

  # Set to interactive if in a terminal
  if [ -t 0 ] && [ -t 1 ]; then
    export CHEZMOI_INTERACTIVE=1
    echo "Interactive terminal detected, setting CHEZMOI_INTERACTIVE=1"
  fi

  # Force non-interactive in CI/CD environments
  if [ -n "${CI:-}" ] || [ -n "${GITHUB_ACTIONS:-}" ]; then
    export CHEZMOI_INTERACTIVE=0
    echo "CI/CD environment detected, forcing CHEZMOI_INTERACTIVE=0"
  fi
fi

# Make the environment variable available to child processes
mkdir -p "${HOME}/.config/chezmoi"
echo "CHEZMOI_INTERACTIVE=${CHEZMOI_INTERACTIVE}" > "${HOME}/.config/chezmoi/interactive"
