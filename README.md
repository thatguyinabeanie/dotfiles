# Dotfiles

My personal dotfiles managed with [Chezmoi](https://www.chezmoi.io/), featuring a modern and
efficient development environment setup.

## Components

### Shell Environment

- [Nushell Configuration](dot_config/nushell/README.md)

  - Modern shell with enhanced features
  - Custom aliases and functions
  - Work environment integration

### Development Tools

- [Neovim Configuration](dot_config/nvim/README.md)

  - LazyVim-based setup
  - Catppuccin theme
  - LSP integration
  - Git integration

- [Git Configuration](dot_config/git/README.md)
  - Custom aliases
  - Git hooks
  - Global settings

### Terminal Tools

- [Tmux Configuration](dot_config/tmux/README.md)

  - Catppuccin theme
  - Pomodoro timer
  - Custom keybindings
  - Session management

### Knowledge Management

- [Obsidian Configuration](dot_config/obsidian/README.md)

  - Multiple vault support
  - Neovim integration
  - Plugin configuration

## Installation

1. Install Chezmoi:

   ```bash
   brew install chezmoi
   ```

2. Clone this repository:

   ```bash
   chezmoi init --apply
   ```

3. Install dependencies:

   ```bash
   mise install
   ```

## Structure

```
.
├── dot_config/
│   ├── nushell/     # Shell configuration
│   ├── nvim/        # Neovim configuration
│   ├── git/         # Git configuration
│   ├── tmux/        # Tmux configuration
│   └── obsidian/    # Obsidian configuration
└── scripts/         # Custom scripts
```

## Features

- **Modern Development Environment**
  - Nushell for enhanced shell experience
  - Neovim for efficient editing
  - Tmux for terminal multiplexing
  - Git for version control

- **Knowledge Management**
  - Obsidian for note-taking
  - Multiple vault support
  - Neovim integration

- **Productivity Tools**
  - Pomodoro timer
  - Custom aliases
  - Work environment integration

## Dependencies

- [Chezmoi](https://www.chezmoi.io/) - Dotfiles manager
- [mise](https://github.com/jdx/mise) - Tool version manager
- [Homebrew](https://brew.sh/) - Package manager

## Contributing

Feel free to submit issues and enhancement requests!
