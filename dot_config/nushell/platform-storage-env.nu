# Platform environment variable management for nushell

def _platform_env_backend [] {
    if ($env.WORK_ENVIRONMENT? | default false) == "true" {
        "defaults"
    } else {
        "1password"
    }
}

# Set environment variable
export def setenv [key: string, value: string] {
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

# Get environment variable  
export def getenv [key: string] {
    match (_platform_env_backend) {
        "defaults" => {
            ^defaults read com.chezmoi.env $key o+e>| complete | get stdout | str trim
        }
        "1password" => {
            print "1Password integration not yet implemented"
        }
    }
}

# List environment variables
export def listenv [] {
    match (_platform_env_backend) {
        "defaults" => {
            print "Platform environment variables (defaults):"
            let result = (^defaults read com.chezmoi.env o+e>| complete)
            if $result.exit_code == 0 {
                $result.stdout | lines | where {|line| $line =~ '^\s*"[A-Za-z_]'} | each {|line| 
                    $line | str trim | str replace-all '"' '' | split column '=' | get column1
                } | sort
            } else {
                print "  (none set)"
            }
        }
        "1password" => {
            print "1Password integration not yet implemented"
        }
    }
}

# Delete environment variable
export def delenv [key: string] {
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