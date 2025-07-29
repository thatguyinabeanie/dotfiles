# Chezmoi Template System

This repository uses an advanced Chezmoi template system that provides dynamic configuration based on environment, interaction mode, and user preferences.

## 🏗️ Template Architecture

### Configuration Flow

```
Environment Detection → Interactive Prompts → Variable Processing → Template Rendering
```

### Key Template Files

- **`.chezmoi.toml.tmpl`** - Main configuration template
- **`**/\*.tmpl`\*\* - Individual config file templates (47+ files)
- **Environment Variables** - Runtime configuration overrides

## 🔧 Interactive vs Non-Interactive Modes

The template system detects whether it's running in an interactive session and behaves differently:

### Interactive Mode (`CHEZMOI_INTERACTIVE=1` or TTY detected)

```go
{{- if $interactive }}
    {{- $GIT_NAME = promptStringOnce . "git.config.name" "👥 Git Config 👥 - Name" -}}
    {{- $WORK_ENVIRONMENT = promptBoolOnce . "WORK_ENVIRONMENT" "💻 Is this environment for work" false -}}
{{- end }}
```

**Behavior**:

- Prompts user for configuration values
- Stores responses in Chezmoi state for future use
- Allows customization of all settings

### Non-Interactive Mode (CI/CD, Scripts)

**Behavior**:

- Uses environment variables if available
- Falls back to sensible defaults
- Never prompts for user input
- Suitable for automated deployments

## 🌍 Environment Detection

### GitHub Codespaces

```go
{{- if env "CODESPACES" | not | not -}}
  {{- $is_codespace = true -}}
  {{- $GIT_NAME = env "GITHUB_USER" | default "GitHub Codespaces User" -}}
{{- end -}}
```

**Special handling for**:

- Automatic Git configuration from GitHub user
- Codespace-specific defaults
- Network and security considerations

### Work vs Personal Environment

```go
{{- $WORK_ENVIRONMENT = promptBoolOnce . "WORK_ENVIRONMENT" "💻 Is this environment for work" false -}}
```

**Affects**:

- Git email configuration (work vs personal)
- Repository cloning (work repos vs personal)
- Tool configurations and themes

## 📋 Configuration Variables

### Core Variables

| Variable            | Interactive Prompt                   | Default          | Purpose            |
| ------------------- | ------------------------------------ | ---------------- | ------------------ |
| `GIT_NAME`          | "👥 Git Config 👥 - Name"            | "GitHub Actions" | Git commit author  |
| `GITHUB_USERNAME`   | "👥 Git Config 👥 - Github Username" | "github-actions" | GitHub integration |
| `WORK_ENVIRONMENT`  | "💻 Is this environment for work"    | `false`          | Environment type   |
| `SHELL`             | "💻 What is your preferred shell"    | `"nu"`           | Default shell      |
| `CATPPUCCIN_FLAVOR` | "🌈 Select a Catppuccin flavor"      | `"mocha"`        | Theme variant      |

### Theme System Integration

```toml
THEME_MODE = "dark"                    # Control behavior: system/dark/light
THEME_LIGHT = "catppuccin-latte"       # Light theme variant
THEME_DARK = "catppuccin-mocha"        # Dark theme variant
```

### Application-Specific Configuration

```toml
[data.ghostty]
window_height = "65"
opacity = "0.8"
font_family = "Dank Mono"

[data.git.config]
defaultRefreshPeriod = "168h"
work_org = "totally_real_git_org_for_work"
```

## 🔄 Template Processing Flow

### 1. Environment Detection

```go
{{- $interactive := false -}}
{{- if eq (env "CHEZMOI_INTERACTIVE") "1" -}}
  {{- $interactive = true -}}
{{- else if stdinIsATTY -}}
  {{- $interactive = true -}}
{{- end -}}
```

### 2. Default Value Assignment

```go
{{- $GIT_NAME := "" -}}
{{- $GIT_EMAIL := "" -}}
{{- if $is_codespace -}}
  {{- $GIT_NAME = env "GITHUB_USER" | default "GitHub Codespaces User" -}}
{{- else -}}
  {{- $GIT_NAME = env "GIT_NAME" | default "GitHub Actions" -}}
{{- end -}}
```

### 3. Interactive Prompting (if applicable)

```go
{{- if $interactive }}
    {{- $GIT_NAME = promptStringOnce . "git.config.name" "👥 Git Config 👥 - Name" -}}
{{- end }}
```

### 4. Template Rendering

All variables are available in templates using `{{ .VARIABLE_NAME }}` syntax.

## 💡 Usage Examples

### Override Defaults with Environment Variables

```bash
export GIT_NAME="Your Name"
export GIT_EMAIL="your.email@example.com"
export WORK_ENVIRONMENT=true
chezmoi apply
```

### Force Non-Interactive Mode

```bash
export CHEZMOI_INTERACTIVE=0
chezmoi init --apply your-repo
```

### Customize During Setup

```bash
# Will prompt for all configuration values
chezmoi init --apply your-repo
```

## 🚨 Security Considerations

### Sensitive Data Handling

- **API Keys**: Use `{{ .ai.gemini_api_key }}` pattern with placeholder defaults
- **Work Organizations**: Template variable `{{ $.git.config.work_org }}` for flexibility
- **Email Addresses**: Different prompts for work vs personal email

### Best Practices

1. **Never hardcode secrets** in templates
2. **Use environment variable overrides** for CI/CD
3. **Validate input** in interactive prompts
4. **Provide secure defaults** for automated deployments

## 🔧 Troubleshooting

### Common Issues

**Template not updating**:

```bash
chezmoi re-add ~/.config/file
chezmoi apply
```

**Stuck in interactive mode**:

```bash
export CHEZMOI_INTERACTIVE=0
chezmoi apply
```

**Reset configuration**:

```bash
chezmoi state delete-bucket --bucket=promptOnceData
chezmoi apply
```

**Debug template rendering**:

```bash
chezmoi execute-template < template-file.tmpl
chezmoi data  # View all template variables
```

## 📚 Advanced Usage

### Conditional Configuration

```go
{{- if eq .WORK_ENVIRONMENT true }}
# Work-specific configuration
{{- else }}
# Personal configuration
{{- end }}
```

### Template Functions

```go
{{- if hasKey . "CUSTOM_VAR" }}
  {{- .CUSTOM_VAR }}
{{- else }}
  {{- "default-value" }}
{{- end }}
```

### External Data Integration

```go
{{- range .external_repos }}
["{{ .path }}"]
url = "{{ .url }}"
{{- end }}
```

This template system provides a powerful foundation for managing complex, environment-aware dotfile configurations across multiple machines and use cases.
