# Aerospace Agent Guide

## Quick Overview

- **Purpose**: This document provides guidance for managing the Aerospace tiling window manager configuration.
- **Integration**: Works with Ghostty and other GUI applications.

## Configuration Discovery

- **Primary files**: `dot_config/aerospace/aerospace.toml`
- **Data sources**: N/A
- **Search patterns**:
  - Keybindings: `rg "key" dot_config/aerospace/aerospace.toml`
- **Template variables**: N/A

## Common Tasks

### Change a keybinding

- **Files**: Edit `dot_config/aerospace/aerospace.toml`.
- **Validation**: Restart Aerospace to apply changes.
- **Conflicts**: Check for conflicts with other application shortcuts.

### Change layout settings

- **Files**: Edit `dot_config/aerospace/aerospace.toml`.
- **Validation**: Restart Aerospace to apply changes.
- **Conflicts**: N/A

## Validation Checklist

- [ ] Restart Aerospace to apply any changes.
- [ ] Test all changes to ensure they work as expected.

## Troubleshooting

- **Common errors**: Incorrect TOML syntax.
- **Conflict resolution**: Change conflicting keybindings.
- **Rollback**: Revert changes in git.
