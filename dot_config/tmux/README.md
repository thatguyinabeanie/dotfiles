# Tmux Configuration

A modern and functional Tmux configuration with Catppuccin theme integration, custom keybindings, and productivity features.

## Features

- **Theme**
  - Catppuccin theme integration
  - Transparent background support
  - Custom status line

- **Productivity**
  - Pomodoro timer integration
  - Custom keybindings
  - Enhanced status bar
  - Session management

## Configuration Structure

The configuration is split into multiple files for better organization:
- `tmux.conf` - Main configuration file
- `tmux.keybindings.conf` - Custom keybindings
- `tmux.pomodoro.conf` - Pomodoro timer settings
- `tmux.status.conf` - Status bar configuration
- `tmux.theme.catppuccin.conf.tmpl` - Theme configuration (Chezmoi template)

## Installation

1. Clone this configuration using Chezmoi:
   ```bash
   chezmoi init --apply
   ```

2. Ensure Tmux is installed:
   ```bash
   brew install tmux
   ```

## Customization

### Theme
The configuration uses Catppuccin theme with:
- Transparent background support
- Custom status line colors
- Theme variables managed through Chezmoi

### Keybindings
Custom keybindings are organized in `tmux.keybindings.conf`:
- Window management
- Pane splitting and navigation
- Session management
- Copy mode enhancements

### Pomodoro Timer
The Pomodoro timer configuration includes:
- Custom timer durations
- Visual notifications
- Status bar integration

## Dependencies

- Tmux 3.0+
- [Chezmoi](https://www.chezmoi.io/) (for dotfiles management)

## Contributing

Feel free to submit issues and enhancement requests! 