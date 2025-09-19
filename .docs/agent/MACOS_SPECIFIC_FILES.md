# macOS Specific Files Agent Guide

## Quick Overview

- **Purpose**: This document lists files that require conditional logic for macOS.
- **Integration**: N/A

## Key Principles

- Use `{{ if .is_macos }}` blocks in templates to apply macOS-specific configuration.
- Keep macOS-specific data in `.chezmoidata/macos.yaml`.

## Common Tasks

### Add a new macOS-specific setting

- **Files**: Add the setting to a template within a `{{ if .is_macos }}` block.
- **Validation**: Run `chezmoi apply --dry-run` on a macOS machine.
- **Conflicts**: N/A

### Add new macOS-specific data

- **Files**: Add the data to `.chezmoidata/macos.yaml`.
- **Validation**: Run `chezmoi apply --dry-run` on a macOS machine.
- **Conflicts**: N/A

## Validation Checklist

- [ ] Use `{{ if .is_macos }}` for all macOS-specific configuration.
- [ ] Test all changes on a macOS machine.

## Troubleshooting

- **Common errors**: Forgetting to wrap macOS-specific settings in `{{ if .is_macos }}`.
- **Conflict resolution**: N/A
- **Rollback**: Revert changes in git.
