# Chezmoi Data

This directory contains YAML configuration files used by Chezmoi to manage dotfiles configuration.

## Configuration Files

- `homebrew.yaml`: Homebrew package and cask configurations
- `mise.yaml`: Tool version management configurations
- `platform.yaml`: Platform-specific settings and detection results
- `treesitter.yaml`: Tree-sitter grammar configurations for Neovim

## Usage

These files are used as templates by Chezmoi to generate the final configuration files. They are not meant to be edited directly, but rather through Chezmoi's data management commands:

```shell
chezmoi data        # View current data
chezmoi data edit   # Edit data in your editor
``` 