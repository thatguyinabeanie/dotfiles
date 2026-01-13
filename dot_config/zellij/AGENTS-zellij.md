# Zellij Configuration

> Terminal multiplexer with tmux-like keybindings

## Quick Start

Zellij auto-launches when you open WezTerm. Use `Ctrl+a` as the prefix key.

## Configuration Files

| File         | Purpose                         |
| ------------ | ------------------------------- |
| `config.kdl` | Main configuration (KDL format) |
| `themes/`    | Catppuccin themes (auto-fetched)|

## Keybindings Cheat Sheet

### Prefix: `Ctrl+a`

All commands below require pressing `Ctrl+a` first.

#### Tabs

| Key   | Action       |
| ----- | ------------ |
| `c`   | New tab      |
| `n`   | Next tab     |
| `p`   | Previous tab |
| `1-9` | Go to tab #  |
| `,`   | Rename tab   |
| `&`   | Close tab    |

#### Panes

| Key          | Action           |
| ------------ | ---------------- |
| `\|` or `%`  | Split vertical   |
| `-` or `"`   | Split horizontal |
| `x`          | Close pane       |
| `z`          | Toggle zoom      |
| `o`          | Cycle panes      |
| `h/j/k/l`    | Move focus       |
| `Space`      | Toggle floating  |

#### Session

| Key | Action          |
| --- | --------------- |
| `d` | Detach          |
| `s` | Session manager |

#### Scroll/Copy

| Key   | Action            |
| ----- | ----------------- |
| `[`   | Enter scroll mode |
| `j/k` | Scroll up/down    |
| `/`   | Search            |
| `Esc` | Exit mode         |

#### Resize

| Key       | Action           |
| --------- | ---------------- |
| `r`       | Enter resize mode|
| `h/j/k/l` | Grow direction   |
| `H/J/K/L` | Shrink direction |

### Quick Actions (No Prefix)

| Key       | Action               |
| --------- | -------------------- |
| `Alt+h/l` | Focus/tab left/right |
| `Alt+j/k` | Focus up/down        |
| `Alt+n`   | New pane             |

### Special

| Key             | Action                |
| --------------- | --------------------- |
| `Ctrl+a Ctrl+a` | Send literal Ctrl+a   |
| `Esc`           | Return to normal mode |

## Session Commands

```bash
# List sessions
zellij list-sessions

# Attach to session
zellij attach wezterm

# Kill session
zellij kill-session wezterm
```

## Features

- **Shared session**: All WezTerm windows share "wezterm" session
- **Simplified UI**: No pane frames, minimal status bar
- **Copy on select**: Mouse selection → clipboard
- **Mouse support**: Click to focus, scroll, resize
- **Catppuccin theme**: Matches your flavor setting

## Template Variables

- `.CATPPUCCIN_FLAVOR` - Theme (mocha, macchiato, frappe, latte)
- `.env_shared.shell_paths.zsh` - Default shell

## Troubleshooting

### Check configuration

```bash
zellij setup --check
```

### List sessions

```bash
zellij list-sessions
```

### Kill stuck session

```bash
zellij kill-session wezterm
```

## Related

- [WezTerm inline docs](../wezterm/AGENTS-wezterm.md)
- [Full Zellij docs](https://zellij.dev/documentation/)
- [Agent guide](../../.docs/agent/ZELLIJ_AGENT.md)
