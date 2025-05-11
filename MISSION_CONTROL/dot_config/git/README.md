<!-- markdownlint-disable MD033 -->
<div align="center">
<!-- markdownlint-enable MD033 -->

# 🌿 Git Configuration 🔄

<!-- markdownlint-disable MD013 -->
A comprehensive Git configuration with custom aliases, hooks, and settings for enhanced productivity, managed with Chezmoi.
<!-- markdownlint-enable MD013 -->

<!-- markdownlint-disable MD013 MD045 -->
<img src="https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/387.png" width="150" />
<!-- markdownlint-enable MD013 MD045 -->

![Git](https://img.shields.io/badge/Git-2.30+-green?style=flat-square&logo=git)
![Chezmoi](https://img.shields.io/badge/Managed_with-Chezmoi-blue?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-yellow?style=flat-square)

<!-- markdownlint-disable MD033 -->
</div>
<!-- markdownlint-enable MD033 -->

## 🌟 Features

### 🚀 Custom Aliases

- Quick access to common Git commands
- Enhanced workflow shortcuts
- Repository management helpers

### 🔄 Git Hooks

- Pre-commit hooks
- Post-merge hooks
- Custom workflow automation

### ⚙️ Global Settings

- Editor configuration
- Default branch naming
- Commit template
- GPG signing

## 📁 Configuration Structure

The configuration is managed through Chezmoi templates:

```shell
git/
├── 📝 config.tmpl - Main Git configuration
├── 🔗 .chezmoiexternal.toml - External template configuration
└── 🚫 dot_gitignore - Global gitignore patterns
```

## 🌠 Installation

1. Clone this configuration using Chezmoi:

   ```shell
   chezmoi init --apply
   ```

2. Ensure Git is installed:

   ```shell
   brew install git
   ```

## ⚙️ Customization

### 🔧 Global Settings

The configuration includes:

- Default editor settings
- Branch naming conventions
- Commit message templates
- GPG signing configuration

### 🔄 Git Hooks

Custom hooks are available for:

- Pre-commit checks
- Post-merge actions
- Workflow automation

#### 🛡️ Pre-commit Hooks

The repository uses [pre-commit](https://pre-commit.com/) to enforce code quality standards:

- **Code Quality**
  - Trailing whitespace removal
  - End-of-file fixer
  - Mixed line ending fixer
  - Large file detection
  - Merge conflict detection

- **Security**
  - Secret scanning with Gitleaks
  - Private key detection
  - Executable script validation

- **Language-specific Linting**
  - Go: golangci-lint
  - Shell: shellcheck
  - Markdown: markdownlint
  - YAML: yamllint

- **Chezmoi Validation**
  - Template format checking
  - Go tests for dotfiles

### 🚀 Aliases

Common Git aliases include:

- Quick status checks
- Branch management
- Commit shortcuts
- Log formatting

## 🌍 Dependencies

- Git 2.30+
- [Chezmoi](https://www.chezmoi.io/) (for dotfiles management)
- [pre-commit](https://pre-commit.com/) (for code quality hooks)
- GPG (for commit signing)
- Various linters (installed via Homebrew)

## 🌠 Contributing

<!-- markdownlint-disable MD013 -->
Feel free to submit issues and enhancement requests! Together we can make this configuration even better! ✨
<!-- markdownlint-enable MD013 -->

<!-- markdownlint-disable MD033 MD013 MD045 -->
<div align="center">
<img src="https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/388.png" width="100" />

Made with ❤️ and version control magic
</div>
<!-- markdownlint-enable MD033 MD013 MD045 -->
