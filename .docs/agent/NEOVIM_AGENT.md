# Neovim Agent Guide

## Quick Overview

- **Purpose**: This document provides guidance for managing the Neovim (LazyVim) configuration.
- **Integration**: Tightly integrated with tmux, shell environments, and various LSP servers.

## Configuration Discovery

- **Primary files**:
  - `dot_config/nvim/` - All Neovim configuration files
  - `dot_config/nvim/lua/plugins/` - Plugin specifications
- **Data sources**:
  - `.chezmoidata/nvim.yaml` - Neovim-specific settings
- **Search patterns**:
  - Plugins: `rg "plugin" dot_config/nvim/lua/plugins/`
  - Keybindings: `rg "keymap" dot_config/nvim/`
- **Template variables**:
  - `{{ .nvim.* }}` for Neovim settings

## Common Tasks

### Add a new plugin

- **Files**: Create a new plugin specification in `dot_config/nvim/lua/plugins/`.
- **Validation**: Run `:Lazy sync` in Neovim.
- **Conflicts**: Check for conflicting keybindings or functionality with other plugins.

### Change a keybinding

- **Files**: Edit the appropriate file in `dot_config/nvim/lua/keymaps/`.
- **Validation**: Restart Neovim and test the new keybinding.
- **Conflicts**: Check for conflicts with other keybindings.

## Validation Checklist

- [ ] Run `:Lazy sync` after adding or removing plugins.
- [ ] Restart Neovim to apply changes.
- [ ] Test all changes to ensure they work as expected.

## Troubleshooting

- **Common errors**: Plugin conflicts, incorrect Lua syntax.
- **Conflict resolution**: Disable conflicting plugins or change keybindings.
- **Rollback**: Revert changes in git.
