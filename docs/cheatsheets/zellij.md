# Zellij Cheatsheet

**Terminal multiplexer**—modern, user-friendly alternative to tmux with intuitive keybindings.

## Basics

| Command | Description |
|---------|-------------|
| `zellij` | Start new zellij session |
| `zellij attach SESSION_NAME` | Attach to existing session |
| `zellij list-sessions` | List all sessions |
| `zellij kill-session SESSION_NAME` | Kill a session |

## Default Keybindings

Zellij uses **Ctrl+G** (configurable) as the default mode key (like tmux prefix).

| Binding | Action |
|---------|--------|
| `Ctrl+G` | Enter command mode |
| `Ctrl+G + ?` | Show keybindings |
| `Ctrl+G + d` | Detach from session |
| `Ctrl+G + q` | Quit zellij |

## Pane Management

| Binding | Action |
|---------|--------|
| `Ctrl+G + p` | Toggle pane focus mode |
| `Ctrl+G + n` | New pane |
| `Ctrl+G + x` | Close focused pane |
| `Alt + ↑/↓/←/→` | Navigate between panes |
| `Ctrl+G + z` | Toggle fullscreen pane |
| `Ctrl+G + \|` | Split pane vertically |
| `Ctrl+G + -` | Split pane horizontally |

## Tab Management

| Binding | Action |
|---------|--------|
| `Ctrl+G + t` | New tab |
| `Ctrl+G + w` | Close tab |
| `Ctrl+G + 1-9` | Switch to tab 1-9 |
| `Ctrl+G + ]` | Next tab |
| `Ctrl+G + [` | Previous tab |
| `Ctrl+G + r` | Rename tab |

## Mode Commands

### Pane Mode

```text
Ctrl+G + p  # Enter pane mode
Then use:
- Arrow keys to navigate
- Enter to focus selected pane
- x to close pane
- f to fullscreen
- s to split
- q to exit mode
```

### Tab Mode

```text
Ctrl+G + Tab  # Enter tab mode
Then use:
- Left/Right to navigate tabs
- Enter to focus
- n for new tab
- x to close
- r to rename
```

### Resize Mode

```text
Ctrl+G + Ctrl+R  # Enter resize mode
Then use:
- Arrow keys to resize
- Esc to exit
```

## Scrollback & Copy

| Binding | Action |
|---------|--------|
| `Ctrl+G + s` | Enter scroll mode |
| `Ctrl+G + c` | Enter copy mode |
| In copy mode: | |
| `Space` | Start selection |
| `Enter` | Copy selection |
| `q` | Exit copy mode |

## Layout Management

### Layout Types

- **Tiled** (default, automatic layout)
- **Floating** (free positioning)
- **Stacked** (one visible at a time)

| Binding | Action |
|---------|--------|
| `Ctrl+G + l` | Cycle layouts |
| `Ctrl+G + f` | Toggle floating pane |

## Session Management

### Create named session

```bash
zellij -s myproject
```

### Attach to session

```bash
zellij attach myproject
```

### List sessions

```bash
zellij list-sessions
```

### Kill session

```bash
zellij kill-session myproject
```

## Configuration

Zellij config is at `~/.config/zellij/config.kdl` (KDL format, not TOML).

### Basic config structure

```kdl
// ~/.config/zellij/config.kdl

theme "dracula"
keybinds {
  normal {
    bind "Alt h" { MoveFocusOrTab "Left"; }
    bind "Alt j" { MoveFocus "Down"; }
    bind "Alt k" { MoveFocus "Up"; }
    bind "Alt l" { MoveFocusOrTab "Right"; }
  }
}
```

## Layouts

Zellij can save layouts for quick session setup:

```bash
zellij --layout workspace
```

### Create custom layout

Layouts are defined in KDL format at `~/.config/zellij/layouts/`.

## Integration with Tools

### With sesh (tmux alternative)

Since Zellij is tmux-compatible, sesh works with it:

```bash
sesh list
sesh connect SESSION
```

### With fzf session picker

```bash
zellij attach $(zellij list-sessions | fzf)
```

## UI Features

- **Floating panes**: Press Ctrl+G then f to toggle floating
- **Compact UI**: Clean status bar and tab bar
- **Search**: Ctrl+G then / to search pane contents
- **Mouse support**: Click to navigate (in most terminals)

## Tips

- **Intuitive defaults**: Keybindings are more discoverable than tmux
- **No prefix key needed**: Alt+arrows for navigation without prefix
- **KDL config**: More human-readable than tmux.conf
- **Plugins available**: Zellij has an ecosystem of plugins
- **Built-in UI**: Status bar and tabs are integrated, not scripted

## Comparison with Tmux

| Feature | Zellij | Tmux |
|---------|--------|------|
| **Learning curve** | Gentler | Steeper |
| **Keybindings** | Intuitive defaults | Customizable but complex |
| **Config format** | KDL (readable) | bash (flexible) |
| **Built-in UI** | Yes | Requires plugins |
| **Plugin ecosystem** | Growing | Mature |
| **Mouse support** | Better | Basic |

## Common Workflows

### Start dev session with multiple panes

```bash
zellij -s dev
Ctrl+G p    # Pane mode
s           # Split
↓           # Go down
s           # Split again
# Now you have 3 panes for editor, server, git
```

### Detach and reattach

```bash
Ctrl+G d              # Detach
zellij attach dev     # Reattach later
```

### Switch between layouts

```bash
Ctrl+G l  # Cycle through available layouts
```
