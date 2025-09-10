# AGENTS.md

## Project Overview

This is a Neovim configuration directory within a chezmoi dotfiles repository. The setup is based on [LazyVim](https://lazyvim.org/), a modern Neovim distribution that provides sensible defaults and a plugin ecosystem. This configuration extends LazyVim with custom plugins, settings, and chezmoi template support.

## Build/Test/Lint Commands

```bash
# Format Lua code
stylua .

# LazyVim health check (comprehensive diagnostics)
:checkhealth

# Update plugins and sync configuration
:Lazy sync

# Install LSP servers and tools
:MasonInstall <server_name>

# Single test equivalent: test specific plugin functionality
:Lazy load <plugin_name>
```

## Code Style Guidelines

- **Lua**: 2-space indentation, 120 char line width (stylua.toml). Follow LazyVim conventions
- **File naming**: Use lowercase with hyphens for plugin files, match LazyVim structure  
- **Imports**: Prefer `require()` over `vim.api.nvim_get_runtime_file()`. Group requires logically
- **Configuration**: Use `opts` tables for plugin configuration, avoid inline setup calls
- **Error handling**: Use `pcall()` for potentially failing operations, check `vim.fn.executable()`
- **Comments**: Minimal comments, prefer self-documenting code. Use `--` for Lua comments
- **Template files**: Support `.tmpl` extensions for chezmoi templates (e.g., `lua.tmpl`, `toml.tmpl`)

## LazyVim Structure

- `lua/config/`: Core LazyVim configuration (options, keymaps, autocmds)
- `lua/plugins/`: Plugin configurations organized by category (ai/, core/, ui/, utilities/)
- `init.lua`: Bootstrap file that loads LazyVim and custom configurations
- `.lazyvim.json`: LazyVim extras and version tracking