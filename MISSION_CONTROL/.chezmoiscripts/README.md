# 🔄 Chezmoi Scripts

This directory contains automation scripts that are executed at specific points in the chezmoi lifecycle. Each script follows a naming convention that determines when it runs.

## 🚀 Script Execution Order

Scripts are executed in lexical order based on their filenames:

1. `run_once_before-00-detect-platform.sh.tmpl` - Detects and sets platform-specific variables
2. `run_once_before-01-install-mise.sh` - Installs mise (runtime version manager)
3. `run_once_before-02-install-homebrew.sh.tmpl` - Installs Homebrew if needed
4. `run_once_before_05-sudo-touch-id.sh.tmpl` - Configures sudo to work with Touch ID
5. `run_onchange_after-07-install-homebrew-packages.sh.tmpl` - Installs/updates packages
6. `run_once_after-10-install-pre-commit-hooks.sh.tmpl` - Sets up pre-commit hooks

## 📋 Naming Convention

Scripts follow this naming pattern:

- `run_once_before_*` - Runs once before files are copied
- `run_once_after_*` - Runs once after files are copied
- `run_onchange_before_*` - Runs when script content changes, before files are copied
- `run_onchange_after_*` - Runs when script content changes, after files are copied

The numeric prefix (e.g., `00-`, `01-`) determines execution order.

## 📝 Templates

Scripts with `.tmpl` extension are templates that get rendered with chezmoi data variables before execution.

## 🛠️ Adding New Scripts

When adding new scripts:

1. Follow the naming convention
2. Use appropriate numbering for execution order
3. Make shell scripts executable (`chmod +x`)
4. Use template syntax for platform-specific logic

For more information, see the [chezmoi documentation on scripts](https://www.chezmoi.io/user-guide/use-scripts-to-perform-actions/).
