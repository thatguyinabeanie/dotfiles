# Secrets Management

This document outlines the approach for managing sensitive environment variables using platform-specific secure storage.

## Overview

For work environments, we use macOS Keychain to securely store API keys, tokens, and other secrets. This approach:

- Keeps secrets out of version control
- Uses OS-native secure storage
- Integrates seamlessly with Chezmoi templates
- Supports different environments (work vs personal)

## Storage Strategy

### Keychain Entry Naming Convention

Use consistent prefixes to organize secrets:

```bash
work-github-token      # Work GitHub personal access token
work-openai-key        # Work OpenAI API key
work-slack-token       # Work Slack bot token
personal-github-token  # Personal GitHub token
personal-openai-key    # Personal OpenAI key
```

### Storing Secrets

Store secrets in Keychain using the `security` command:

```bash
# Add a new secret
security add-generic-password -a "$USER" -s "work-github-token" -w "ghp_xxxxxxxxxxxx"

# Update an existing secret
security add-generic-password -a "$USER" -s "work-github-token" -w "ghp_new_token" -U

# List all stored secrets (names only)
security dump-keychain | grep -E '(work-|personal-)'
```

### Retrieving Secrets

Retrieve secrets using:

```bash
# Get secret value
security find-generic-password -a "$USER" -s "work-github-token" -w

# Get secret with error suppression
security find-generic-password -a "$USER" -s "work-github-token" -w 2>/dev/null
```

## Integration Approaches

### Option 1: Direct Chezmoi Templates

Use Chezmoi's `output` function to call security directly in templates:

```yaml
# .chezmoidata/secrets/work.yaml.tmpl
{{- if and (eq .chezmoi.os "darwin") (.work_environment) }}
github_token: {{ output "security" "find-generic-password" "-a" .chezmoi.username "-s" "work-github-token" "-w" | trim | quote }}
openai_key: {{ output "security" "find-generic-password" "-a" .chezmoi.username "-s" "work-openai-key" "-w" | trim | quote }}
{{- end }}
```

### Option 2: Helper Script + Mise Integration

Create a helper script for standardized secret retrieval:

```bash
# .local/bin/keychain-env
#!/bin/bash
# Custom script to retrieve secrets from Keychain

case "$1" in
  work-*)
    security find-generic-password -a "$USER" -s "$1" -w 2>/dev/null
    ;;
  personal-*)
    security find-generic-password -a "$USER" -s "$1" -w 2>/dev/null
    ;;
  *)
    echo "Unknown secret: $1" >&2
    exit 1
    ;;
esac
```

Then use with mise:

```toml
# .config/mise/config.toml (work profile)
[env]
GITHUB_TOKEN = { script = "keychain-env work-github-token" }
OPENAI_API_KEY = { script = "keychain-env work-openai-key" }
SLACK_BOT_TOKEN = { script = "keychain-env work-slack-token" }
```

### Option 3: Shell Profile Integration

Add secret loading directly to shell configuration:

```zsh
# .zshrc.tmpl work environment section
{{- if and (eq .chezmoi.os "darwin") (.work_environment) }}
# Load work secrets from Keychain
export GITHUB_TOKEN="$(security find-generic-password -a "$USER" -s "work-github-token" -w 2>/dev/null)"
export OPENAI_API_KEY="$(security find-generic-password -a "$USER" -s "work-openai-key" -w 2>/dev/null)"
export SLACK_BOT_TOKEN="$(security find-generic-password -a "$USER" -s "work-slack-token" -w 2>/dev/null)"
{{- end }}
```

## Environment Detection

### Work Environment Detection

Determine if running on a work machine using:

```yaml
# .chezmoi.toml.tmpl
[data]
work_environment = {{ or (contains "work" .chezmoi.hostname) (contains "corp" .chezmoi.fqdnHostname) }}
```

Or prompt during initial setup:

```yaml
# .chezmoi.toml.tmpl
[data]
work_environment = {{ promptBoolOnce . "work_environment" "Is this a work machine" }}
```

## Security Considerations

### Best Practices

1. **Never commit secrets** - Use `.chezmoiignore` for any files containing actual secret values
2. **Rotate regularly** - Update stored secrets when they expire
3. **Principle of least privilege** - Only store secrets needed on each machine
4. **Backup strategy** - Document how to restore secrets on new machines

### Error Handling

Handle missing or inaccessible secrets gracefully:

```bash
# In helper script
if ! secret_value=$(security find-generic-password -a "$USER" -s "$1" -w 2>/dev/null); then
    echo "Warning: Secret '$1' not found in Keychain" >&2
    exit 1
fi
echo "$secret_value"
```

### Keychain Access

Ensure scripts can access Keychain:

```bash
# Test Keychain access
if ! security find-generic-password -a "$USER" -s "test" -w >/dev/null 2>&1; then
    echo "Keychain access may require user interaction"
fi
```

## Setup Workflow

### Initial Secret Storage

1. Identify required secrets for your work environment
2. Store each secret using consistent naming:

   ```bash
   security add-generic-password -a "$USER" -s "work-github-token" -w "your_token_here"
   ```

3. Test retrieval:

   ```bash
   security find-generic-password -a "$USER" -s "work-github-token" -w
   ```

### New Machine Setup

1. Apply Chezmoi configuration
2. Store required secrets in Keychain
3. Verify environment variables are loaded:

   ```bash
   echo $GITHUB_TOKEN
   mise env | grep -E "(GITHUB|OPENAI|SLACK)"
   ```

## Troubleshooting

### Common Issues

**Keychain Access Denied**

- Run `security unlock-keychain` to unlock the default keychain
- Check System Preferences > Security & Privacy > Privacy > Full Disk Access

**Secret Not Found**

- Verify secret name matches exactly (case-sensitive)
- List all secrets: `security dump-keychain | grep "work-"`

**Environment Variables Not Set**

- Check mise configuration: `mise config`
- Verify helper script permissions: `chmod +x ~/.local/bin/keychain-env`
- Test script directly: `keychain-env work-github-token`

### Debug Commands

```bash
# List all Keychain entries
security dump-keychain

# Test specific secret retrieval
security find-generic-password -a "$USER" -s "work-github-token" -w

# Check mise environment loading
mise env | grep GITHUB_TOKEN

# Verify helper script
which keychain-env && keychain-env work-github-token
```
