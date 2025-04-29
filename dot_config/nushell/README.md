# Nushell Configuration

This repository contains my personal Nushell configuration, featuring a modern
and efficient shell setup with various customizations and integrations.
The configuration is managed using [Chezmoi](https://www.chezmoi.io/),
a dotfiles manager that allows for template-based configuration.

## Configuration Structure

All Nushell configuration files are Chezmoi templates with the `.nu.tmpl` extension:

- `config.nu.tmpl` - Main configuration file
- `aliases.nu.tmpl` - Custom aliases and functions
- `env.nu.tmpl` - Environment variables
- `secrets.nu.tmpl` - Sensitive configuration (not tracked in git)
- `work.nu.tmpl` - Work-specific configurations (conditionally loaded)

## Features

- **Environment Management**
  - Integration with `mise` for tool version management
  - Custom environment variables and configurations
  - Support for work-specific configurations

- **Theme Support**
  - Catppuccin theme integration
  - Customizable theme selection

- **Directory Navigation**
  - `zoxide` integration for smart directory jumping
  - Custom directory aliases for quick navigation

- **GitHub Integration**
  - Custom functions for repository management
  - Streamlined GitHub workflow commands

- **Development Tools**
  - Neovim integration
  - Obsidian vault management
  - Chezmoi dotfiles management

- **System Information**
  - Starship prompt integration
  - Pokemon-themed system information display

## Aliases

### Directory Navigation

- `l` - List directory contents
- `ll` - List all files (including hidden)
- `la` - List all files with details

### Chezmoi

- `chezmoi_update` - Update dotfiles excluding scripts
- `cia` - Quick apply dotfiles
- `chezmoi_data` - View Chezmoi configuration
- `chezmoi_data_edit` - Edit Chezmoi configuration

### Other

- `y` - Launch Yazi file manager
- `cat` - Use `bat` for file viewing
- `tks` - Kill tmux server

## Custom Functions

### GitHub Management

- `gh-create-repo` - Create new repositories
- `gh-clone-repo` - Clone repositories
- `gh-list-repos` - List repositories
- `gh-delete-repo` - Delete repositories
- `gh-add-remote` - Add remote to local repository
- `gh-open-repo` - Open repository in browser

### System Management

- `poke_system_info` - Display system information with random Pokemon
- `reset_nvim` - Reset Neovim configuration
- `obsidian_nvim` - Open Obsidian vault in Neovim

## Dependencies

- [Nushell](https://www.nushell.sh/)
- [zoxide](https://github.com/ajeetdsouza/zoxide)
- [mise](https://github.com/jdx/mise)
- [starship](https://starship.rs/)
- [Chezmoi](https://www.chezmoi.io/)
- [Neovim](https://neovim.io/)
- [Yazi](https://github.com/sxyazi/yazi)
- [bat](https://github.com/sharkdp/bat)
- [pokeget](https://github.com/talwat/pokeget)
- [fastfetch](https://github.com/fastfetch-cli/fastfetch)

## Installation

1. Clone this repository using Chezmoi:

   ```bash
   chezmoi init --apply
   ```

2. Configure Chezmoi data (if not already done):

   ```bash
   chezmoi data
   ```

3. Ensure all dependencies are installed:

   ```bash
   mise install
   ```

4. Restart your shell or source the configuration:

   ```bash
   source ~/.config/nushell/config.nu
   ```

## Customization

The configuration uses Chezmoi templates, allowing for dynamic configuration based on your environment:

- Theme: Set `CATPPUCCIN_FLAVOR` in your Chezmoi data to change the theme
- Work Environment: Set `WORK_ENVIRONMENT=true` in your Chezmoi data to enable work-specific configurations

### Chezmoi Commands

- `chezmoi_update` - Update dotfiles excluding scripts
- `cia` - Quick apply dotfiles
- `chezmoi_data` - View Chezmoi configuration
- `chezmoi_data_edit` - Edit Chezmoi configuration
- `chezmoi_reset` - Reset Chezmoi state and reinitialize

## Template Variables

The following Chezmoi template variables are used in the configuration:

- `CATPPUCCIN_FLAVOR` - Theme flavor for Catppuccin
- `WORK_ENVIRONMENT` - Enable work-specific configurations
- Additional variables can be found in `~/.config/chezmoi/chezmoi.toml`

## Contributing

Feel free to submit issues and enhancement requests!
