#!/usr/bin/env nu

# create_work.nu
# This script creates a secrets.nu file if it doesn't exist

def main [] {
    let work_file = ($env.HOME | path join ".config/nushell/work.nu")

    if not ($secrets_file | path exists) {
        print $"Creating ($secrets_file)..."

        let content = "# work.nu
#
# This file is for sensitive configuration that should not be tracked in git.
# It is sourced by config.nu.
#
# Examples of what might go here:
# - AWS assume IAM role helpers
# - Work-specific configurations that contain sensitive information
#
# This file is excluded from git tracking via .gitignore

# Example (commented out):
# alias burn_production = aws redshift global-db exec - DROP TABLE users;
"
        $content | save -f $secrets_file
    }
}

main

