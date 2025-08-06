# 📚 Obsidian Configuration


<div align="center">
  <img src="https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/480.png" width="150" alt="Uxie" />
</div>


This directory contains configuration files for [Obsidian](https://obsidian.md/), a powerful knowledge base that works on top of a local folder of plain text Markdown files.

## 📂 Structure and Files

- **config.json.tmpl** - Templated Obsidian configuration that adjusts based on user preferences
- **run_once_after_create_vault_dirs.sh.tmpl** - Script that runs after chezmoi apply to create vault directories

## 🗄️ Vault Locations

- **Personal Vault**: `~/.config/obsidian/obsidian-vault`
- **Work Vault**: `~/.config/obsidian/work-vault` (Only created when `work_environment` is true)

## 🧩 Integration with Neovim

This configuration is used by the Obsidian.nvim plugin to integrate Obsidian with Neovim. The Neovim configuration automatically detects available vaults and configures the plugin accordingly.

Benefits of this integration:

- **Edit in Neovim**: Modify Obsidian notes using Neovim's powerful editing features
- **Link Following**: Navigate between notes by following links directly within Neovim
- **Templated Notes**: Create new notes efficiently using predefined templates
- **Full-Vault Search**: Search across your entire Obsidian vault from Neovim

## 🔄 Vault Management

Obsidian vaults are managed through chezmoi configuration:

1. **Empty Directories**: Personal vault directory created at `~/.config/obsidian/obsidian-vault`
2. **External Repositories**: For existing vaults, managed via chezmoi external config.

### 💡 Initializing a New Vault

To initialize a new vault:

1. The empty vault directories are created during installation
2. Obsidian will detect these directories on first launch
3. Choose the directory when prompted by Obsidian

### 🗝️ Using Existing Vaults

To use an existing vault:

1. Add your vault repository URL to `dot_config/obsidian/.chezmoiexternal.toml.tmpl`
2. Run `chezmoi apply` to clone the repository to the correct location

## 🚀 Customization

To customize your Obsidian setup:

1. Modify `config.json.tmpl` to change global settings
2. Add plugins by editing the plugins array in the config
3. Adjust the vault creation script if you need additional vault directories
