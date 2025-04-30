#!/bin/sh
# This script must be POSIX-compliant.

# -e: exit on error
# -u: exit on unset variables
set -eu

# Define common variables
bin_dir="${HOME}/.local/bin"
target_chezmoi="${bin_dir}/chezmoi"

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

# POSIX way to get script's dir: https://stackoverflow.com/a/29834779/12156188
script_dir="$(cd -P -- "$(dirname -- "$(command -v -- "$0")")" && pwd -P)"

set -- init --apply --source="${script_dir}"

echo "Running 'chezmoi $*'" >&2
# exec: replace current process with chezmoi
exec "${target_chezmoi}" "$@"
