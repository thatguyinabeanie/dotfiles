# Neovim Configuration

A modern Neovim configuration built on top of LazyVim,
featuring a beautiful and functional setup with various plugins and customizations.

## Features

- **Modern UI**
  - **Theme**: Catppuccin with transparent background
  - **Bufferline**: For tab management
  - **Lualine**: Status line with custom sections
  - **Snacks**: For enhanced UI elements

- **Git Integration**
  - **Git Blame**: With virtual text
  - **Commit Info**: View for commit details
  - **Custom Mappings**: For Git operations

- **LSP Support**
  - **Native Integration**: Built-in LSP support
  - **Diagnostics**: Signs and virtual text for errors/warnings
  - **Inlay Hints**: Support for inline code hints
  - **Treesitter**: Integration for advanced syntax parsing

- **Enhanced Editing**
  - **Indent Scope**: Visualization for indentation levels
  - **Word Highlighting**: To easily spot occurrences
  - **Quick Navigation**: For fast file access
  - **Input Method**: Support for various input methods

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

   ```zsh
   chezmoi init --apply
   ```

3. Start Neovim and let Lazy.nvim install all plugins:

   ```zsh
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

- **Neovim**: Version 0.9.0+ required
- **Nerd Font**: Required for icons
- **Git**: For Git integration
- **Chezmoi**: For dotfiles management ([Chezmoi](https://www.chezmoi.io/))

## Contributing

Feel free to submit issues and enhancement requests!
