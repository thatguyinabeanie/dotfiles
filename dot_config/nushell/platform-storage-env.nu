# Platform environment variable management for nushell
#
# Usage examples:
#   platform_storage_setenv API_KEY "sk-1234567890"    # or: pssetenv API_KEY "sk-1234567890"
#   platform_storage_getenv API_KEY                    # or: psgetenv API_KEY
#   platform_storage_listenv                           # or: pslistenv
#   platform_storage_delenv API_KEY                    # or: psdelenv API_KEY
#
# After setting variables, run 'chezmoi apply' to load them into your environment

def _platform_env_backend [] {
    if ($env.WORK_ENVIRONMENT? | default false) == "true" {
        "defaults"
    } else {
        "1password"
    }
}

# Set environment variable in platform storage
# Example: platform_storage_setenv API_KEY "sk-1234567890"
export def platform_storage_setenv [key: string, value: string] {
    match (_platform_env_backend) {
        "defaults" => {
            ^defaults write com.chezmoi.env $key -string $value
            print $"✓ Set ($key) in platform storage (defaults)"
        }
        "1password" => {
            print "1Password integration not yet implemented"
        }
    }
}

# Get environment variable from platform storage
# Example: platform_storage_getenv API_KEY
export def platform_storage_getenv [key: string] {
    match (_platform_env_backend) {
        "defaults" => {
            ^defaults read com.chezmoi.env $key o+e>| complete | get stdout | str trim
        }
        "1password" => {
            print "1Password integration not yet implemented"
        }
    }
}

# List all environment variables stored in platform storage
# Example: platform_storage_listenv
export def platform_storage_listenv [] {
    match (_platform_env_backend) {
        "defaults" => {
            print $"✓ Set ($key) in platform storage"
        }
        }
        "1password" => {
            print "1Password integration not yet implemented"
        }
    }
}

# Delete environment variable from platform storage
# Example: platform_storage_delenv API_KEY
export def platform_storage_delenv [key: string] {
    match (_platform_env_backend) {
        "defaults" => {
            let check = (^defaults read com.chezmoi.env $key o+e>| complete)
            if $check.exit_code == 0 {
                ^defaults delete com.chezmoi.env $key
                print $"✓ Removed ($key) from platform storage"
            } else {
                print $"Key ($key) not found"
            }
        }
        "1password" => {
            print "1Password integration not yet implemented"
        }
    }
}

# Shorter aliases for convenience
export alias pssetenv = platform_storage_setenv
export alias psgetenv = platform_storage_getenv  
export alias pslistenv = platform_storage_listenv
export alias psdelenv = platform_storage_delenv