# Zellij Agent Guide

> **Scope:** This file covers Zellij configuration only.
> For package management, chezmoi workflow, and project-wide rules, see the root `AGENTS.md`.

## Overview

Zellij is a terminal multiplexer (like tmux) that provides tabs, panes, and session management.
In this configuration, it's integrated with WezTerm and uses a tmux-like keybinding scheme.

## Configuration Files

| File         | Location                      | Purpose                          |
| ------------ | ----------------------------- | -------------------------------- |
| `config.kdl` | `~/.config/zellij/config.kdl` | Main configuration (KDL format)  |
| `themes/`    | `~/.config/zellij/themes/`    | Catppuccin themes (auto-fetched) |

## Template Variables Used

- `{{ .CATPPUCCIN_FLAVOR }}` - Theme flavor (mocha, macchiato, frappe, latte)
- `{{ .env_shared.shell_paths.zsh }}` - Default shell path

## Keybinding Reference (Ctrl+a Prefix)

This configuration uses **Ctrl+a** as the prefix key (like tmux), not Zellij's default Ctrl+g.

### Tab Management

| Keybinding    | Action              |
| ------------- | ------------------- |
| `Ctrl+a c`    | Create new tab      |
| `Ctrl+a n`    | Next tab            |
| `Ctrl+a p`    | Previous tab        |
| `Ctrl+a 1-9`  | Go to tab by number |
| `Ctrl+a ,`    | Rename current tab  |
| `Ctrl+a &`    | Close current tab   |

### Pane Management

| Keybinding          | Action                          |
| ------------------- | ------------------------------- |
| `Ctrl+a \|` or `%`  | Split vertically (left/right)   |
| `Ctrl+a -` or `"`   | Split horizontally (top/bottom) |
| `Ctrl+a x`          | Close current pane              |
| `Ctrl+a z`          | Toggle pane zoom (fullscreen)   |
| `Ctrl+a o`          | Cycle through panes             |
| `Ctrl+a h/j/k/l`    | Move focus (vim-style)          |
| `Ctrl+a Space`      | Toggle floating panes           |
| `Ctrl+a f`          | Toggle pane floating/embedded   |

### Resize Mode

| Keybinding    | Action              |
| ------------- | ------------------- |
| `Ctrl+a r`    | Enter resize mode   |
| `h/j/k/l`     | Resize in direction |
| `H/J/K/L`     | Shrink in direction |
| `Esc` or `q`  | Exit resize mode    |

### Session Controls

| Keybinding  | Action              |
| ----------- | ------------------- |
| `Ctrl+a d`  | Detach from session |
| `Ctrl+a s`  | Session manager     |

### Scroll/Copy Mode

| Keybinding    | Action            |
| ------------- | ----------------- |
| `Ctrl+a [`    | Enter scroll mode |
| `j/k`         | Scroll up/down    |
| `Ctrl+d/u`    | Half page down/up |
| `Ctrl+f/b`    | Full page down/up |
| `/`           | Search            |
| `Esc` or `q`  | Exit scroll mode  |

### Quick Actions (No Prefix)

| Keybinding  | Action                       |
| ----------- | ---------------------------- |
| `Alt+h/l`   | Move focus or tab left/right |
| `Alt+j/k`   | Move focus up/down           |
| `Alt+n`     | New pane                     |

### Miscellaneous

| Keybinding        | Action                       |
| ----------------- | ---------------------------- |
| `Ctrl+a Ctrl+a`   | Send literal Ctrl+a to shell |
| `Ctrl+a :`        | Command/search mode          |
| `Esc`             | Return to normal mode        |

## Sessions

### How Sessions Work

- WezTerm auto-launches Zellij with a shared session named "wezterm"
- All WezTerm windows attach to the same Zellij session
- Closing a window doesn't kill the session (tabs/panes persist)
- Session ends when last attached window is closed or detached

### Manual Session Commands

```bash
# List sessions
zellij list-sessions

# Attach to session
zellij attach wezterm

# Create new named session
zellij -s mysession

# Kill a session
zellij kill-session wezterm
```

## Key Features

### Simplified UI

- Pane frames disabled for minimal appearance
- Compact layout used by default
- Rounded corners when frames are shown

### Tmux Compatibility

The keybindings are designed to match tmux muscle memory:

| tmux                | Zellij (this config)        |
| ------------------- | --------------------------- |
| `Ctrl+b` (default)  | `Ctrl+a` (configured)       |
| `Ctrl+b c`          | `Ctrl+a c` (new tab)        |
| `Ctrl+b %`          | `Ctrl+a %` or `\|` (vsplit) |
| `Ctrl+b "`          | `Ctrl+a "` or `-` (hsplit)  |
| `Ctrl+b d`          | `Ctrl+a d` (detach)         |

### Copy on Select

Text is automatically copied to clipboard when selected with mouse.

## Common Customizations

### Change Theme

Edit the template or chezmoi data:

```yaml
# .chezmoidata
CATPPUCCIN_FLAVOR: "macchiato"  # or frappe, latte, mocha
```

### Enable Pane Frames

Edit `config.kdl.tmpl`:

```kdl
pane_frames true
```

### Change Prefix Key

Edit the keybinds section in `config.kdl.tmpl`:

```kdl
normal {
    bind "Ctrl b" { SwitchToMode "Tmux"; }  // Changed from Ctrl+a
}
```

### Add Custom Layout

Create a layout file in `~/.config/zellij/layouts/`:

```kdl
// ~/.config/zellij/layouts/dev.kdl
layout {
    pane split_direction="vertical" {
        pane command="nvim"
        pane split_direction="horizontal" {
            pane
            pane command="lazygit"
        }
    }
}
```

## Troubleshooting

### Zellij won't start

1. Check for KDL syntax errors: `zellij setup --check`
2. Verify config location: `ls -la ~/.config/zellij/config.kdl`
3. Check Zellij version: `zellij --version`

### Theme not loading

1. Verify themes directory exists: `ls ~/.config/zellij/themes/`
2. Check theme name matches: `grep theme ~/.config/zellij/config.kdl`
3. Run chezmoi to fetch themes: `chezmoi apply`

### Keybindings not working

1. Ensure you're pressing Ctrl+a first (prefix)
2. Check for conflicting terminal keybindings
3. Verify config loaded: `zellij setup --check`

### Session issues

1. List active sessions: `zellij list-sessions`
2. Kill stuck session: `zellij kill-session wezterm`
3. Check socket directory: `ls /tmp/zellij-*`

## Validation Checklist

Before committing changes:

- [ ] `chezmoi apply --dry-run` succeeds
- [ ] `zellij setup --check` passes
- [ ] Keybindings work (Ctrl+a c for new tab, etc.)
- [ ] Theme renders correctly
- [ ] Session attach/detach works
- [ ] Pane splitting works

## Related Documentation

- [WezTerm Agent Guide](../wezterm/AGENTS.md)
- [Zellij Official Docs](https://zellij.dev/documentation/)
- [Catppuccin Zellij Theme](https://github.com/catppuccin/zellij)
