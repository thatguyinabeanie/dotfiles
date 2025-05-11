# 🛡️ Git Hooks Configuration

<!-- markdownlint-disable MD013 -->
This directory contains configuration for Git hooks, including pre-commit hooks that enforce code quality standards and catch issues before they're committed.
<!-- markdownlint-enable MD013 -->

<!-- markdownlint-disable MD013 MD045 -->
<img src="https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/212.png" width="150" />
<!-- markdownlint-enable MD013 MD045 -->

## 🌟 Features

### 🚀 Pre-commit Hooks

- **Automated Code Quality Checks**: Ensures consistent code style and prevents common issues
- **Security Scanning**: Detects secrets and sensitive information before they're committed
- **Language-specific Linting**: Validates Go, Shell, Markdown, and YAML files
- **Chezmoi Validation**: Ensures dotfiles templates are correctly formatted

## 📋 Included Hooks

### Code Quality
- Trailing whitespace removal
- End-of-file fixer
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

The pre-commit hooks are automatically installed when you apply the dotfiles with Chezmoi:

```bash
chezmoi apply
```

### Manual Installation

If you need to install the hooks manually:

```bash
# Install pre-commit if not already installed
brew install pre-commit

# Install the hooks
pre-commit install
pre-commit install --hook-type commit-msg
pre-commit install --hook-type pre-push
```

## 🧪 Running Hooks Manually

You can run all hooks against all files:

```bash
pre-commit run --all-files
```

Or run a specific hook:

```bash
pre-commit run <hook-id> --all-files
```

## 🔍 Skipping Hooks

In rare cases where you need to bypass the hooks:

```bash
git commit -m "Your message" --no-verify
```

**Note**: This should be used sparingly and only when absolutely necessary.

## 📝 Configuration

The pre-commit configuration is defined in `.pre-commit-config.yaml` at the repository root.

## 🔄 Updating Hooks

To update all hooks to their latest versions:

```bash
pre-commit autoupdate
```

<!-- markdownlint-disable MD033 MD013 MD045 -->
<div align="center">
<img src="https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/213.png" width="100" />

Made with ❤️ and version control magic
</div>
<!-- markdownlint-enable MD033 MD013 MD045 -->
