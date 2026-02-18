# Chezmoi Data Directory Guide

## Overview

The `.chezmoidata/` directory contains all declarative configuration data that drives
the dotfiles system. YAML files here are automatically loaded by chezmoi and made
available as template variables (for example, `.formatters`, `.linters`, `.dev_tools`).

**Note**: This guide lives in `.docs/agent/` because chezmoi's `.chezmoidata/`
directory only accepts data files (YAML, JSON, TOML) and rejects other formats.

## Critical Rule

**NEVER install packages manually** (npm, brew, pip, etc.). All packages MUST be
managed by editing the appropriate YAML file in `.chezmoidata/`, then running
`chezmoi apply`.

## File Reference

| File                     | Top-Level Key       | Purpose                                       |
| ------------------------ | ------------------- | --------------------------------------------- |
| `formatters.yaml`        | `formatters`        | Code formatters (prettier, stylua, etc.)      |
| `linters.yaml`           | `linters`           | Linters (eslint, shellcheck, vale, etc.)      |
| `tools.yaml`             | `dev_tools`         | CLI tools and utilities (ripgrep, fd, etc.)   |
| `lsp.yaml`               | `lsp_servers`       | Language server configurations                |
| `mcp.yaml`               | `mcp_servers`       | MCP server definitions                        |
| `applications.yaml`      | `applications`      | macOS GUI apps (casks, Mac App Store)         |
| `taps.yaml`              | `homebrew_taps`     | Homebrew tap repositories                     |
| `github-extensions.yaml` | `github_extensions` | GitHub CLI extensions                         |
| `services.yaml`          | `services`          | Background services (postgresql, etc.)        |
| `shared.yaml`            | (multiple)          | Shared settings: theme, font, terminal, UI    |
| `personal.yaml`          | (multiple)          | Personal identity and environment settings    |
| `work.yaml`              | (multiple)          | Work-specific overrides                       |
| `onepassword.yaml`       | (multiple)          | 1Password integration settings                |
| `opencode.yaml`          | (multiple)          | OpenCode editor configuration                 |
| `agents.yaml`            | `agents`            | AI agent tool configurations                  |
| `ai/`                    | (per-provider)      | AI provider configs (anthropic, google, etc.) |

## Schema Patterns

Most package YAML files follow this structure:

```yaml
top_level_key:
  - name: package-name
    installer: [mise]              # Installation method(s)
    languages: [python, yaml]      # (formatters/linters) Languages supported
    description: "Optional note"   # Human-readable description
    conflicts_with_lsp_formatting: true  # (formatters) Conflict flag
```

Common `installer` values:

- `[mise]` - Preferred for CLI tools (version-managed)
- `[brew]` - Homebrew formula
- `[mason]` - Neovim Mason (LSP servers, formatters, linters)
- `[npm]` - Node.js packages
- `[pip]` - Python packages
- `[cargo]` - Rust packages
- Multiple allowed: `[mise, mason]` means "install via both"

## Data Flow into Templates

1. Chezmoi loads all `.chezmoidata/*.yaml` files automatically
2. Template queries in `.chezmoitemplates/queries/` extract package lists by installer
3. Installer scripts (`.chezmoiscripts/`) use these queries to determine what to install

Key query templates:

- `queries/packages.tmpl` - Filters packages by `PackageManager`
- `queries/brew-formulae.tmpl` - Extracts Homebrew formula packages
- `queries/brew-casks.tmpl` - Extracts Homebrew cask packages
- `queries/append-packages.tmpl` - Appends additional packages to a list

## Validation Workflow

1. Edit the appropriate YAML file
2. Run `chezmoi apply --dry-run` to validate
3. Run `chezmoi apply --force` to apply
4. Verify the package is installed and functional

## Common Pitfalls

- **Duplicate entries**: Always check existing entries before adding a new package
- **Wrong installer**: Match the installer to how other similar packages are installed
- **Missing top-level key**: Each file uses a specific YAML key - match the pattern
- **Direct installation**: Never run `brew install`, `npm install -g`, etc. directly
