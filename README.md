# 🏠 Dotfiles

My personal dotfiles managed with [Chezmoi](https://www.chezmoi.io/), featuring a modern and
efficient development environment setup.

![Shell](https://img.shields.io/badge/Shell-Nushell-blue?style=flat-square&logo=gnu-bash)
![Editor](https://img.shields.io/badge/Editor-Neovim-green?style=flat-square&logo=neovim)
![Theme](https://img.shields.io/badge/Theme-Catppuccin-pink?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-yellow?style=flat-square)
![Tests](https://github.com/thatguyinabeanie/dotfiles/actions/workflows/test.yml/badge.svg)
![Lint](https://github.com/thatguyinabeanie/dotfiles/actions/workflows/lint.yml/badge.svg)
![Security](https://github.com/thatguyinabeanie/dotfiles/actions/workflows/security.yml/badge.svg)

[Screenshot of setup]

## 📂 Repository Structure

```
.
├── .chezmoiroot          # Points to ROOT/ as the source directory
├── ROOT/                 # Source home directory
│   ├── dot_config/      # Configuration files
│   │   ├── nvim/       # Neovim configuration
│   │   ├── nushell/    # Nushell configuration
│   │   ├── obsidian/   # Obsidian configuration
│   │   ├── tmux/       # Tmux configuration
│   │   └── ...
│   └── ...
├── tests/               # Test suite
└── ...
```

## ✨ Components

### 🐚 Shell Environment

- [**Nushell Configuration**](dot_config/nushell/README.md)
  - Modern shell with enhanced features
  - Custom aliases and functions
  - Work environment integration

### 🛠️ Development Tools

- [**Neovim Configuration**](dot_config/nvim/README.md)
  - LazyVim-based setup
  - Catppuccin theme
  - LSP integration
  - Git integration

- [**Git Configuration**](dot_config/git/README.md)
  - Custom aliases
  - Git hooks
  - Global settings

### 📟 Terminal Tools

- [**Tmux Configuration**](dot_config/tmux/README.md)
  - Catppuccin theme
  - Pomodoro timer
  - Custom keybindings
  - Session management

### 📚 Knowledge Management

- [**Obsidian Configuration**](dot_config/obsidian/README.md)
  - Multiple vault support
  - Neovim integration
  - Plugin configuration

## 📥 Installation

```zsh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply thatguyinabeanie
```

### Configuration Variables

During installation, you'll be prompted for several configuration values:

| Variable | Description | Default |
|----------|-------------|---------|
| `WORK_ENVIRONMENT` | Enable work-specific configurations | `false` |
| `SHELL` | Preferred shell (nu/zsh) | `nu` |
| `CATPPUCCIN_FLAVOR` | Theme variant (mocha/macchiato/frappe/latte) | `mocha` |
| `GIT_NAME` | Git commit author name | - |
| `GIT_EMAIL` | Git commit author email | - |
| `GITHUB_USERNAME` | GitHub username | - |

## 📥 Installation

```zsh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply thatguyinabeanie
```

### Configuration Variables

During installation, you'll be prompted for several configuration values:

| Variable | Description | Default |
|----------|-------------|---------|
| `WORK_ENVIRONMENT` | Enable work-specific configurations | `false` |
| `SHELL` | Preferred shell (nu/zsh) | `nu` |
| `CATPPUCCIN_FLAVOR` | Theme variant (mocha/macchiato/frappe/latte) | `mocha` |
| `GIT_NAME` | Git commit author name | - |
| `GIT_EMAIL` | Git commit author email | - |
| `GITHUB_USERNAME` | GitHub username | - |

## 📂 Structure

## 🎯 Features

### 🚀 Modern Development Environment

- Nushell for enhanced shell experience
- Neovim for efficient editing
- Tmux for terminal multiplexing
- Git for version control

### 📝 Knowledge Management

- Obsidian for note-taking
- Multiple vault support
- Neovim integration

### ⚡ Productivity Tools

- Pomodoro timer
- Custom aliases
- Work environment integration

## 🔒 Security Features

### TODO: Pre-commit Hooks

This repository automatically sets up pre-commit hooks when you run `chezmoi init --apply`.
These hooks include:

- **Gitleaks**: Scans staged files for potential secrets or sensitive information
- **Basic checks**: Trailing whitespace, YAML validation, etc.

The hooks are installed globally in `~/.config/git/hooks` and will be available for all your repositories.

### Manual Security Scan

To manually run a security scan:

```bash
pre-commit run --all-files
```

or specifically for secrets:

```bash
gitleaks detect --source . --verbose
```

## 📦 Dependencies

- [**Chezmoi**](https://www.chezmoi.io/) - Dotfiles manager
- [**mise**](https://github.com/jdx/mise) - Tool version manager
- [**Homebrew**](https://brew.sh/) - Package manager

## 🤝 Contributing

Feel free to submit issues and enhancement requests!
