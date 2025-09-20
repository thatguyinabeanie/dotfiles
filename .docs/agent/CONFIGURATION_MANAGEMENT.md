# Configuration Management Agent Guide

## Quick Overview

- **Purpose**: This document explains how configuration data is managed in the repository.
- **Integration**: N/A

## Key Principles

- **Source of truth**: All configuration lives in chezmoi templates (`.tmpl`) and data (`.chezmoidata/`).
- **Generated files**: Files in `~/.config/` are generated and should never be edited directly.
- **Workflow**: Edit source -> validate with dry-run -> apply through chezmoi.

## Common Tasks

### Modify a configuration file

- **Files**: Edit the appropriate `.tmpl` file.
- **Validation**: Run `chezmoi apply --dry-run`.
- **Conflicts**: N/A

### Modify configuration data

- **Files**: Edit the appropriate `.yaml` file in `.chezmoidata/`.
- **Validation**: Run `chezmoi apply --dry-run`.
- **Conflicts**: N/A

## Validation Checklist

- [ ] Never edit generated files directly.
- [ ] Always use `chezmoi apply --dry-run` to validate changes.

## Troubleshooting

- **Common errors**: Conflicts due to manual edits of generated files.
- **Conflict resolution**: Use `chezmoi diff` to see changes and update the source template.
- **Rollback**: Revert changes in git.
