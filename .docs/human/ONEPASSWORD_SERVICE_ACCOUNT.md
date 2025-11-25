# 1Password Service Account Setup Guide

This guide walks you through setting up a 1Password service account for your work laptop,
allowing limited, automated access to specific secrets without the full 1Password Desktop app.

## Overview

Your dotfiles support two authentication methods:

- **Personal Environment**: 1Password Desktop App with full interactive access
- **Work Environment**: 1Password Service Account with limited, token-based access

## Why Use a Service Account?

Service accounts are ideal for work laptops because they:

- Provide **non-interactive authentication** (no manual sign-in)
- Offer **limited, scoped access** to specific vaults/items
- Work **without the desktop app** (CLI-only access)
- Are **token-based** (no need to enter credentials)

## Prerequisites

1. 1Password account with **Business/Teams/Enterprise** plan (service accounts require paid plans)
2. Access to create service accounts in your 1Password account
3. 1Password CLI installed (already managed by your dotfiles via Homebrew)

## Step 1: Create Service Account

### Via 1Password Web Interface

1. Sign in to your 1Password account at <https://my.1password.com>
2. Navigate to **Settings** → **Service Accounts**
3. Click **Create Service Account**
4. Give it a name (for example, "Work Laptop - Limited Access")
5. **Grant access to specific vaults**:
   - Only add vaults containing secrets you need on work laptop
   - Recommended: Create a dedicated "Work Automation" vault
   - **Do NOT grant full access** to personal vaults

### Permissions Best Practices

Grant the **minimum required access**:

```text
✅ Recommended Access:
- Work Automation vault (read-only)
- Specific items: API keys, work SSH keys, work tokens

❌ Avoid:
- Full vault access
- Write permissions (unless absolutely necessary)
- Personal vault access
```

## Step 2: Save Service Account Token

After creating the service account, 1Password will show you the token **once**. It looks like:

```text
ops_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

### Option A: Environment Variable (Recommended)

Add to your shell profile (outside of chezmoi-managed files):

**For Zsh** (`~/.zshenv` or `~/.zshrc.local`):

```bash
export OP_SERVICE_ACCOUNT_TOKEN='ops_your_token_here'
```

**For Nushell** (`~/.config/nushell/env.local.nu`):

```nushell
$env.OP_SERVICE_ACCOUNT_TOKEN = 'ops_your_token_here'
```

**For Bash** (`~/.bashrc.local` or `~/.bash_profile.local`):

```bash
export OP_SERVICE_ACCOUNT_TOKEN='ops_your_token_here'
```

### Option B: File-Based (Alternative)

Store in a secure file:

```bash
# Create secure config directory
mkdir -p ~/.config/op
chmod 700 ~/.config/op

# Save token
echo 'ops_your_token_here' > ~/.config/op/service-account-token
chmod 600 ~/.config/op/service-account-token
```

Then update `.chezmoidata/onepassword.yaml`:

```yaml
work:
  token_source: "file"
```

### Important Security Notes

⚠️ **Never commit the token to git**

The token file locations above are intentionally **outside** the chezmoi-managed directory to prevent accidental commits.

✅ **Recommended**: Use your password manager or secure storage for the token
✅ **Recommended**: Set token rotation policy (for example, rotate every 90 days)
✅ **Recommended**: Create separate service accounts per machine

## Step 3: Track Token Creation Date (Recommended)

To enable token age tracking and rotation reminders, record when you created the token:

```bash
defaults write com.chezmoi.config op_token_created_date -int $(date +%s)
```

This enables:

- Automatic warnings when token approaches 90-day rotation
- Token age display in `op-helper status`
- Token expiry tracking in `op-helper token-info`

## Step 4: Configure Automatic Secret Loading (Optional)

Edit `.chezmoidata/onepassword.yaml` to define secrets that should automatically load
into environment variables on shell startup:

```yaml
onepassword:
  work:
    secrets:
      # GitHub API Token
      - vault: "Work Automation"
        item: "GitHub API Token"
        field: "credential"
        env_var: "GITHUB_TOKEN"

      # AWS Credentials
      - vault: "Work Automation"
        item: "AWS Access Key"
        field: "credential"
        env_var: "AWS_ACCESS_KEY_ID"

      # SSH Key (if needed)
      - vault: "Work Automation"
        item: "Work SSH Key"
        field: "private key"
        env_var: "WORK_SSH_PRIVATE_KEY"
