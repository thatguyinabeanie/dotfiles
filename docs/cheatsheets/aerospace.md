# Aerospace Cheatsheet

**macOS tiling window manager**—automatic window layout management inspired by i3.

## Configuration

Aerospace configuration lives at `~/.config/aerospace/aerospace.toml`. The dotfiles source is at `dot_config/aerospace/aerospace.toml.tmpl`.

## Workspaces

| Command | Description |
|---------|-------------|
| `alt + 1-9` | Switch to workspace 1-9 |
| `alt + shift + 1-9` | Move window to workspace 1-9 |
| `alt + tab` | Switch to last workspace |
| `alt + a` | Switch to next workspace |
| `alt + z` | Switch to previous workspace |

## Window Navigation

| Command | Description |
|---------|-------------|
| `alt + h` / `alt + ←` | Focus left window |
| `alt + j` / `alt + ↓` | Focus down window |
| `alt + k` / `alt + ↑` | Focus up window |
| `alt + l` / `alt + →` | Focus right window |
| `alt + tab` | Focus most recent window |

## Window Movement

| Command | Description |
|---------|-------------|
| `alt + shift + h` / `alt + shift + ←` | Move window left |
| `alt + shift + j` / `alt + shift + ↓` | Move window down |
| `alt + shift + k` / `alt + shift + ↑` | Move window up |
| `alt + shift + l` / `alt + shift + →` | Move window right |

## Window Resizing

| Command | Description |
|---------|-------------|
| `alt + ctrl + h` | Decrease width |
| `alt + ctrl + j` | Increase height |
| `alt + ctrl + k` | Decrease height |
| `alt + ctrl + l` | Increase width |
| `alt + ctrl + =` | Balance all windows |
| `alt + -` | Enter resize mode |

## Layout Management

| Command | Description |
|---------|-------------|
| `alt + s` | Cycle to next layout |
| `alt + shift + s` | Cycle to previous layout |
| `alt + w` | Toggle between tiling and floating |
| `alt + t` | Toggle floating/tiling for focused window |

### Available Layouts

- **Tiling** (default i3-like behavior)
- **Floating** (free positioning)
- **Accordion** (stacked vertical/horizontal)

## Window Actions

| Command | Description |
|---------|-------------|
| `alt + q` | Close window |
| `alt + f` | Maximize window |
| `alt + shift + f` | Toggle fullscreen |
| `alt + m` | Toggle minimize |

## Application Launching

Common apps are bound in config. Check `aerospace.toml` for your setup:

| Command | App |
|---------|-----|
| `alt + return` | Terminal (Ghostty/WezTerm) |
| `alt + space` | Application launcher (Raycast) |
| `alt + b` | Browser |
| `alt + e` | Editor (Neovim in terminal) |

## CLI Commands

| Command | Description |
|---------|-------------|
| `aerospace workspace-back-and-forth` | Toggle last workspace |
| `aerospace move-node-to-workspace 2` | Move focused window to workspace 2 |
| `aerospace focus left` | Focus left window |
| `aerospace layout tiling` | Switch to tiling layout |

## Tips

- **i3-like workflow**: Aerospace mirrors i3 keybindings (Alt instead of Super)
- **Hyper key**: Consider remapping Caps Lock to Hyper (Cmd+Shift+Ctrl+Option) for extended bindings
- **Workspaces per monitor**: Each monitor has independent workspaces
- **Terminal integration**: Works seamlessly with tmux/zellij for multiplexing
- **App profiles**: Pin apps to specific workspaces in config

## Configuration Structure

```toml
# ~/.config/aerospace/aerospace.toml

[[on-window-detected]]
if = { app-id = "com.github.ghcli.app" }
run = "move-node-to-workspace 2"

[mode.main.binding]
alt-h = "focus left"
alt-j = "focus down"
alt-enter = "exec-and-forget open -a Terminal"
```

## Debugging

| Command | Description |
|---------|-------------|
| `aerospace list-windows` | List all windows |
| `aerospace list-workspaces` | List workspaces |
| `aerospace debug-window-at 0 0` | Debug specific coordinates |

## Integration with Terminal Multiplexers

### With tmux

Aerospace handles window management, tmux handles panes within terminal window:

- Alt+h/j/k/l: Switch between Aerospace windows
- Prefix+h/j/k/l: Switch between tmux panes

### With Zellij

Similar workflow:

- Alt+h/j/k/l: Switch Aerospace windows
- Alt+p + hjkl: Switch Zellij panes

## Common Workflows

### Efficient coding setup

1. Alt+1 → Workspace 1 (editor)
2. Alt+2 → Workspace 2 (terminal/server)
3. Alt+3 → Workspace 3 (browser/docs)
4. Alt+h/j/k/l → Navigate within workspace
5. Alt+shift+h/j/k/l → Resize as needed

### Quick window focus

```bash
# From shell
aerospace focus left
aerospace focus last
```
