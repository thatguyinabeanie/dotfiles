# Agents.md

## Project Overview

This repository contains a comprehensive and highly-automated dotfiles configuration managed by [Chezmoi](https://www.chezmoi.io/). It aims to create a consistent, modern, and efficient development environment across multiple machines, with a strong emphasis on macOS and a clear path for Linux expansion.

The setup is meticulously organized, leveraging a modular data structure within the `.chezmoidata` directory to manage packages, environment variables, system configurations, and development tools. It uses `mise` for tool version management, ensuring reproducible environments.

Key technologies include **Go** for testing, **Shell (Bash/Zsh/Nushell)** for scripting, **Lua** for Neovim configuration, and extensive **YAML** for data configuration.

## Build/Test Commands

```bash
# Setup hooks after cloning repo (one-time)
# Note: hooks auto-install via mise postinstall hook, but you can manually run:
mise run setup-hooks

# Run all quality checks (linting, formatting, security)
lefthook run pre-commit

# Apply dotfiles changes
chezmoi apply --force

# See what changes would be made without applying them
chezmoi diff

# Validate template changes during development (recommended workflow)
chezmoi apply --dry-run  # Test for template syntax errors
chezmoi apply --force     # Apply only if dry-run succeeds

# Run all tests
cd .tests && go test ./...

# Run single test file
cd .tests && go test ./unit/config_test.go -v

# Run tests with coverage
cd .tests && go test -coverprofile=coverage.out ./... && go tool cover -html=coverage.out

# Run relevant tests for changed files
.tests/scripts/run_relevant_tests.sh
```

## Template Development Best Practices

### DRY Principle in Templates

- **Avoid duplication**: Use shared query templates in `.chezmoitemplates/queries/` to extract package lists for different managers
- **Targeted hashing**: Package installer scripts use specific hash triggers (e.g., `{{ template "queries/cargo-packages.tmpl" . }}`) instead of hashing entire configuration files
- **Iterative validation**: Always run `chezmoi apply --dry-run` during development to catch template syntax errors before applying changes

### Iterative Development Workflow

1. **Make template changes**
2. **Validate with dry-run**: `chezmoi apply --dry-run`
3. **Fix any template syntax errors**
4. **Apply when validation passes**: `chezmoi apply --force`
5. **Test the actual functionality** (installation scripts, etc.)

This workflow prevents broken templates from being applied to your system and ensures robust template development.

## Code Style Guidelines

- **Go**: Follow golangci-lint rules (govet, errcheck, staticcheck, gosec, revive). Use `github.com/alecthomas/assert/v2` for tests. Imports are grouped (standard, third-party, local).
- **Lua**: Use stylua formatting, follow luacheck rules. Neovim globals (`vim`) are allowed
- **Shell**: Use shellcheck for linting. Follow POSIX compatibility where possible
- **YAML**: Max 120 chars, no document-start markers (`---`), newline at EOF required.
- **Markdown**: Use Vale for prose linting, follow markdownlint rules.

### Naming Conventions

- `dot_`: Prefix for hidden files managed by Chezmoi.
- `private_`: Prefix for files encrypted by Chezmoi.
- `.tmpl`: Suffix for Chezmoi templates.

## Configuration Management

- Configuration data is highly modularized within the `.chezmoidata` directory, separated by platform (macOS, cross-platform) and context (shared, personal, work).
- A persistent configuration system is in place to store and restore settings across system reinstalls. Use the `chezmoi-backup-config` and `chezmoi-restore-config` scripts to manage this.

## macOS-Specific Files

When adding cross-platform support, these files/directories are macOS-only and should use `{{- if eq .chezmoi.os "darwin" }}` conditionals:

- **Directories**: `Library/`, `.chezmoiscripts/macos/`, `dot_config/aerospace/`, `dot_config/karabiner/`
- **Homebrew Dependencies**: Profile/shell configs, tmux, nushell, ghostty configs reference `/opt/homebrew`
- **macOS Apps**: Aerospace (window manager), Karabiner (key remapper), Raycast, Mac App Store apps
- **System Integration**: LaunchAgents, AppleScript commands in aliases, macOS-specific paths
