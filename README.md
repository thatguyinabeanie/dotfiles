<div align="center">

# 🏠 Dotfiles

My personal dotfiles managed with [Chezmoi](https://www.chezmoi.io/), featuring a modern and
efficient development environment setup.

![Shell](https://img.shields.io/badge/Shell-Nushell-blue?style=flat-square&logo=gnu-bash)
![Editor](https://img.shields.io/badge/Editor-Neovim-green?style=flat-square&logo=neovim)
![Theme](https://img.shields.io/badge/Theme-Catppuccin-pink?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-yellow?style=flat-square)

</div>

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

# 1. Install Chezmoi

```zsh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply thatguyinabeanie
```

## 📂 Structure

```tree
.
|── .chezmoi.toml.tmpl  # Chezmoi Engine configuration
├── .chezmoidata/       # Chezmoi data 
│   ├── gitrepos.yaml   # Git repository configuration
│   ├── homebrew.yaml   # Homebrew packages
|   ├── mise.yaml       # Sensitive configuration
|   └── treesitter.yaml # Treesitter configuration
|
├── .chezmoiscripts/    # Scripts automatically ran by Chezmoi
├── .chezmoitemplates/  # Chezmoi templates
└─ dot_config/
    ├── nushell/        # Shell configuration
    ├── nvim/           # Neovim configuration
    ├── mise/           # Mise configuration
    ├── git/            # Git configuration
    ├── tmux/           # Tmux configuration
    └── obsidian/       # jObsidian configuration
```

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

## 📦 Dependencies

- [**Chezmoi**](https://www.chezmoi.io/) - Dotfiles manager
- [**mise**](https://github.com/jdx/mise) - Tool version manager
- [**Homebrew**](https://brew.sh/) - Package manager

## 🤝 Contributing

Feel free to submit issues and enhancement requests!