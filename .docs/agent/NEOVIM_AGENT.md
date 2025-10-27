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

## Navigation Plugins

### Treewalker (Syntax Tree Navigation)

**Treewalker.nvim** provides Tree-sitter-based code navigation for moving through code by logical structure rather than lines/words.

**Keybindings**:
```
Alt+h/j/k/l         → Navigate syntax tree (left/down/up/right)
Alt+Shift+h/j/k/l   → Swap nodes (reorder siblings)
```

**Usage**: Navigate by code structure (functions, blocks, statements) instead of text layout. Great for refactoring and code exploration.

**Documentation**: See [Treewalker Integration Guide](../.docs/treewalker-integration.md) for comprehensive documentation.

**Configuration**: `dot_config/nvim/lua/plugins/core/treewalker.lua`

### vim-tmux-navigator (Cross-Application Panes)

**vim-tmux-navigator** provides seamless navigation between Neovim windows and tmux panes.

**Keybindings**:
```
Ctrl+h/j/k/l  → Navigate vim windows / tmux panes
Ctrl+\        → Navigate to previous pane
```

**Configuration**: `dot_config/nvim/lua/plugins/utilities/vim-tmux-navigator.lua`

### Navigation Hierarchy

The configuration uses a **modifier-based hierarchy** for different navigation contexts:

| Modifier | Purpose | Scope |
|----------|---------|-------|
| `Ctrl+hjkl` | Pane/window navigation | Cross-application |
| `Alt+hjkl` | Tree navigation | Syntax-tree-level |
| `Alt+Shift+hjkl` | Node swapping | Syntax-tree-level |
| `Alt+Ctrl+jk` | Line movement (up/down) | Line-level |
| `Alt+Ctrl+hl` | Line indent/dedent | Line-level |
| `Shift+H/L` | Buffer navigation | Buffer-level |

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
