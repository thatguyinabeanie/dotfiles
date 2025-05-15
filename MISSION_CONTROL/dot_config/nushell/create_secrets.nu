#!/usr/bin/env nu

# create_secrets.nu
# This script creates a secrets.nu file if it doesn't exist

def main [] {
    let secrets_file = ($env.HOME | path join ".config/nushell/secrets.nu")

    if not ($secrets_file | path exists) {
        print $"Creating ($secrets_file)..."

        let content = "# secrets.nu
#
# This file is for sensitive configuration that should not be tracked in git.
# It is sourced by config.nu.
#
# Examples of what might go here:
# - API keys
# - Authentication tokens
# - Private environment variables
# - Work-specific configurations that contain sensitive information
#
# This file is excluded from git tracking via .gitignore

# Example (commented out):
# $env.SOME_API_KEY = \"your-api-key-here\"
"
        $content | save -f $secrets_file
    }
}

main