```

**Benefits:**

- Secrets load automatically on shell startup
- Results are cached for 1 hour to avoid repeated CLI calls
- Environment variables available to all processes in the shell

## Step 5: Verify Setup

After setting the token and restarting your shell:

```bash
# Check status
op-helper status

# Validate service account
op-helper validate

# Test retrieving a secret
op-helper get "Work Automation" "GitHub API Token" credential
```

Expected output:

```text
1Password Configuration Status
================================
Environment: Work
Auth Method: Service Account

Service Account Token: Set
Authentication: Valid
```

## Using the Service Account

### Command-Line Usage

The `op-helper` script provides a unified interface:

```bash
# Get a secret
op-helper get <vault> <item> [field]

# Examples:
op-helper get "Work Automation" "GitHub Token" credential
op-helper get "Work Automation" "API Key" password

# Check detailed status
op-helper status

# Validate authentication and access
op-helper validate

# Show token age and rotation info
op-helper token-info

# Rotate service account token
op-helper rotate-token
```

### Automatic Secret Loading

If you configured secrets in `.chezmoidata/onepassword.yaml`, they'll automatically load when you start a new shell:

```bash
# Secrets are available as environment variables
echo $GITHUB_TOKEN
echo $AWS_ACCESS_KEY_ID

# Cache is stored in ~/.cache/op-secrets.cache
# Cache expires after 1 hour to balance performance and security
```

### In Scripts and Automation

```bash
#!/usr/bin/env bash

# Retrieve GitHub token
GITHUB_TOKEN=$(op-helper get "Work Automation" "GitHub Token" credential)

# Use it
curl -H "Authorization: Bearer $GITHUB_TOKEN" https://api.github.com/user
```

### In Chezmoi Templates

You can use `op` CLI directly in templates (work environment only):

```template
{{- if eq .WORK_ENVIRONMENT true }}
# This will use service account automatically
export GITHUB_TOKEN="{{ output "op" "item" "get" "GitHub Token" \
  "--vault" "Work Automation" "--fields" "credential" | trim }}"
{{- end }}
```

## Troubleshooting

### "Service account authentication failed"

**Causes:**

- Token not set or incorrect
- Token expired
- Service account disabled

**Solutions:**

```bash
# 1. Verify token is set
echo $OP_SERVICE_ACCOUNT_TOKEN

# 2. Test authentication
op whoami

# 3. Regenerate token if needed (from 1Password web interface)
```

### "Failed to retrieve item"

**Causes:**

- Service account doesn't have access to that vault/item
- Item name or vault name incorrect
- Insufficient permissions

**Solutions:**

```bash
# 1. List accessible vaults
op vault list

# 2. Check vault access in 1Password web interface
# 3. Verify item exists and service account has read access
```

### Token Not Persisting Across Sessions

**Solution**: Ensure token is set in shell profile, not just current session:

```bash
# Add to ~/.zshenv (not ~/.zshrc)
export OP_SERVICE_ACCOUNT_TOKEN='ops_xxx'
```

## Token Rotation

### Automatic Rotation Reminders

If you tracked the token creation date, you'll automatically receive warnings when the token approaches 90
days old:

```text
⚠️  1Password service account token is 85 days old
   Consider rotating soon (recommended: every 90 days)
   Run: op-rotate
