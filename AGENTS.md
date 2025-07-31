# Agents.md

Essential guidance for coding agents working with this Chezmoi dot files repository.

## Essential commands

```bash
# Run all quality checks
lefthook run pre-commit

# Apply dotfiles changes
chezmoi apply && chezmoi diff
```

## Theme configuration

This repository implements a flexible theme management system that allows manual control over theme behavior across applications.

### Theme variables

Configure themes by editing `$HOME/.config/chezmoi/chezmoi.toml`:

```toml
[data]
THEME_MODE = "system"              # Options: "system", "dark", "light"
THEME_LIGHT = "catppuccin-latte"   # Light theme variant
THEME_DARK = "catppuccin-mocha"    # Dark theme variant
```

### Theme modes

- **"system"**: Automatically switches between light/dark based on macOS system appearance
- **"dark"**: Forces dark theme regardless of system setting
- **"light"**: Forces light theme regardless of system setting

### Supported applications

- **Ghostty**: Uses conditional theme configuration with native macOS integration
- **Neovim**: Uses auto-dark-mode plugin for system mode, static colorschemes for manual modes
- **Other apps**: All use the `CATPPUCCIN_FLAVOR` variable for consistent theming

### Usage

1. Edit theme variables in chezmoi configuration
2. Run `chezmoi apply` to update configurations
3. Restart applications to pick up new theme settings

## Code style guidelines

- **Naming**: `dot_` prefix for hidden files, `private_` for encrypted, `.tmpl` for templates
- **Shell Scripts**: Use shellcheck for linting
- **YAML**: Follow yamllint configuration
- **Markdown**: Use Vale for prose linting
