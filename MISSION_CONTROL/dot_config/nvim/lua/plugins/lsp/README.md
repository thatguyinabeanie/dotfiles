# LSP (Language Server Protocol) Plugins

This directory contains configurations for language servers, code completion, and language-specific enhancements.

## Core LSP Infrastructure

### nvim-lspconfig
- **File**: `nvim-lspconfig.lua`
- **Purpose**: Configure Neovim's built-in LSP client
- **Features**:
  - Auto-configured language servers
  - Custom on_attach functions
  - Diagnostic settings
  - Keymaps for LSP actions
- **Configured Servers**:
  - `bashls` - Bash/Shell scripting
  - `lua_ls` - Lua (with Neovim API support)
  - `nushell` - Nu shell
  - `ruby_lsp` - Ruby language server
  - `taplo` - TOML files
- **Key Mappings**:
  - `gd` - Go to definition
  - `gr` - Go to references
  - `gi` - Go to implementation
  - `K` - Hover documentation
  - `<leader>rn` - Rename symbol
  - `<leader>ca` - Code actions
  - `<leader>f` - Format code

### Mason.nvim
- **File**: `mason.lua`
- **Purpose**: Automatic installation and management of LSP servers, linters, and formatters
- **Optimized For**:
  - TypeScript/JavaScript development
  - Ruby/Rails development
  - Markdown editing
- **Auto-installed Tools**:
  - Language servers: `typescript-language-server`, `vtsls`, `ruby-lsp`, `marksman`
  - Linters: `eslint_d`, `standardrb`, `markdownlint-cli2`
  - Formatters: `prettierd`, `stylua`

## Code Completion

### blink.cmp
- **File**: `blink.lua`
- **Purpose**: Fast, modern completion engine
- **Features**:
  - Async completion
  - Multiple sources (LSP, buffer, path, snippets)
  - AI integration (Copilot suggestions)
  - Fast fuzzy matching
- **Loading**: Immediate (lazy = false) for instant availability
- **Key Mappings**:
  - `<Tab>` - Accept completion
  - `<C-n>` / `<C-p>` - Navigate completions
  - `<C-e>` - Cancel completion

## Syntax and Code Understanding

### nvim-treesitter
- **File**: `nvim-treesitter.lua.tmpl`
- **Purpose**: Advanced syntax highlighting and code understanding
- **Features**:
  - Incremental parsing
  - Syntax-aware text objects
  - Code folding
  - Context-aware indentation
- **Auto-install**: Enabled for automatic parser installation

## Language-Specific Enhancements

### TypeScript/JavaScript
- **File**: `typescript.lua`
- **Purpose**: Enhanced TypeScript/JavaScript development
- **Plugins**:
  - `typescript-tools.nvim` - Advanced TypeScript LSP features
  - `tailwind-tools.nvim` - Tailwind CSS support
  - `neotest-jest` - Jest test runner integration
- **Features**:
  - Project-wide diagnostics
  - Automatic imports
  - Code refactoring
  - JSX/TSX support

### Ruby on Rails
- **File**: `vim-rails.lua`
- **Purpose**: Rails-specific navigation and commands
- **Features**:
  - Rails file navigation (models, views, controllers)
  - Rails-specific commands
  - Alternate file switching
- **Key Mappings**:
  - `:A` - Switch to alternate file (e.g., model ↔ test)
  - `:R` - Navigate to related file
  - `:Emodel` - Edit model
  - `:Econtroller` - Edit controller
  - `:Eview` - Edit view

## Configuration Notes

- LSP servers are automatically installed via Mason when opening relevant file types
- Completion is handled by blink.cmp (not nvim-cmp) for better performance
- All language servers use a shared on_attach function for consistent keymaps
- Diagnostic display is configured globally with signs and virtual text