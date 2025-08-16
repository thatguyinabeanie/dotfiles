#!/bin/bash

{{- if lookPath "nu" }}

##
## OPENCODE CONFIGURATION MANAGEMENT (Bash/Zsh Wrapper)
## Wrapper function that calls the Nushell implementation
##

# OpenCode configuration management with subcommands
# Usage: opencode-config <subcommand> [args]
function opencode-config() {
    if [[ $# -eq 0 ]]; then
        echo "❌ Subcommand required"
        echo ""
        echo "Available subcommands:"
        echo "  update         - Update AI configuration from models.dev API"
        echo "  list-providers - Show available providers"
        echo "  list-models    - Show models for a provider (requires provider name)"
        echo "  validate       - Validate current configuration"
        echo ""
            echo "Usage: opencode-config <subcommand> [args]"
        return 1
    fi
    
    local subcommand="$1"
    shift
    
    case "$subcommand" in
        "update")
            nu -c "source '{{ .chezmoi.sourceDir }}/.chezmoitemplates/opencode/generate.nu'; opencode-config update"
            ;;
        "list-providers")
            nu -c "source '{{ .chezmoi.sourceDir }}/.chezmoitemplates/opencode/generate.nu'; opencode-config list-providers"
            ;;
        "list-models")
            if [[ $# -eq 0 ]]; then
                echo "❌ Provider name required for list-models subcommand"
                echo "Usage: opencode-config list-models <provider>"
                echo "💡 Example: opencode-config list-models github-copilot"
                return 1
            fi
            nu -c "source '{{ .chezmoi.sourceDir }}/.chezmoitemplates/opencode/generate.nu'; opencode-config list-models '$1'"
            ;;
        "validate")
            nu -c "source '{{ .chezmoi.sourceDir }}/.chezmoitemplates/opencode/generate.nu'; opencode-config validate"
            ;;
        *)
            echo "❌ Unknown subcommand: $subcommand"
            echo ""
            echo "Available subcommands:"
            echo "  update         - Update AI configuration from models.dev API"
            echo "  list-providers - Show available providers"
            echo "  list-models    - Show models for a provider (requires provider name)"
            echo "  validate       - Validate current configuration"
            echo ""
        echo "Usage: opencode-config <subcommand> [args]"
            return 1
            ;;
    esac
}

{{- end }}
