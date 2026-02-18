# Ghostty Agent Guide

## Quick Overview

- **Purpose**: Ghostty is a high-performance, GPU-accelerated terminal emulator.
- **Integration**: Tightly integrated with tmux for session management and Nushell/Zsh for startup.

## Configuration Discovery

- **Primary files**:
  - `dot_config/ghostty/config.tmpl` - Main configuration template
- **Data sources**:
  - `.chezmoidata/shared.yaml` - UI settings (opacity, blur, etc.)
  - `.chezmoidata/personal.yaml` - Keybindings and font settings
- **Search patterns**:
  - Keybindings: `rg "key|bind" dot_config/ghostty/`
  - Appearance: `rg "theme|color|font" dot_config/ghostty/`
- **Template variables**:
  - `{{ .ui.* }}` for appearance
  - `{{ .theme.* }}` for colors
  - `{{ .keybinds.ghostty.* }}` for shortcuts

## Common Tasks

### Change Keybindings

- **Files**: Edit `dot_config/ghostty/config.tmpl` and `.chezmoidata/personal.yaml`.
- **Validation**: No specific syntax checker; rely on `chezmoi apply --dry-run`.
- **Conflicts**: Check for overlaps with tmux (`dot_config/tmux/`) and Aerospace (`dot_config/aerospace/`).

### Modify Appearance

- **Files**:
  - `dot_config/ghostty/config.tmpl` for structure
  - `.chezmoidata/shared.yaml` for UI values (opacity, padding)
  - `.chezmoidata/themes.yaml` for Catppuccin theme colors
- **Dependencies**: Theme changes affect Neovim, tmux, and shell appearance.
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
