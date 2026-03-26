# Ghostty Agent Guide

> **Scope:** This file covers Ghostty terminal configuration only.
> For package management, chezmoi workflow, and project-wide rules, see the root `AGENTS.md`.

## Quick Overview

- **Purpose**: Ghostty is a high-performance, GPU-accelerated terminal emulator.
- **Integration**: Tightly integrated with tmux for session management and Nushell/Zsh for startup.

## Configuration Discovery

- **Primary files**:
  - `config.tmpl` - Main configuration template (keybindings, appearance, behavior)
  - `executable_ghostty-tmux.zsh.tmpl` - Tmux auto-launcher script (runs on shell startup)
  - `executable_ghostty-init.zsh.tmpl` - Shell initialization hook
- **Data sources**:
  - `.chezmoidata/shared.yaml` - UI settings (opacity, blur, font, cursor, theme)
  - `.chezmoidata/personal.yaml` - Keybindings and personal settings
- **Search patterns**:
  - Keybindings: `rg "keybind" dot_config/ghostty/config.tmpl`
  - Appearance: `rg "theme|color|font" dot_config/ghostty/config.tmpl`
- **Template variables**:
  - `{{ .ui.* }}` for appearance (font, opacity, blur, cursor, window size)
  - `{{ .CATPPUCCIN_FLAVOR }}` for Catppuccin theme selection

## Common Tasks

### Change Keybindings

- **Files**: Edit `dot_config/ghostty/config.tmpl` and `.chezmoidata/personal.yaml`.
- **Validation**: No specific syntax checker; rely on `chezmoi apply --dry-run`.
- **Conflicts**: Check for overlaps with tmux (`dot_config/tmux/`) and Aerospace (`dot_config/aerospace/`).

### Modify Appearance

- **Files**:
  - `config.tmpl` for structure
  - `.chezmoidata/shared.yaml` for UI values (opacity, blur, font) and theme (`CATPPUCCIN_FLAVOR`)
- **Dependencies**: Theme changes in `shared.yaml` affect Neovim, tmux, and other tools.
- **Testing**: Visually inspect terminal after `chezmoi apply`.

## Validation Checklist

- [ ] Edit source files (`.tmpl`, `.yaml`), not generated targets.
- [ ] Check for keybinding conflicts with tmux and Aerospace.
- [ ] Run `chezmoi apply --dry-run` to catch template errors.
- [ ] Visually verify terminal functionality after applying changes.

## Troubleshooting

- **Common errors**: Mismatched template variables in `.chezmoidata/`.
- **Conflict resolution**: Ensure keybinds are namespaced or unique across tools.
- **Rollback**: Revert changes in git and run `chezmoi apply`.

## Related Documentation

- [Tmux Agent Guide](../tmux/AGENTS.md)—tmux auto-launcher integration via `ghostty-tmux.zsh`
- [Aerospace Agent Guide](../aerospace/AGENTS.md)—potential keybinding conflicts
