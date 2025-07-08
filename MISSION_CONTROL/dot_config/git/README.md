# 🌿 Git Configuration 🔄


<div align="center">
  <img src="https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/83.png" width="150" alt="Farfetch'd" />
</div>


This directory contains Git configuration files and hooks for the dotfiles repository.

## 🌟 Features

### 🚀 Custom Aliases

- **Quick Access**: To common Git commands
- **Enhanced Workflow**: Shortcuts for a smoother experience
- **Repo Management**: Helpers for repository tasks

### 🔄 Git Hooks (Lefthook)

The repository uses [Lefthook](https://github.com/evilmartians/lefthook) to enforce code quality standards:

- **Pre-commit Hooks**
  - Code Quality
    - Trailing whitespace removal
    - End-of-file fixer
    - Mixed line ending fixer
    - Large file detection
    - Merge conflict detection
  - Security
    - Secret scanning with Gitleaks
    - Private key detection
    - Executable script validation
  - Language-specific Linting
    - Go: golangci-lint
    - Shell: shellcheck
    - Markdown: vale
    - YAML: yamllint
  - Chezmoi Validation
    - Template format checking
    - Go tests for dotfiles
- **Post-merge Hooks**
  - Custom workflow automation
  - Repository state validation

### ⚙️ Global Settings

- **Editor**: Configuration for your preferred Git editor
- **Default Branch**: Standardized naming for new branches
- **Commit Template**: Predefined structure for commit messages
- **GPG Signing**: Setup for signed commits

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

- **Editor Settings**: Default editor preferences
- **Branch Naming**: Conventions for branch names
- **Commit Templates**: Structure for commit messages
- **GPG Signing Config**: Details for GPG signing setup

### 🚀 Aliases

Common Git aliases include:

- **Status Checks**: Quick ways to view repository status
- **Branch Management**: Shortcuts for branch operations
- **Commit Shortcuts**: Faster committing workflows
- **Log Formatting**: Customized views for Git logs

## 🧪 Running Hooks Manually

You can run all hooks against all files:

```bash
lefthook run pre-commit
```

Or run a specific hook:

```bash
lefthook run pre-commit --only <hook-name>
```

## 🌠 Dependencies

- **Git**: Version 2.30+ required
- **Chezmoi**: For dotfiles management ([Chezmoi](https://www.chezmoi.io/))
- **Lefthook**: For code quality hooks ([Lefthook](https://github.com/evilmartians/lefthook))
- **GPG**: For commit signing
- **Linters**: Various linters (typically installed via Homebrew)

## 🌠 Contributing

Feel free to submit issues and enhancement requests! Together we can make this configuration even better! ✨

<div align="center">
Made with ❤️ and version control magic
</div>
