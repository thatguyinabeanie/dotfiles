# 🛡️ Git Hooks Configuration (Lefthook)

This directory contains custom Git hooks managed by [Lefthook](https://github.com/evilmartians/lefthook).

## Features

- **Security Scanning**: Detects secrets and sensitive information before they're committed.
- **Language-specific Linting**: Validates Go, Shell, Markdown, and YAML files.
- **Chezmoi Validation**: Ensures dotfiles templates are correctly formatted.

## Usage

Hooks are automatically installed and run by Lefthook. You can run them manually with:

```bash
lefthook run pre-commit
```

## Customization

Edit the scripts in this directory or update `lefthook.yml` to add or modify hooks.

## 🌟 Features

### 🚀 Pre-commit Hooks (via Lefthook)

- **Automated Code Quality Checks**: Ensures consistent code style and prevents common issues
- **Security Scanning**: Detects secrets and sensitive information before they're committed
- **Language-specific Linting**: Validates Go, Shell, Markdown, and YAML files
- **Chezmoi Validation**: Ensures dotfiles templates are correctly formatted

## 📋 Included Hooks

### Code Quality

- Trailing whitespace removal (via custom scripts or linters)
- End-of-file fixer (via custom scripts or linters)
- Mixed line ending fixer (standardizes to LF)
- Large file detection
- Merge conflict detection
- Executable script validation

### Security

- Secret scanning with Gitleaks
- Private key detection

### Language-specific Linting

- **Go**: golangci-lint
- **Shell**: shellcheck
- **Markdown**: markdownlint
- **YAML**: yamllint

### Chezmoi Validation

- Template format checking
- Go tests for dotfiles

## 🔧 Installation

The Lefthook-based hooks are automatically installed when you apply the dotfiles with Chezmoi:

```bash
chezmoi apply
```

### Manual Installation

If you need to install the hooks manually:

```bash
# Install lefthook if not already installed
brew install lefthook

# Install the hooks
lefthook install
```

## 🧪 Running Hooks Manually

You can run all hooks against all files:

```bash
lefthook run pre-commit
```

Or run a specific hook:

```bash
lefthook run pre-commit --only <hook-name>
```

## 🔍 Skipping Hooks

In rare cases where you need to bypass the hooks:

```bash
git commit -m "Your message" --no-verify
```

**Note**: This should be used sparingly and only when absolutely necessary.

## 📝 Configuration

The Lefthook configuration is defined in `lefthook.yml` at the repository root.

## 🔄 Updating Hooks

To update all hooks to their latest versions, update the scripts or tools they call (e.g., via Homebrew or npm).

<div align="center">
<img src="https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/213.png" width="100" />

Made with ❤️ and version control magic
</div>
