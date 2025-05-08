#!/bin/sh
# This script must be POSIX-compliant.

# -e: exit on error
# -u: exit on unset variables
set -eu

# Determine interactive mode and set environment variable
if [ -n "${CHEZMOI_INTERACTIVE:-}" ]; then
  # Use existing value if already set
  is_interactive=$([ "$CHEZMOI_INTERACTIVE" = "1" ] && echo "true" || echo "false")
  echo "Using existing CHEZMOI_INTERACTIVE=$CHEZMOI_INTERACTIVE"
else
  # Default to interactive if stdin and stdout are terminals
  is_interactive=false
  export CHEZMOI_INTERACTIVE=0

  # Check if we're in an interactive terminal
  if [ -t 0 ] && [ -t 1 ]; then
    is_interactive=true
    export CHEZMOI_INTERACTIVE=1
    echo "Interactive terminal detected"
  fi

  # Force non-interactive mode in CI/CD environments
  if [ -n "${CI:-}" ] || [ -n "${GITHUB_ACTIONS:-}" ]; then
    is_interactive=false
    export CHEZMOI_INTERACTIVE=0
    echo "CI/CD environment detected, forcing non-interactive mode"
  fi

  # Check for GitHub Codespaces (interactive if in a terminal)
  if [ -n "${CODESPACES:-}" ] || [ -n "${GITHUB_CODESPACE_TOKEN:-}" ]; then
    echo "GitHub Codespaces environment detected"
    # Only set to interactive if actually in a terminal
    if [ -t 0 ] && [ -t 1 ]; then
      is_interactive=true
      export CHEZMOI_INTERACTIVE=1
      echo "Running in interactive Codespaces session"
    fi
  fi

  echo "Set CHEZMOI_INTERACTIVE=$CHEZMOI_INTERACTIVE"
fi

# Define common variables
bin_dir="${HOME}/.local/bin"
target_chezmoi="${bin_dir}/chezmoi"

# Create bin directory if it doesn't exist
mkdir -p "${bin_dir}"

# Check for download tools and get installation script
if command -v curl >/dev/null; then
  chezmoi_install_script="$(curl -fsSL https://chezmoi.io/get)"
elif command -v wget >/dev/null; then
  chezmoi_install_script="$(wget -qO- https://chezmoi.io/get)"
else
  echo "To install chezmoi, you must have curl or wget installed." >&2
  exit 1
fi

# Install or update chezmoi
echo "Installing/updating chezmoi to '${target_chezmoi}'" >&2
sh -c "${chezmoi_install_script}" -- -b "${bin_dir}"
unset chezmoi_install_script

# Add bin_dir to PATH for the current session
PATH="${bin_dir}:${PATH}"
export PATH

# POSIX way to get script's dir: https://stackoverflow.com/a/29834779/12156188
script_dir="$(cd -P -- "$(dirname -- "$(command -v -- "$0")")" && pwd -P)"

# Set up chezmoi arguments
chezmoi_args="init --source=${script_dir}"

# Add apply flag if appropriate
if [ "$CHEZMOI_INTERACTIVE" = "1" ]; then
  # In interactive mode, ask before applying
  printf "Do you want to apply the configuration now? [Y/n] "
  read -r apply_now
  apply_now=${apply_now:-y}
  if [ "$apply_now" = "y" ] || [ "$apply_now" = "Y" ]; then
    chezmoi_args="${chezmoi_args} --apply"
  fi
else
  # In non-interactive mode, always apply
  chezmoi_args="${chezmoi_args} --apply"
fi

echo "Running 'chezmoi ${chezmoi_args}'" >&2
# exec: replace current process with chezmoi
exec "${target_chezmoi}" ${chezmoi_args}
