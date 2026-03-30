# AGENTS.md

> **Scope:** This file covers Neovim/LazyVim configuration only.
> For package management, chezmoi workflow, and project-wide rules, see the root `AGENTS.md`.

## Project Overview

This is a Neovim configuration directory within a chezmoi dotfiles repository.
The setup is based on [LazyVim](https://lazyvim.org/), a modern Neovim distribution
that provides sensible defaults and a plugin ecosystem. This configuration extends
LazyVim with custom plugins, settings, and chezmoi template support.

## How LazyVim Works

**Bootstrap Process:**

1. `init.lua` → loads `config.lazy` → bootstraps lazy.nvim plugin manager
2. Clones LazyVim core from GitHub if not present
3. Sets up plugin spec with ordered imports: core → ai → ui → utilities → plugins
4. Applies configuration in layers: LazyVim defaults → extras → custom overrides

**Directory Structure & Load Order:**

- `lua/config/`: Core configuration (options, keymaps, autocmds) - loaded first
- `lua/plugins/`: Custom plugin configurations organized by category
  - `core/`: Theming, navigation, and essential functionality
  - `dev/`: Language support, LSP/Mason, treesitter, notebooks
  - `git/`: Git integrations (blame, diffview, lazygit, fugitive)
  - `ui/`: Interface enhancements (statusline, notifications)
  - `utilities/`: System integrations (chezmoi, docker, images, MCP, REST, overseer)

**Plugin Management:**

- Uses lazy.nvim for performance-optimized plugin loading
- Plugins are lazy-loaded by events, commands, and file types
- LazyVim extras provide pre-configured bundles (see `.lazyvim.json`)
- Custom plugins can override or extend LazyVim defaults using the same plugin keys
- **IMPORTANT**: NEVER add plugin files directly in `plugins/` - always use
  subdirectories (`core/`, `dev/`, `git/`, `ui/`, `utilities/`)

**Configuration Philosophy:**

- **Layered approach**: LazyVim provides the foundation, extras add functionality
- **Performance first**: Aggressive lazy loading, disabled unused built-ins
- **Extensible**: Custom plugins follow LazyVim patterns for consistency
- **Modular**: Each plugin file is self-contained with its own configuration

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

**Note:** The complete list of installed LazyVim extras can be found in
`.lazyvim.json`. This config includes 51 extras covering AI, language support,
debugging, testing, formatting, and utilities.

## Keymap Reference

**Leader Keys:** `<leader>` = `<space>`, `<localleader>` = `\`

### Core LazyVim Keymaps

**Navigation & Windows:**

- `<C-h/j/k/l>` - Navigate windows / tmux panes
- `<C-Up/Down/Left/Right>` - Resize windows
- `<S-h/l>` - Previous/Next buffer
- `<leader>-` - Split window below
- `<leader>|` - Split window right
- `<leader>wd` - Delete window
- `<leader>wm` - Toggle zoom mode

**Files & Search (Snacks Picker):**

- `<leader><space>` - Find files (root dir)
- `<leader>ff` - Find files (root dir)
- `<leader>fF` - Find files (cwd)
- `<leader>/` - Live grep (root dir)
- `<leader>sg` - Live grep (root dir)
- `<leader>fb` - Find buffers
- `<leader>fr` - Recent files
- `<leader>fg` - Find files (git-files)
- `<leader>fc` - Find config file
- `<leader>fn` - New file

**LSP & Code:**

- `gd` - Go to definition
- `gr` - References
- `gI` - Go to implementation
- `gy` - Go to type definition
- `K` - Hover documentation
- `<leader>ca` - Code actions
- `<leader>cr` - Rename symbol
- `<leader>cf` - Format code
- `<leader>cl` - LSP info
- `<leader>cm` - Mason

**Git:**

- `<leader>gb` - Git blame line
- `<leader>gs` - Git status
- `<leader>gd` - Git diff (hunks)
- `<leader>gS` - Git stash

**Buffer Operations:**

- `<leader>bd` - Delete buffer
- `<leader>bo` - Delete other buffers
- `<leader>bl/br` - Delete buffers left/right
- `<leader>bp` - Toggle pin
- `<leader>bb` - Switch to other buffer

**Search & Replace:**

- `<leader>sr` - Search and replace
- `<leader>sw` - Search word under cursor
- `<leader>s"` - Registers
- `<leader>sm` - Marks
- `<leader>sk` - Keymaps

**UI Toggles:**

- `<leader>ul` - Toggle line numbers
- `<leader>uL` - Toggle relative numbers
- `<leader>uw` - Toggle wrap
- `<leader>us` - Toggle spelling
- `<leader>uf` - Toggle auto format (global)
- `<leader>uF` - Toggle auto format (buffer)
- `<leader>ud` - Toggle diagnostics
- `<leader>uh` - Toggle inlay hints

**Diagnostics & Trouble:**

- `<leader>xx` - Diagnostics (Trouble)
- `<leader>xX` - Buffer diagnostics (Trouble)
- `<leader>cs` - Symbols (Trouble)
- `<leader>xl` - Location list
- `<leader>xq` - Quickfix list
- `]d/[d` - Next/prev diagnostic
- `]e/[e` - Next/prev error

### LazyVim Extras Keymaps

**AI & Sidekick:**

- `<leader>a` - +ai menu
- `<leader>aa` - Toggle Sidekick CLI
- `<leader>as` - Select CLI tool
- `<leader>at` - Send "this" context
- `<leader>av` - Send visual selection (visual mode)
- `<leader>ap` - Select prompt
- `<leader>ac` - Toggle Claude directly
- `<leader>am` - MCP Hub
- `<c-.>` - Switch focus (CLI ↔ editor)
- `<Tab>` - Apply/navigate Next Edit Suggestions (NES)

**REST API Testing (Kulala):**

- `<leader>R` - +REST menu
- `<leader>Rs` - Send request
- `<leader>Rr` - Replay last request
- `<leader>Rc` - Copy as cURL
- `<leader>Ri` - Inspect request
- `<leader>Rn/Rp` - Next/Previous request
- `<leader>Rt` - Toggle headers/body

**Testing (Neotest):**

- `<leader>t` - +test menu
- `<leader>tt` - Run file
- `<leader>tr` - Run nearest
- `<leader>tl` - Run last
- `<leader>ts` - Toggle summary
- `<leader>to` - Show output

**Debugging (DAP):**

- `<leader>db` - Toggle breakpoint
- `<leader>dc` - Continue
- `<leader>di` - Step into
- `<leader>do` - Step over
- `<leader>du` - DAP UI

**Refactoring:**

- `<leader>r` - +refactor menu
- `<leader>rf` - Extract function
- `<leader>rv` - Extract variable
- `<leader>ri` - Inline variable

**Git (Octo.nvim):**

- `<leader>gi` - List issues
- `<leader>gp` - List PRs
- `<leader>gr` - List repos

**Overseer (Task Runner):**

- `<leader>oo` - Run task
- `<leader>ot` - Task action
- `<leader>ow` - Task list
- `<leader>ob` - Run background task in tmux window (persists after Neovim exit)
- `<leader>og` - Go to tmux window of running task

### Custom Configuration Keymaps

**File Path Operations:**

- `<leader>fy` - Copy buffer relative path
- `<leader>fY` - Copy buffer absolute path
- `<leader>fd` - Copy parent dir relative path
- `<leader>fD` - Copy parent dir absolute path

**Notebooks (Molten):**

- `<localleader>i` - Initialize kernel
- `<localleader>r` - Run cell
- `<localleader>d` - Delete output

**Buffer Operations:**

- `<leader>bx` - Close all buffers

### Reserved Keymap Patterns

**Avoid these patterns when adding new keymaps:**

- `<leader>a*` - AI/Assistant operations
- `<leader>b*` - Buffer operations
- `<leader>c*` - Code/LSP operations
- `<leader>d*` - Debugging/DAP operations
- `<leader>f*` - File operations
- `<leader>g*` - Git operations
- `<leader>l*` - Lazy operations
- `<leader>o*` - Overseer/Task operations
- `<leader>q*` - Quit/Session operations
- `<leader>r*` - Refactoring operations
- `<leader>s*` - Search operations
- `<leader>t*` - Test operations
- `<leader>u*` - UI toggles
- `<leader>w*` - Window operations
- `<leader>x*` - Diagnostics/Trouble
- `<leader>R*` - REST API operations
- `<localleader>*` - Notebook/filetype-specific operations

### Movement & Text Objects

**Flash Navigation:**

- `s` - Flash forward
- `S` - Flash backward
- `r` - Remote flash (operator mode)

**Mini Surround:**

- `gsa` - Add surrounding
- `gsd` - Delete surrounding
- `gsr` - Replace surrounding
- `gsf/gsF` - Find surrounding

**Yanky (Enhanced Yank):**

- `<leader>p` - Open yank history
- `]y/[y` - Cycle yank history
- `p/P` - Enhanced put operations

**Comfy Line Numbers:**

- Uses left-hand digits (1-5) for vertical motions
- `11j` becomes `6j`, `22k` becomes `12k`, etc.

### Language-Specific Keymaps

**Markdown:**

- `<leader>cp` - Markdown preview

**LaTeX (VimTeX):**

- `<localleader>l` - +vimtex menu

**Python DAP:**

- `<leader>dPt` - Debug method
- `<leader>dPc` - Debug class

**SQL:**

- `<leader>D` - Toggle DBUI

## Navigation Hierarchy

The configuration uses a **modifier-based hierarchy** for different
navigation contexts:

| Modifier           | Purpose              | Scope                                  |
| ------------------ | -------------------- | -------------------------------------- |
| `Ctrl+hjkl`        | Pane/window nav      | Cross-application (vim-tmux-navigator) |
| `Alt+hjkl`         | Tree navigation      | Syntax-tree-level (Treewalker)         |
| `Alt+Shift+hjkl`   | Node swapping        | Syntax-tree-level (Treewalker)         |
| `Alt+Ctrl+jk`      | Line movement        | Line-level                             |
| `Alt+Ctrl+hl`      | Line indent/dedent   | Line-level                             |
| `Shift+H/L`        | Buffer navigation    | Buffer-level                           |

### Treewalker (Syntax Tree Navigation)

**Treewalker.nvim** provides Tree-sitter-based code navigation for moving
through code by logical structure rather than lines/words. Great for
refactoring and code exploration.

- **Configuration**: `lua/plugins/core/treewalker.lua`
- See the plugin file comments for comprehensive documentation

### vim-tmux-navigator (Cross-Application Panes)

Seamless navigation between Neovim windows and tmux panes using `Ctrl+h/j/k/l`.

- **Configuration**: `lua/plugins/utilities/smart-nav.lua`

## Configuration Discovery

- **Data sources**: `.chezmoidata/shared.yaml` (shared UI and theme settings)
- **Template variables**: `{{ .nvim.* }}` for Neovim settings
- **Search patterns**:
  - Plugins: `rg "plugin" dot_config/nvim/lua/plugins/`
  - Keybindings: `rg "keymap" dot_config/nvim/`

## Code Style Guidelines

- **Lua**: 2-space indentation, 120 char line width (stylua.toml)
- **File naming**: Use lowercase with hyphens for plugin files
- **Imports**: Prefer `require()` over `vim.api.nvim_get_runtime_file()`
- **Configuration**: Use `opts` tables for plugin configuration
- **Error handling**: Use `pcall()` for potentially failing operations
- **Comments**: Minimal comments, prefer self-documenting code
- **Template files**: Support `.tmpl` extensions for chezmoi templates

## LazyVim Structure

- `lua/config/`: Core LazyVim configuration (options, keymaps, autocmds)
- `lua/plugins/`: Plugin configurations organized by category
- `lua/overseer/strategy/`: Custom Overseer task strategies (e.g., `tmux_window.lua`)
- `init.lua`: Bootstrap file that loads LazyVim and custom configurations
- `.lazyvim.json`: LazyVim extras and version tracking

## Related Documentation

- [Tmux Agent Guide](../tmux/AGENTS.md)—vim-tmux-navigator for seamless pane navigation
