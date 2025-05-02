# Obsidian Configuration

A personalized Obsidian setup for knowledge management and note-taking,
integrated with Neovim for enhanced editing capabilities.

## Features

- **Vault Management**
  - Multiple vault support
  - Custom vault organization
  - Neovim integration

- **Plugin Configuration**
  - Core plugins
  - Community plugins
  - Custom settings

- **Theme and Styling**
  - Custom CSS snippets
  - Theme settings
  - Layout preferences

## Configuration Structure

The configuration is managed through Chezmoi:

- `.chezmoiexternal.toml.tmpl` - External template configuration for vault repositories
- Vault repositories are cloned to the `~/source/obsidian/` directory
- Neovim plugin configuration in `~/.config/nvim/lua/plugins/utilities/obsidian.lua`

## Installation

1. Clone this configuration using Chezmoi:

   ```zsh
   chezmoi init --apply
   ```

2. Obsidian will be automatically installed via Homebrew during the Chezmoi setup process,
   as it's defined in the shared casks.

3. Open your vaults in Obsidian

## Customization

### Vault Management

- Multiple vault support
- Custom vault organization
- Neovim integration for editing

### Plugin Settings

Configured plugins include:

- Core plugins
- Community plugins
- Custom settings

### Theme and Styling

- Custom CSS snippets
- Theme settings
- Layout preferences

## Neovim Integration

The configuration includes Neovim integration for enhanced editing:

- Custom commands for vault access via the Obsidian.nvim plugin
- Vault paths configured in `~/.config/nvim/lua/plugins/utilities/obsidian.lua`
- Nushell aliases for quick access via `obsidian_nvim` function
- Syntax highlighting and LSP integration for Markdown files

## Dependencies

- [Obsidian](https://obsidian.md/)
- [Neovim](https://neovim.io/)
- [Chezmoi](https://www.chezmoi.io/) (for dotfiles management)

## Contributing

Feel free to submit issues and enhancement requests!
