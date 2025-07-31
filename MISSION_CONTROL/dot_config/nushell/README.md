<div align="center">

# 🐚 Nushell Configuration 🌊

A modern and efficient Nushell setup with various customizations and integrations, managed with Chezmoi for seamless deployment.

<img src="https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/422.png" width="150" />

![Nushell](https://img.shields.io/badge/Shell-Nushell-blue?style=flat-square&logo=gnu-bash)
![Chezmoi](https://img.shields.io/badge/Managed_with-Chezmoi-blue?style=flat-square)
![Theme](https://img.shields.io/badge/Theme-Catppuccin-pink?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-yellow?style=flat-square)

</div>

## 📁 Configuration Structure

All Nushell configuration files are Chezmoi templates with the `.nu.tmpl` extension:

```shell
nushell/
├── 📝 config.nu.tmpl - Main configuration file
├── 🔄 aliases.nu.tmpl - Custom aliases and functions
├── 🌍 env.nu.tmpl - Environment variables
├── 🔒 secrets.nu.tmpl - Sensitive configuration (not tracked in git)
└── 💼 work.nu.tmpl - Work-specific configurations (conditionally loaded)
```

## 🌟 Features

### 🌍 Environment Management

<img src="https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/423.png" width="50" align="right" />

- **Mise Integration**: For tool version management
- **Custom Environment**: Variables and configurations tailored to your needs
- **Work Support**: Conditional loading of work-specific configurations

### 🎨 Theme Support

- **Catppuccin**: Integrated theme for a consistent look
- **Customizable Selection**: Easily change themes

### 📂 Directory Navigation

- **Zoxide**: Smart directory jumping capabilities
- **Custom Aliases**: Quick navigation to frequently used directories

### 🔄 GitHub Integration

<img src="https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/456.png" width="50" align="right" />

- **Repo Functions**: Custom functions for repository management
- **Workflow Commands**: Streamlined GitHub operations

### 🛠️ Development Tools

- **Neovim**: Integrated for text editing
- **Obsidian**: Vault management capabilities
- **Chezmoi**: Dotfiles management support

### 📊 System Information

- **Starship Prompt**: Rich and informative prompt integration
- **Pokemon Info**: Themed system information display

## 🚀 Aliases

### 📂 Directory Navigation

- **`l`**: List directory contents
- **`ll`**: List all files (including hidden)
- **`la`**: List all files with details

### 🔄 Chezmoi

- **`chezmoi_update`**: Update dotfiles excluding scripts
- **`cia`**: Quick apply dotfiles
- **`chezmoi_data`**: View Chezmoi configuration
- **`chezmoi_data_edit`**: Edit Chezmoi configuration

### 🧰 Other

- **`y`**: Launch Yazi file manager
- **`cat`**: Use `bat` for file viewing
- **`tks`**: Kill tmux server

## ⚡ Custom Functions

### 🔄 GitHub Management

- **`gh-create-repo`**: Create new repositories
- **`gh-clone-repo`**: Clone repositories
- **`gh-list-repos`**: List repositories
- **`gh-delete-repo`**: Delete repositories
- **`gh-add-remote`**: Add remote to local repository
- **`gh-open-repo`**: Open repository in browser

### 🖥️ System Management

- **`poke_system_info`**: Display system information with random Pokemon
- **`reset_nvim`**: Reset Neovim configuration
- **`obsidian_nvim`**: Open Obsidian vault in Neovim

### 🐳 Docker management

- **`docker_purge`**: Complete Docker cleanup with confirmation
- **`docker_purge --force`**: Force cleanup without confirmation
- **`docker_nuke`**: Alias for force cleanup

> ⚠️ **Warning**: These functions remove ALL Docker containers, volumes, images, networks, and build cache.

## 🌠 Installation

1. Clone this repository using Chezmoi:

   ```shell
   chezmoi init --apply
   ```

2. Configure Chezmoi data (if not already done):

   ```shell
   chezmoi data
   ```

3. Ensure all dependencies are installed:

   ```shell
   mise install
   ```

4. Restart your shell or source the configuration:

   ```shell
   source ~/.config/nushell/config.nu
   ```

## ⚙️ Customization

The configuration uses Chezmoi templates, allowing for dynamic configuration based on your environment:

- Theme: Set `CATPPUCCIN_FLAVOR` in your Chezmoi data to change the theme
- Work Environment: Set `WORK_ENVIRONMENT=true` in your Chezmoi data to enable work-specific configurations

### 🔄 Chezmoi Commands

- `chezmoi_update` - Update dotfiles excluding scripts
- `cia` - Quick apply dotfiles
- `chezmoi_data` - View Chezmoi configuration
- `chezmoi_data_edit` - Edit Chezmoi configuration
- `chezmoi_reset` - Reset Chezmoi state and reinitialize

## 🌍 Template Variables

The following Chezmoi template variables are used in the configuration:

- `CATPPUCCIN_FLAVOR` - Theme flavor for Catppuccin
- `WORK_ENVIRONMENT` - Enable work-specific configurations
- Additional variables can be found in `~/.config/chezmoi/chezmoi.toml`

## �� Dependencies

- **Nushell**: The shell environment itself ([Nushell](https://www.nushell.sh/))
- **Zoxide**: For smart directory jumping ([zoxide](https://github.com/ajeetdsouza/zoxide))
- **Mise**: For tool version management ([mise](https://github.com/jdx/mise))
- **Starship**: For the custom prompt ([starship](https://starship.rs/))
- **Chezmoi**: For dotfiles management ([Chezmoi](https://www.chezmoi.io/))
- **Neovim**: For text editing integration ([Neovim](https://neovim.io/))
- **Yazi**: For file management ([Yazi](https://github.com/sxyazi/yazi))
- **Bat**: For enhanced file viewing ([bat](https://github.com/sharkdp/bat))
- **Pokeget**: For fetching Pokemon sprites ([pokeget](https://github.com/talwat/pokeget))
- **Fastfetch**: For system information ([fastfetch](https://github.com/fastfetch-cli/fastfetch))

## 🌠 Contributing

Feel free to submit issues and enhancement requests. Together we can make this shell configuration shine brighter. ✨

<div align="center">
<img src="https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/457.png" width="100" />

Made with ❤️ and shell magic

</div>
