# Aerospace Agent Guide

## Overview

Aerospace is a tiling window manager for macOS. It works with Ghostty and other GUI applications.

## Configuration Discovery

- **Primary file**: `aerospace.toml`
- **Search patterns**: `rg "key" dot_config/aerospace/aerospace.toml`
- **No template variables or data sources** - this is a static TOML config

## Common Tasks

### Change a keybinding

- **File**: `aerospace.toml`
- **Validation**: Restart Aerospace to apply changes
- **Conflicts**: Check for conflicts with other application shortcuts

### Change layout settings

- **File**: `aerospace.toml`
- **Validation**: Restart Aerospace to apply changes

## Validation Checklist

- [ ] Restart Aerospace to apply any changes
- [ ] Test all changes to ensure they work as expected

## Troubleshooting

- **Common errors**: Incorrect TOML syntax
- **Conflict resolution**: Change conflicting keybindings
- **Rollback**: Revert changes in git
