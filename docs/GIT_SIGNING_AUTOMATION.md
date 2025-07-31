# Automated Git Commit Signing with 1Password

This document outlines the plan for implementing automated git commit signing using 1Password SSH keys in the chezmoi dotfiles repository.

## Overview

The goal is to configure the dotfiles repository so that running `chezmoi init` and `chezmoi apply` on a brand new system will automatically set up git commit signing using 1Password SSH keys, with no manual intervention required.

## Implementation Plan

### Phase 1: Research & Foundation

1. **Research current git configuration in dotfiles** - Check `MISSION_CONTROL/dot_config/git/` for current git config templates
2. **Check existing 1Password SSH configuration** - Look at existing SSH configuration in `MISSION_CONTROL/private_dot_ssh/` and `MISSION_CONTROL/dot_config/1Password/`

### Phase 2: Automated Installation & Prerequisites

1. **Create chezmoi script to install 1Password CLI** - Create `run_once_before-XX-install-1password-cli.sh` in `.chezmoiscripts/`
2. **Create script to configure 1Password SSH agent** - Script to enable SSH agent in 1Password app settings

### Phase 3: Automated Key Management

1. **Add 1Password authentication check script** - Verify user is logged into 1Password
2. **Create automated SSH signing key setup script** - Script to automatically create SSH key in 1Password if it doesn't exist
3. **Key retrieval automation** - Script to get the public key from 1Password for git configuration

### Phase 4: Configuration Templates

1. **Configure git to use 1Password SSH agent for signing** - Update git configuration to use SSH signing
2. **Update git config templates for commit signing** - Modify `.gitconfig.tmpl` with conditional signing configuration

### Phase 5: Testing & Documentation

1. **Test signed commit configuration** - Verify that commits are properly signed
2. **Document the automated setup process** - Add comprehensive documentation

## Proposed File Structure

### Chezmoi Scripts

```bash
MISSION_CONTROL/.chezmoiscripts/
├── run_once_before-XX-install-1password-cli.sh
├── run_onchange_after-XX-setup-git-signing.sh.tmpl
└── run_once_after-XX-configure-1password-ssh.sh
```

### Configuration Templates

```text
MISSION_CONTROL/dot_config/
├── git/
│   ├── config.tmpl (enhanced with signing configuration)
│   └── gitconfig.tmpl (conditional signing setup)
└── 1Password/
    └── ssh/
        └── agent.toml.tmpl (SSH agent configuration)
```

## Key Automation Features

### Smart Detection

- Check if 1Password CLI is installed
- Verify 1Password SSH agent is enabled
- Detect if signing key already exists
- Handle first-time setup vs. existing configurations

### Conditional Execution

- Only run scripts when 1Password is available/installed
- Graceful fallbacks if 1Password isn't set up
- Cross-platform compatibility (macOS, Linux)

### Idempotent Operations

- Scripts can run multiple times safely
- No duplicate key creation
- Handles partial configurations gracefully

### Error Handling

- Fallback configurations for systems without 1Password
- Clear error messages for missing prerequisites
- Continue setup even if signing setup fails

## Implementation Components

### 1Password CLI Installation

```bash
# Check if 1Password CLI is installed
# Install via package manager if missing
# Verify installation success
```

### SSH Agent Configuration

```bash
# Enable 1Password SSH agent
# Configure SSH to use 1Password agent
# Verify agent is running
```

### SSH Signing Key Setup

```bash
# Check if git signing key exists in 1Password
# Generate new SSH key for signing if needed
# Retrieve public key for git configuration
```

### Git Configuration Templates

```toml
# Conditional signing configuration
{{- if .onepassword.available }}
[commit]
    gpgsign = true
[gpg]
    format = ssh
[gpg "ssh"]
    program = "/Applications/1Password 7 - Password Manager.app/Contents/MacOS/op-ssh-sign"
    allowedSignersFile = ~/.config/git/allowed_signers
[user]
    signingkey = {{ .onepassword.git_signing_key }}
{{- end }}
```

## Benefits

### Security

- SSH keys stored securely in 1Password
- No plaintext keys on filesystem
- Centralized key management

### Convenience

- Automatic setup on new systems
- No manual key generation
- Seamless integration with existing workflow

### Modern Approach

- SSH signing is simpler than GPG signing
- Better integration with modern tools
- Reduced complexity compared to GPG

### Maintainability

- Declarative configuration
- Version controlled setup
- Consistent across all systems

## Prerequisites

1. 1Password app installed on the system
2. 1Password account with SSH key storage capability
3. User logged into 1Password
4. SSH agent enabled in 1Password settings

## Testing Strategy

1. Test on clean macOS system
2. Test on clean Linux system
3. Test with existing 1Password setup
4. Test without 1Password installed
5. Verify signed commits work correctly
6. Test key rotation scenarios

## Future Enhancements

- Support for multiple signing keys
- Integration with GitHub/GitLab SSH key upload
- Automated key rotation
- Team/organization key management
- Integration with other git hosting services

## References

- [1Password SSH Agent Documentation](https://developer.1password.com/docs/ssh/)
- [Git SSH Signing Documentation](https://docs.github.com/en/authentication/managing-commit-signature-verification/about-commit-signature-verification#ssh-commit-signature-verification)
- [Chezmoi Scripting Guide](https://www.chezmoi.io/user-guide/use-scripts-to-perform-actions/)
