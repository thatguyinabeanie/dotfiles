# 🌿 Git Configuration 🔄

This directory contains Git configuration files and hooks for the dotfiles repository.

## Features

- Quick access to common Git commands.
- Enhanced workflow shortcuts.
- Repository management helpers.
- Pre-commit hooks (via Lefthook).

## Usage

Copy or symlink the configuration files to your `~/.config/git/` directory.

## Hooks

Hooks are managed by [Lefthook](https://github.com/evilmartians/lefthook) and are located in the `hooks/` subdirectory.

## 🌟 Features

### 🚀 Custom Aliases

- Quick access to common Git commands
- Enhanced workflow shortcuts
- Repository management helpers

### 🔄 Git Hooks (Lefthook)

- Pre-commit hooks (via Lefthook)
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

   ```bash
   chezmoi init --apply
   ```

2. Ensure Git and Lefthook are installed:

   ```bash
   brew install git lefthook
   lefthook install
   ```

## ⚙️ Customization

### 🔧 Global Settings

The configuration includes:

- Default editor settings
- Branch naming conventions
- Commit message templates
- GPG signing configuration

### 🔄 Git Hooks (Lefthook)

Custom hooks are available for:

- Pre-commit checks (see `lefthook.yml`)
- Post-merge actions
- Workflow automation

#### 🛡️ Pre-commit Hooks (Lefthook)

The repository uses [Lefthook](https://github.com/evilmartians/lefthook) to enforce code quality standards:

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

## 🧪 Running Hooks Manually

You can run all hooks against all files:

```bash
lefthook run pre-commit
```

Or run a specific hook:

```bash
lefthook run pre-commit --only <hook-name>
```

## 🌍 Dependencies

- Git 2.30+
- [Chezmoi](https://www.chezmoi.io/) (for dotfiles management)
- [Lefthook](https://github.com/evilmartians/lefthook) (for code quality hooks)
- GPG (for commit signing)
- Various linters (installed via Homebrew)

## 🌠 Contributing

Feel free to submit issues and enhancement requests! Together we can make this configuration even better! ✨

<div align="center">
<img src="https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/388.png" width="100" />

Made with ❤️ and version control magic
</div>
