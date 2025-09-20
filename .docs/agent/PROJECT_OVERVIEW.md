# Project Overview Agent Guide

## Quick Overview

- **Purpose**: This repository manages a comprehensive dotfiles configuration using chezmoi.
- **Integration**: Integrates with mise for tool version management, Homebrew for package installation, and various shell environments (Zsh, Nushell).

## Configuration Discovery

- **Primary files**:
  - `.chezmoi.toml.tmpl` - Main chezmoi configuration
  - `.chezmoidata/` - All configuration data (YAML files)
- **Search patterns**:
  - Packages: `rg "package|brew" .chezmoidata/`
  - Tools: `rg "tool|mise" .chezmoidata/`
- **Template variables**:
  - `{{ .packages.* }}` for Homebrew packages
  - `{{ .tools.* }}` for mise tools

## Common Tasks

### Add a new tool

- **Files**: Edit `.chezmoidata/tools.yaml`.
- **Validation**: Run `mise install` after `chezmoi apply`.
- **Conflicts**: Check for version conflicts with existing tools.

### Add a new package

- **Files**: Edit `.chezmoidata/packages.yaml`.
- **Validation**: Run `brew install` after `chezmoi apply`.
- **Conflicts**: Check for conflicts with existing packages.

## Validation Checklist

- [ ] Edit source files (`.yaml`), not generated targets.
- [ ] Run `chezmoi apply --dry-run` to catch template errors.
- [ ] Verify tool/package installation after applying changes.

## Troubleshooting

- **Common errors**: Incorrect package/tool names in YAML files.
- **Conflict resolution**: Ensure consistent versions across different environments.
- **Rollback**: Revert changes in git and run `chezmoi apply`.
