# Git Configuration

A comprehensive Git configuration with custom aliases, hooks, and settings for enhanced productivity.

## Features

- **Custom Aliases**
  - Quick access to common Git commands
  - Enhanced workflow shortcuts
  - Repository management helpers

- **Git Hooks**
  - Pre-commit hooks
  - Post-merge hooks
  - Custom workflow automation

- **Global Settings**
  - Editor configuration
  - Default branch naming
  - Commit template
  - GPG signing

## Configuration Structure

The configuration is managed through Chezmoi templates:
- `config.tmpl` - Main Git configuration (Chezmoi template)
- `.chezmoiexternal.toml` - External template configuration
- `dot_gitignore` - Global gitignore patterns

## Installation

1. Clone this configuration using Chezmoi:
   ```bash
   chezmoi init --apply
   ```

2. Ensure Git is installed:
   ```bash
   brew install git
   ```

## Customization

### Global Settings
The configuration includes:
- Default editor settings
- Branch naming conventions
- Commit message templates
- GPG signing configuration

### Git Hooks
Custom hooks are available for:
- Pre-commit checks
- Post-merge actions
- Workflow automation

### Aliases
Common Git aliases include:
- Quick status checks
- Branch management
- Commit shortcuts
- Log formatting

## Dependencies

- Git 2.30+
- [Chezmoi](https://www.chezmoi.io/) (for dotfiles management)
- GPG (for commit signing)

## Contributing

Feel free to submit issues and enhancement requests! 