# Agents.md

Essential guidance for coding agents working with this Chezmoi dot files repository.

## Essential commands

```bash
# Run all tests
cd _tests_ && go test -v ./...

# Run single test file  
cd _tests_ && go test -v ./unit/config_test.go

# Run tests for changed files only
cd _tests_ && ./scripts/run_relevant_tests.sh

# Run all quality checks
lefthook run pre-commit

# Apply dotfiles changes
chezmoi apply && chezmoi diff
```

## Theme configuration

This repository implements a flexible theme management system that allows manual control over theme behavior across applications.

### Theme variables

Configure themes by editing `/Users/gmendoza/.config/chezmoi/chezmoi.toml`:

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

- **Go**: Use standard Go conventions, snake_case for test functions, table-driven tests
- **Imports**: Group stdlib, third-party, local packages with blank lines between groups
- **Tests**: Place in `_tests_/` directory, use `github.com/alecthomas/assert/v2` for assertions
- **Naming**: `dot_` prefix for hidden files, `private_` for encrypted, `.tmpl` for templates
- **Error Handling**: Always check errors, use descriptive error messages
- **Coverage**: Maintain 80% test coverage threshold (enforced by CI)