```

These warnings appear:

- Once per day maximum (non-intrusive)
- Starting at day 85
- On shell startup

### Manual Token Rotation

To rotate your service account token:

```bash
# Interactive rotation wizard
op-helper rotate-token
```

The wizard will:

1. Show current token age
2. Guide you through creating a new token
3. Validate the new token before applying
4. Help you save it securely
5. Record the new creation date
6. Remind you to revoke the old token

### Manual Rotation Steps

If you prefer to rotate manually:

1. **Create new token** in 1Password web interface
2. **Test the new token**:

   ```bash
   OP_SERVICE_ACCOUNT_TOKEN='ops_new_token' op whoami
   ```

3. **Update your configuration**:

   ```bash
   # Update environment variable or token file
   echo 'ops_new_token' > ~/.config/op/service-account-token
   ```

4. **Record creation date**:

   ```bash
   defaults write com.chezmoi.config op_token_created_date -int $(date +%s)
   ```

5. **Verify**:

   ```bash
   op-helper validate
   ```

6. **Revoke old token** in 1Password web interface

## Security Best Practices

### Token Management

1. **Rotate tokens regularly** (recommend: every 90 days)
2. **Track token creation date** for automatic reminders
3. **Use separate tokens per machine** (don't share across devices)
4. **Revoke old tokens immediately** after rotation
5. **Monitor service account usage** in 1Password web interface

### Access Control

1. **Principle of least privilege**: Only grant access to required vaults
2. **Read-only when possible**: Avoid write permissions
3. **Dedicated vaults**: Create separate vaults for automation secrets
4. **Regular audits**: Review service account access monthly

### Token Storage

1. **Never commit to git** or share publicly
2. **Use secure file permissions** (600 or 400)
3. **Consider using OS keychain** for additional security
4. **Document token location** securely (password manager)

## Comparison: Personal vs Work

| Feature             | Personal                      | Work                                |
| ------------------- | ----------------------------- | ----------------------------------- |
| **Authentication**  | Interactive (Desktop App)     | Non-interactive (Service Account)   |
| **Access Scope**    | Full account access           | Limited to specific vaults          |
| **Setup**           | Desktop app required          | Token-based, CLI-only               |
| **Best For**        | Daily use, full access        | Automation, limited access          |
| **SSH Agent**       | ✅ Integrated                  | ❌ Use traditional keys              |

## Advanced Features

### Secret Caching

Automatic secret loading uses intelligent caching:

- **Cache Location**: `~/.cache/op-secrets.cache`
- **Cache Duration**: 1 hour (3600 seconds)
- **Benefits**: Reduces 1Password CLI calls, improves shell startup time
- **Security**: Cache file has 600 permissions (user-only access)

To clear the cache:

```bash
rm ~/.cache/op-secrets.cache
```

### Personal Environment Support

All features also work in personal environment (Desktop App):

```bash
# Enhanced validation checks SSH agent, vaults, authentication
op-helper validate

# Shows SSH agent status, vault access, token info
op-helper status

# Automatic secret loading works with Desktop App too
# Configure in .chezmoidata/onepassword.yaml under personal.secrets
```

### Cross-Shell Support

All features work identically in:

- **Zsh**: Primary shell with full support
- **Nushell**: Complete parallel implementation
- **Bash**: Compatible (if you add similar integration)

## Next Steps

1. ✅ Create service account in 1Password
2. ✅ Save token securely (environment variable or file)
3. ✅ Track token creation date for rotation reminders
4. ✅ Configure automatic secret loading (optional)
5. ✅ Test with `op-helper validate`
6. ✅ Use in scripts and automation
7. ✅ Set calendar reminder for token rotation (90 days)

## Additional Resources

- [1Password Service Accounts Documentation](https://developer.1password.com/docs/service-accounts/)
- [1Password CLI Documentation](https://developer.1password.com/docs/cli/)
- [Service Account Best Practices](https://developer.1password.com/docs/service-accounts/best-practices/)

## Getting Help

If you encounter issues:

1. Run `op-helper status` to check configuration
2. Check 1Password service account in web interface
3. Verify token is correctly set and not expired
4. Review access permissions for required vaults/items

For 1Password-specific issues, consult: <https://support.1password.com>
