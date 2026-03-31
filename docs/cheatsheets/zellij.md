# Zellij

**Terminal multiplexer**—modern, user-friendly alternative to tmux with intuitive keybindings.

## 🚀 CLI Commands

| Command | Action |
|---------|--------|
| `zellij` | Start a new session |
| `zellij -s NAME` | Start named session |
| `zellij attach NAME` | Attach to existing session |
| `zellij list-sessions` | List all sessions |
| `zellij kill-session NAME` | Kill a session |
| `zellij --layout NAME` | Start with a saved layout |

## 🎮 Mode Keys (Ctrl+G prefix)

| Binding | Action |
|---------|--------|
| `Ctrl + G` | Enter command mode |
| `Ctrl + G + ?` | Show keybindings |
| `Ctrl + G + d` | Detach from session |
| `Ctrl + G + q` | Quit zellij |

## 🔲 Pane Management

| Binding | Action |
|---------|--------|
| `Ctrl + G + n` | New pane |
| `Ctrl + G + x` | Close focused pane |
| `Ctrl + G + z` | Toggle fullscreen pane |
| `Ctrl + G + \|` | Split pane vertically |
| `Ctrl + G + -` | Split pane horizontally |
| `Ctrl + G + f` | Toggle floating pane |
| `Alt + ↑/↓/←/→` | Navigate between panes (no prefix) |

## 🗂️ Tab Management

| Binding | Action |
|---------|--------|
| `Ctrl + G + t` | New tab |
| `Ctrl + G + w` | Close tab |
| `Ctrl + G + 1-9` | Switch to tab 1–9 |
| `Ctrl + G + ]` | Next tab |
| `Ctrl + G + [` | Previous tab |
| `Ctrl + G + r` | Rename tab |

## 📋 Scroll & Copy Mode

| Binding | Action |
|---------|--------|
| `Ctrl + G + s` | Enter scroll mode |
| `Ctrl + G + c` | Enter copy mode |
| `Space` | Start selection (in copy mode) |
| `Enter` | Copy selection (in copy mode) |
| `q` | Exit copy mode |

## 🔲 Layout & Resize

| Binding | Action |
|---------|--------|
| `Ctrl + G + l` | Cycle layouts |
| `Ctrl + G + Ctrl + R` | Enter resize mode |
| Arrow keys | Resize pane (in resize mode) |
| `Esc` | Exit resize mode |
