#!/usr/bin/env zsh

# create_work.zsh
# This script creates a work.zsh file if it doesn't exist

work_file="$HOME/.config/zsh/work.zsh"

if [[ ! -f "$work_file" ]]; then
  echo "Creating $work_file..."

  cat >"$work_file" <<'EOF'
# work.zsh
#
# This file is for sensitive configuration that should not be tracked in git.
# It is sourced by .zshrc.
#
# Examples of what might go here:
# - AWS assume IAM role helpers
# - Work-specific configurations that contain sensitive information
#
# This file is excluded from git tracking via .gitignore

# Example (commented out):
# alias burn_production="aws redshift global-db exec - DROP TABLE users;"
EOF
fi
