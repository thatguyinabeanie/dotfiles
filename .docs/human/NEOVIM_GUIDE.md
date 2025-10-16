# AGENTS-nvim.md

## Project Overview

This is a Neovim configuration directory within a chezmoi dotfiles repository. The setup is based on [LazyVim](https://lazyvim.org/), a modern Neovim distribution that provides sensible defaults and a plugin ecosystem. This configuration extends LazyVim with custom plugins, settings, and chezmoi template support.

## How LazyVim Works

**Bootstrap Process:**
1. `init.lua` → loads `config.lazy` → bootstraps lazy.nvim plugin manager
2. Clones LazyVim core from GitHub if not present
3. Sets up plugin spec with ordered imports: core → ai → ui → utilities → plugins
4. Applies configuration in layers: LazyVim defaults → extras → custom overrides

**Directory Structure & Load Order:**
- `lua/config/`: Core configuration (options, keymaps, autocmds) - loaded first
- `lua/plugins/`: Custom plugin configurations organized by category
  - `core/`: Essential functionality (completion, file navigation)
  - `ai/`: AI-powered tools (Copilot, CodeCompanion, Avante)
  - `ui/`: Interface enhancements (themes, statusline, notifications)
  - `utilities/`: Development tools (Git, testing, debugging)
  - Root level: Language-specific and cross-cutting concerns

**Plugin Management:**
- Uses lazy.nvim for performance-optimized plugin loading
- Plugins are lazy-loaded by events, commands, and file types
- LazyVim extras provide pre-configured bundles (see `.lazyvim.json`)
- Custom plugins can override or extend LazyVim defaults using the same plugin keys
- **IMPORTANT**: NEVER add plugin files directly in `plugins/` - always use subdirectories (`core/`, `ai/`, `ui/`, `utilities/`)

**Configuration Philosophy:**
- **Layered approach**: LazyVim provides the foundation, extras add functionality, custom configs fine-tune
- **Performance first**: Aggressive lazy loading, disabled unused built-ins, optimized startup
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

**Note:** The complete list of installed LazyVim extras can be found in `.lazyvim.json`. This config includes 51 extras covering AI, language support, debugging, testing, formatting, and utilities.

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

**AI & Copilot Chat:**
- `<leader>a` - +ai menu
- `<leader>aa` - Toggle CopilotChat
- `<leader>aq` - Quick chat
- `<leader>ap` - Prompt actions
- `<leader>ax` - Clear chat

**OpenCode AI Assistant:**
- `<leader>oc` - Toggle opencode
- `<leader>oA` - Ask opencode (free form)
- `<leader>oa` - Ask opencode about cursor/selection
- `<leader>on` - New opencode session
- `<leader>or` - Reset opencode session
- `<leader>oy` - Copy last opencode response
- `<leader>os` - Select opencode prompt
- `<leader>oe` - Explain this code
- `<leader>of` - Fix issues in buffer
- `<leader>od` - Document selected code (visual mode)
- `<leader>oT` - Generate tests for this
- `<leader>oD` - Fix diagnostics
- `<leader>og` - Review git diff
- `<S-C-u>/<S-C-d>` - Navigate opencode messages

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
- `<leader>o*` - OpenCode AI operations & Overseer/Task operations
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

## Code Style Guidelines

- **Lua**: 2-space indentation, 120 char line width (stylua.toml). Follow LazyVim conventions
- **File naming**: Use lowercase with hyphens for plugin files, match LazyVim structure  
- **Imports**: Prefer `require()` over `vim.api.nvim_get_runtime_file()`. Group requires logically
- **Configuration**: Use `opts` tables for plugin configuration, avoid inline setup calls
- **Error handling**: Use `pcall()` for potentially failing operations, check `vim.fn.executable()`
- **Comments**: Minimal comments, prefer self-documenting code. Use `--` for Lua comments
- **Template files**: Support `.tmpl` extensions for chezmoi templates (for example, `lua.tmpl`, `toml.tmpl`)

## LazyVim Structure

- `lua/config/`: Core LazyVim configuration (options, keymaps, autocmds)
- `lua/plugins/`: Plugin configurations organized by category (ai/, core/, ui/, utilities/)
- `init.lua`: Bootstrap file that loads LazyVim and custom configurations
- `.lazyvim.json`: LazyVim extras and version tracking


## Plugin Architecture

### Core Plugins (`lua/plugins/core/`)

**blink-cmp.lua**: Advanced completion engine
- Modern replacement for nvim-cmp with better performance
- Supports LSP, snippets, buffer, and path sources
- Custom keymaps for completion navigation
- Integration with AI completion providers

**snacks-*.lua**: LazyVim's utility plugin suite
- **snacks-core.lua**: Core snacks configuration
- **snacks-dashboard.lua**: Welcome screen and session management
- **snacks-indent.lua**: Indent guides and scope highlighting

**treewalker.lua**: AST-aware navigation
- Intelligent movement through code structure
- Respects language syntax for better navigation
- Alternative to traditional word/paragraph movement

### AI Plugins (`lua/plugins/ai/`)

**copilot.lua**: GitHub Copilot integration
- AI-powered code completion and suggestions
- Chat interface for code explanations
- Integration with completion system

**codecompanion.lua**: Multi-provider AI assistant
- Support for multiple AI providers (OpenAI, Anthropic, etc.)
- Inline chat and code generation
- Context-aware suggestions

**avante.lua**: Advanced AI coding assistant
- Sophisticated AI interactions
- Code review and refactoring suggestions
- Multi-turn conversations

**mcp-hub.lua**: Model Context Protocol integration
- Standardized AI model interactions
- Plugin ecosystem for AI tools
- Extensible AI capabilities

### UI Plugins (`lua/plugins/ui/`)

**theme.lua**: Catppuccin color scheme
- Dynamic light/dark mode switching
- Consistent theming across all components
- Integration with system appearance

**noice.lua**: Enhanced UI components
- Better command line interface
- Improved notifications and messages
- Hover documentation styling

**indent-blankline.lua**: Visual indentation guides
- Subtle indent line visualization
- Scope highlighting for nested structures
- Integration with treesitter

### Utility Plugins (`lua/plugins/utilities/`)

**vim-tmux-navigator.lua**: Seamless tmux integration
- Unified navigation between vim splits and tmux panes
- Smart detection of tmux environment
- Consistent `Ctrl+hjkl` navigation

**kulala.lua**: REST API testing
- HTTP request execution from buffer
- Response visualization and formatting
- Integration with multiple output formats

**image.lua**: Inline image rendering
- Display images directly in Neovim buffers
- Support for various image formats
- Integration with terminal image protocols

**chezmoi.lua**: Dotfiles management integration
- Chezmoi template syntax highlighting
- Direct editing of chezmoi-managed files
- Template validation and testing

### Development Tools

**Git Integration:**
- **fugitive.lua**: Core Git operations and staging
- **diffview.lua**: Side-by-side diff visualization with smart toggling
- **blame.lua**: Inline Git blame annotations

**Language Support:**
- **treesitter.lua**: Syntax highlighting and text objects
- **mason.lua**: LSP server and tool management
- **lsp configurations**: Per-language LSP setups

**Testing & Debugging:**
- Neotest integration for running tests
- DAP (Debug Adapter Protocol) configurations
- Language-specific debugging setups

## Jupyter Notebook Integration

### Overview

This configuration includes a comprehensive Jupyter Notebook environment that works entirely within Neovim, eliminating the need for external browser windows or separate applications.

### Core Components

**jupytext.nvim**: Transparent file conversion
- Automatically converts `.ipynb` files to editable text formats
- Supports Quarto Markdown (`.qmd`) and Python script formats
- Seamless sync between notebook and text representations

**molten-nvim**: Kernel communication engine
- Manages Jupyter kernels and execution
- Displays text-based output in dedicated panels
- Handles code cell execution and management

**quarto-nvim**: Language server integration
- Provides LSP features (completion, diagnostics) in code cells
- Supports mixed-language documents
- Integration with Quarto ecosystem

**image.nvim**: Rich output rendering
- Displays matplotlib plots and images inline
- Terminal graphics protocol support
- Integration with notebook output system

### Notebook Workflow

1. **Opening Notebooks**: Open `.ipynb` files directly; jupytext creates editable `.qmd` buffer
2. **Kernel Management**: Use `<localleader>i` to initialize and select Python kernel
3. **Code Execution**: Navigate to code cells and use `<localleader>r` to execute
4. **Output Handling**: Text output appears in bottom panel, plots in side panel
5. **Saving**: Regular `:w` saves back to original `.ipynb` format

### Prerequisites

**Python Environment:**
```bash
python3 -m venv .venv && source .venv/bin/activate
pip install -U pip jupyter jupytext ipykernel quarto matplotlib pandas seaborn
```

**External Dependencies:**
- `ueberzug` or `ueberzugpp` for image rendering (Linux/macOS only)
- Active Python virtual environment when launching Neovim

### Keybindings

| Key | Action | Description |
|-----|--------|-------------|
| `<localleader>i` | Initialize kernel | Start Jupyter kernel session |
| `<localleader>r` | Run cell | Execute current code cell |
| `<localleader>d` | Delete output | Remove cell output |

### Troubleshooting

- **Kernel not found**: Ensure virtual environment is active when starting Neovim
- **No plots**: Verify `ueberzug` installation and terminal support
- **No LSP**: Check `quarto` package installation and LSP attachment
- **No sync**: Verify `jupytext` CLI tool is available in PATH

## Integration Points

### Tmux Integration
- **vim-tmux-navigator**: Seamless pane navigation
- **Shared clipboard**: Copy/paste between tmux and Neovim
- **Session awareness**: Neovim detects tmux environment

### Terminal Integration (Ghostty)
- **True color support**: Full RGB color rendering
- **Font optimization**: Proper font rendering and sizing
- **Image support**: Terminal graphics for inline images

### Chezmoi Integration
- **Template support**: Syntax highlighting for `.tmpl` files
- **Live editing**: Direct editing of chezmoi-managed configurations
- **Validation**: Template syntax checking and testing

### Git Workflow
- **Staging interface**: Visual Git operations with Fugitive
- **Diff viewing**: Side-by-side comparisons with Diffview
- **Blame integration**: Inline Git history and attribution

## Performance Optimizations

### Startup Time
- Aggressive lazy loading of plugins
- Conditional loading based on file types
- Minimal startup configuration

### Memory Usage
- Efficient plugin management with lazy.nvim
- Unloading of unused language servers
- Optimized treesitter parsers

### Responsiveness
- Async operations for heavy tasks
- Non-blocking UI updates
- Efficient buffer management

## Customization Guidelines

### Adding New Plugins
1. Determine appropriate category directory
2. Follow LazyVim plugin specification format
3. Use lazy loading with appropriate triggers
4. Document new keybindings and avoid conflicts

### Modifying Keymaps
1. Check existing keymap patterns to avoid conflicts
2. Use appropriate leader key prefixes
3. Document changes in this file
4. Test with vim-tmux-navigator integration

### Theme Customization
1. Modify `theme.lua` for color scheme changes
2. Ensure consistency with tmux and terminal themes
3. Test in both light and dark modes
4. Consider accessibility requirements

### Language Support
1. Add LSP configurations in appropriate files
2. Configure formatters and linters in Mason
3. Set up debugging configurations if needed
4. Add language-specific keybindings with `<localleader>`

This Neovim configuration provides a powerful, modern development environment that integrates seamlessly with the broader dotfiles ecosystem while maintaining the flexibility and extensibility that makes Neovim exceptional.
