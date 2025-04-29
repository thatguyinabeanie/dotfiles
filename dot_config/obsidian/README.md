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

- `.chezmoiexternal.toml.tmpl` - External template configuration
- Vault-specific configurations
- Plugin settings

## Installation

1. Clone this configuration using Chezmoi:

   ```bash
   chezmoi init --apply
   ```

2. Install Obsidian:

   ```bash
   brew install --cask obsidian
   ```

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

- Custom commands for vault access
- Plugin support
- Syntax highlighting
- LSP integration

## Dependencies

- [Obsidian](https://obsidian.md/)
- [Neovim](https://neovim.io/)
- [Chezmoi](https://www.chezmoi.io/) (for dotfiles management)

## Contributing

Feel free to submit issues and enhancement requests!
