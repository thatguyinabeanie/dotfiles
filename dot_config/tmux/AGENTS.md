# Tmux Configuration Guide

## Overview

The tmux configuration uses a modular architecture with the main config file sourcing
specialized configuration modules for better maintainability.

## File Structure

- **`tmux.conf`** - Main configuration entry point
- **`tmux.keybindings.conf`** - All custom keybindings
- **`tmux.cursor.conf`** - Cursor shape/behavior settings
- **`tmux.status.conf`** - Status bar configuration
- **`tmux.pomodoro.conf`** - Pomodoro timer settings
- **`tmux.theme.catppuccin.conf.tmpl`** - Catppuccin theme (templated)
- **`plugins/.chezmoiexternal.toml`** - Plugin dependencies (TPM, etc.)
- **`.chezmoiexternal.toml`** - External dependencies

## Key Features

### Core Configuration

- **Prefix**: `C-a` (Control+a) - more ergonomic than default `C-b`
- **Reload**: `Prefix + r` - instant configuration reload
- **Mouse support**: Full mouse integration enabled
- **Clipboard**: Automatic system clipboard integration
- **History**: 100k lines scrollback buffer
- **Image support**: Passthrough sequences enabled for image.nvim

### Plugin Ecosystem

Major plugins managed via TPM:

- **tmux-sessionx** - Advanced session manager (Prefix + o)
- **vim-tmux-navigator** - Seamless Vim/tmux navigation
- **catppuccin/tmux** - Modern theming framework
- **tmux-which-key** - Visual keybinding help
- **tmux-battery/cpu** - System monitoring

### SessionX Integration

Advanced session management with fuzzy finding:

- `Prefix + o` - Launch SessionX
- Zoxide integration for smart directory switching
- Custom paths: `~/source`, `~/.config`, `~/.local/share/chezmoi`
- Preview mode with 55% ratio, reverse layout

## Discovery Patterns

### Configuration Structure

Main config sources specialized modules:

- **tmux.conf** sources `tmux.keybindings.conf` for all keybindings
- **tmux.conf** sources `tmux.cursor.conf` for cursor behavior
- **tmux.conf** sources `tmux.status.conf` for status bar settings
- **tmux.conf** sources `tmux.theme.catppuccin.conf` for theming
- Plugins managed via TPM (Tmux Plugin Manager)

### Plugin Management

Plugins managed via chezmoi external dependencies and TPM:

- View plugin dependencies: `cat dot_config/tmux/plugins/.chezmoiexternal.toml`
- Install/update plugins: `Prefix + I` (install) | `Prefix + U` (update) | `Prefix + alt+u` (uninstall)

### Troubleshooting

**Configuration testing:**

- Test configuration reload: `tmux source-file ~/.config/tmux/tmux.conf`
- Verify keybindings loaded: `tmux list-keys | grep -E "(C-a|sessionx)"`

**Plugin debugging:**

- Check vim-tmux-navigator: `tmux display-message "#{@vim_navigator_mapping_left}"`
- Debug plugin issues: `tmux show-environment | grep -i plugin`

## Quick Reference

### Essential Keybindings

- Reload configuration - `Prefix + r`
- SessionX fuzzy session manager - `Prefix + o`
- Choose session interactively - `Prefix + S`
- Choose window interactively - `Prefix + "`
- Navigate panes (works seamlessly with Neovim) - `C-h/j/k/l`
- Send literal C-a to application - `C-a C-a`

### Validation Checklist

- [ ] Main config sources all module files without errors
- [ ] TPM plugin manager installed and functional
- [ ] SessionX launches and shows configured paths
- [ ] Vim-tmux-navigator works bidirectionally with Neovim
- [ ] Status bar displays and updates correctly
- [ ] Catppuccin theme renders properly
