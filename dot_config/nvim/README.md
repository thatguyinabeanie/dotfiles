# Neovim Configuration

A modern Neovim configuration built on top of LazyVim,
featuring a beautiful and functional setup with various plugins and customizations.

## Features

- **Modern UI**
  - Catppuccin theme with transparent background
  - Bufferline for tab management
  - Lualine status line with custom sections
  - Snacks for enhanced UI elements

- **Git Integration**
  - Git blame with virtual text
  - Commit information view
  - Custom git mappings

- **LSP Support**
  - Native LSP integration
  - Diagnostic signs and virtual text
  - Inlay hints support
  - Treesitter integration

- **Enhanced Editing**
  - Indent scope visualization
  - Word highlighting
  - Quick file navigation
  - Input method support

## Plugin Highlights

### Core Plugins

- [LazyVim](https://github.com/LazyVim/LazyVim) - Base configuration
- [Catppuccin](https://github.com/catppuccin/nvim) - Beautiful theme
- [Bufferline](https://github.com/akinsho/bufferline.nvim) - Tab management
- [Lualine](https://github.com/nvim-lualine/lualine.nvim) - Status line

### Git Integration

- [blame.nvim](https://github.com/FabijanZulj/blame.nvim) - Git blame with virtual text
  - Custom date format
  - Virtual text style
  - Commit detail view
  - Custom mappings

### UI Enhancements

- [snacks.nvim](https://github.com/folke/snacks.nvim) - UI enhancements
  - Big file handling
  - Dashboard customization
  - Git browse integration
  - Image preview
  - Indent guides
  - Input method support
  - Notifications
  - Quick file navigation
  - Scope visualization
  - Status column customization
  - Word highlighting

## Installation

1. Ensure you have Neovim installed (version 0.9.0 or higher)

2. Clone this configuration using Chezmoi:

   ```bash
   chezmoi init --apply
   ```

3. Start Neovim and let Lazy.nvim install all plugins:

   ```bash
   nvim
   ```

## Configuration Structure

The configuration is organized as follows:

- `init.lua.tmpl` - Main configuration file (Chezmoi template)
- `lua/plugins/` - Plugin configurations
  - `theme.lua` - Theme and UI settings
  - `git/blame.lua` - Git blame configuration
  - `snacks.lua` - UI enhancements

## Customization

### Theme

The configuration uses Catppuccin theme with the following features:

- Transparent background
- Mocha flavor
- Custom styles for comments and conditionals
- LSP integration with custom virtual text styles

### Git Blame

Custom git blame configuration includes:

- Date format: DD.MM.YYYY
- Virtual text style
- Custom key mappings:
  - `i` - Show commit info
  - `<TAB>` - Stack push
  - `<BS>` - Stack pop
  - `<CR>` - Show commit
  - `<Esc>` or `q` - Close

### UI Enhancements

Snacks.nvim provides various UI improvements:

- Big file handling
- Dashboard customization
- Git browse integration
- Image preview
- Indent guides
- Input method support
- Notifications
- Quick file navigation
- Scope visualization
- Status column customization
- Word highlighting

## Dependencies

- Neovim 0.9.0+
- A Nerd Font (for icons)
- Git (for git integration)
- [Chezmoi](https://www.chezmoi.io/) (for dotfiles management)

## Contributing

Feel free to submit issues and enhancement requests!
