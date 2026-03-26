# Aerospace Agent Guide

> **Scope:** This file covers Aerospace window manager configuration only (macOS).
> For package management, chezmoi workflow, and project-wide rules, see the root `AGENTS.md`.

## Overview

Aerospace is a tiling window manager for **macOS only**. It manages window placement
across workspaces using keyboard-driven commands.

## Configuration Discovery

- **Primary file**: `aerospace.toml`, a static TOML config (no chezmoi templates)
- **Keybindings**: Defined inline in `aerospace.toml` under `[mode.main.binding]` and `[mode.service.binding]`
- **Workspaces**: Workspace-to-monitor assignments and app-to-workspace rules are in the same file
- **Search patterns**: `rg "bind|workspace" dot_config/aerospace/aerospace.toml`

## Key Concepts

- **Alt (Option) is the primary modifier**: read `aerospace.toml` for the full binding map
- **Two modes**: `main` (default) and `service` (toggled for less-common actions)
- **Workspace IDs** correspond to app categories (for example, workspace 1 = browsers, workspace 2 = terminals)
- **No template variables**: this is a plain TOML file, not chezmoi-templated

## Common Tasks

### Change a keybinding

- **File**: `aerospace.toml`, look for `[mode.main.binding]` or `[mode.service.binding]`
- **Validation**: `aerospace reload-config` or restart Aerospace
- **Conflicts**: Check for overlaps with Ghostty and system shortcuts

### Change workspace assignments

- **File**: `aerospace.toml`, look for `[[on-window-detected]]` rules
- **Validation**: Restart Aerospace to apply

## Validation Checklist

- [ ] `aerospace reload-config` succeeds (or restart the app)
- [ ] No TOML syntax errors (Aerospace logs errors to stdout)
- [ ] Keybindings don't conflict with Ghostty or system shortcuts

## Troubleshooting

- **Config errors**: `aerospace reload-config` outputs errors to the terminal
- **Keybinding conflicts**: macOS system shortcuts take priority. Check System Settings > Keyboard > Shortcuts.
- **Rollback**: Revert changes in git and reload

## Related Documentation

- [Ghostty Agent Guide](../ghostty/AGENTS.md) — potential keybinding conflicts
