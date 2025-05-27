# 🧿 Obsidian Setup & Vaults

<!-- markdownlint-disable MD013 MD045 -->
<div align="center">
  <img src="https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/561.png" width="150" alt="Sigilyph" />
</div>
<!-- markdownlint-enable MD013 MD045 -->

This directory contains configuration for [Obsidian](https://obsidian.md/), a powerful knowledge base that works on top of a local folder of plain text Markdown files.

## 📜 Overview

The Obsidian configuration in this dotfiles repository is designed to:

1. Automatically set up Obsidian vaults based on your environment
2. Provide integration with Neovim through the Obsidian.nvim plugin
3. Support separate vaults for personal and work use
4. Manage vault repositories through chezmoi's external configuration

## 🏗️ Structure

- **MISSION_CONTROL/obsidian/** - Contains external repository configurations
  - `.chezmoiexternal.toml.tmpl` - Template for external vault repositories
  - `README.md` - This documentation file

- **MISSION_CONTROL/dot_config/obsidian/** - Contains Obsidian application configuration
  - `config.json.tmpl` - Templated configuration for Obsidian
  - `run_once_after_create_vault_dirs.sh.tmpl` - Script to create work vault directory (conditional)

- **MISSION_CONTROL/empty_dot_config/empty_obsidian/empty_obsidian-vault/** - Empty directory structure
  - Creates the personal vault directory structure using chezmoi's native features

## 🏛️ Vault Configuration

The configuration supports two primary vaults:

1. **Personal Vault** - Always created at `~/.config/obsidian/obsidian-vault`
2. **Work Vault** - Created at `~/.config/obsidian/obsidian-vault-work` when `WORK_ENVIRONMENT` is set to `true`

## 🌐 External Repositories

The `.chezmoiexternal.toml.tmpl` file defines external repositories that will be cloned as Obsidian vaults:

- **obsidian-vault**: Personal vault repository
- **bramses-highly-opinionated-vault-2023**: Example vault with useful templates
- **smart-notes**: Example vault with note-taking methodology
- **obsidian-vault-work**: Work vault repository (only when `WORK_ENVIRONMENT` is true)

## 🔗 Neovim Integration

The Obsidian configuration is designed to work with the [Obsidian.nvim](https://github.com/epwalsh/obsidian.nvim) plugin, which is configured in the Neovim configuration.

## ▶️ Usage

After running `chezmoi apply`, your Obsidian vaults will be set up automatically. You can then:

1. Open Obsidian
2. Select the appropriate vault
3. Start taking notes!

## 🛠️ Customization

To customize your Obsidian setup:

1. Modify the `config.json.tmpl` file to change Obsidian settings
2. Update the `.chezmoiexternal.toml.tmpl` file to add or remove external vault repositories
3. Adjust the Neovim Obsidian plugin configuration in `MISSION_CONTROL/dot_config/nvim/lua/plugins/utilities/obsidian.lua.tmpl`
