# Chezmoi Scripts

This directory contains scripts that are executed by Chezmoi during the dotfiles installation and update process.

## Script Types

- `run_once_before-*.sh.tmpl`: Scripts that run once before applying dotfiles
- `run_onchange_after-*.sh.tmpl`: Scripts that run after changes are applied

## Scripts

- `run_once_before-00-detect-platform.sh.tmpl`: Detects the current platform and sets appropriate variables
- `run_once_before-01-install-mise.sh`: Installs mise for tool version management
- `run_once_before-02-install-homebrew.sh.tmpl`: Installs Homebrew package manager
- `run_once_before_05-sudo-touch-id.sh.tmpl`: Configures sudo to use Touch ID on macOS
- `run_onchange_after-07-install-homebrew-packages.sh.tmpl`: Installs/updates Homebrew packages
- `run_onchange_after-08-setup-homebrew-upgrade.sh.tmpl`: Sets up Homebrew auto-upgrade 