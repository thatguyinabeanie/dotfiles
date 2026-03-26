# Tmux Configuration Guide

> **Scope:** This file covers tmux configuration only.
> For package management, chezmoi workflow, and project-wide rules, see the root `AGENTS.md`.

## Overview

The tmux configuration uses a modular architecture with the main config file sourcing
specialized configuration modules for better maintainability.

## File Structure

- **`tmux.conf`** - Main configuration entry point (sources all modules below)
- **`tmux.keybindings.conf`** - All custom keybindings (read this for the full binding map)
- **`tmux.cursor.conf`** - Cursor shape/behavior settings
- **`tmux.status.conf`** - Status bar configuration
- **`tmux.pomodoro.conf`** - Pomodoro timer settings
- **`tmux.theme.catppuccin.conf.tmpl`** - Catppuccin theme (chezmoi template)
- **`scripts/tmux-cheatsheet`** - Interactive cheat sheet script (fzf/glow/bat)
- **`plugins/.chezmoiexternal.toml`** - Plugin dependencies (TPM, etc.)
- **`.chezmoiexternal.toml`** - External dependencies

## Template Variables

Only `tmux.theme.catppuccin.conf.tmpl` uses chezmoi templates:

- `{{ .CATPPUCCIN_FLAVOR }}` - Theme flavor (mocha, macchiato, frappe, latte) from `.chezmoidata/shared.yaml`

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

- **sesh** - Smart session manager with zoxide integration (Prefix + T)
- **tmux-resurrect** - Save/restore sessions manually (Prefix + Ctrl-s/r)
- **tmux-continuum** - Auto-save sessions every 15 minutes
- **vim-tmux-navigator** - Seamless Vim/tmux navigation
- **catppuccin/tmux** - Modern theming framework
- **tmux-battery/cpu** - System monitoring

### Interactive Cheat Sheet (Prefix + ?)

Fuzzy-searchable keybinding reference accessible via `Prefix + ?`:

- Search through all tmux commands with fzf
- Colored columns: cyan actions, yellow keybindings
- Press Enter to copy keybinding to clipboard

The cheat sheet script is located at `~/.config/tmux/scripts/tmux-cheatsheet`.

### Session Management

Complete session management workflow with sesh + resurrect + continuum:

#### Sesh (Prefix + T) - Smart Session Switching

- **Zoxide integration**: Frecency-based directory suggestions
- **Tmuxinator support**: Reads tmuxinator YAML configs for complex layouts
- **Session preview**: Preview session contents before switching
- **Config location**: `~/.config/sesh/sesh.toml`

**Keybindings in sesh picker:**

| Key | Action |
|-----|--------|
| `Enter` | Switch to session or create new |
| `Ctrl-a` | Show all sessions |
| `Ctrl-t` | Show tmux sessions only |
| `Ctrl-g` | Show configured sessions only |
| `Ctrl-x` | Show zoxide directories |
| `Ctrl-d` | Kill selected session |
| `Tab/Shift-Tab` | Navigate list |

#### Session Persistence (Resurrect + Continuum)

- **Auto-save**: Every 15 minutes (configurable)
- **Auto-restore**: On tmux server start
- **Manual save**: `Prefix + Ctrl-s`
- **Manual restore**: `Prefix + Ctrl-r`
- **Saves**: Windows, panes, pane contents, Neovim sessions

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

- **Open cheat sheet** - `Prefix + ?`
- Reload configuration - `Prefix + r`
- Sesh session manager - `Prefix + T`
- Choose session interactively - `Prefix + S`
- Choose window interactively - `Prefix + "`
- Navigate panes (works seamlessly with Neovim) - `C-h/j/k/l`
- Send literal C-a to application - `C-a C-a`
- Save session manually - `Prefix + Ctrl-s`
- Restore session manually - `Prefix + Ctrl-r`

### Validation Checklist

- [ ] Main config sources all module files without errors
- [ ] TPM plugin manager installed and functional
- [ ] Sesh launches in tmux popup with zoxide directories
- [ ] Session persistence works (save, kill tmux, restore)
- [ ] Vim-tmux-navigator works bidirectionally with Neovim
- [ ] Status bar displays and updates correctly
- [ ] Catppuccin theme renders properly

## Related Documentation

- [Ghostty Agent Guide](../ghostty/AGENTS.md)—tmux auto-launcher integration
- [Neovim Agent Guide](../nvim/AGENTS.md)—vim-tmux-navigator for seamless pane navigation
