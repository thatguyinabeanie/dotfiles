# 🌟 MISSION_CONTROL


<div align="center">
  <img src="https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/801.png" width="150" alt="Magearna" />
</div>


This is the main directory managed by chezmoi, containing all configuration files and scripts for your cosmic development environment.

## 📂 Directory Structure

- **`.chezmoidata/`** - YAML configuration data files used in templates
- **`.chezmoiscripts/`** - Scripts that run at various stages of installation
- **`.chezmoitemplates/`** - Reusable template fragments for configuration files
- **`dot_config/`** - Configuration files for applications (maps to `~/.config/`)
- **`dot_local/`** - User-specific data files (maps to `~/.local/`)
- **`dot_personal/`** - Personal data and configuration
- **`empty_dot_config/`** - Empty directory structure for configs (e.g., Obsidian vault)
- **`private_dot_ssh/`** - SSH configuration (encrypted)
- **`Library/`** - macOS Library directory contents

## 🔄 How It Works

The `.chezmoiroot` file in the parent directory points chezmoi to this directory as the source of truth. Files and directories are processed according to the following conventions:

- Files/dirs prefixed with `dot_` become hidden (e.g., `dot_config` → `.config`)
- Files/dirs prefixed with `private_` are treated as sensitive (may be encrypted)
- Files/dirs prefixed with `symlink_` become symbolic links
- Files with `.tmpl` extension are processed as templates
- Files with `.literal` extension are copied as-is without template processing

## 🚀 Key Files

- **`.chezmoi.toml.tmpl`** - Main configuration template for chezmoi
- **`.chezmoiexternal.toml.tmpl`** - External sources configuration
- **`.chezmoiignore`** - Patterns for files to ignore

## 🌠 Adding New Configuration

When adding new configuration for applications:

1. Create directories under `dot_config/` matching the app's config location
2. Use the `.tmpl` extension for files that need templating
3. Use the appropriate prefix based on the destination (e.g., `dot_`, `private_`)
4. Add `.keep` files to ensure empty directories are tracked

## 🔄 Updating Configuration

After making changes to your local configuration:

1. Run `chezmoi add ~/.config/app_name` to update the repository
2. Check the diff with `chezmoi diff`
3. Commit changes to version control

## 📚 Documentation

Each major section has its own README with more specific documentation:

- [Chezmoi Scripts](.chezmoiscripts/.README.md)
- [Neovim Configuration](dot_config/nvim/README.md)
- [Nushell Configuration](dot_config/nushell/README.md)
- [Git Configuration](dot_config/git/README.md)
- [Obsidian Configuration](dot_config/obsidian/README.md)
