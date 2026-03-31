# tmux

**Terminal multiplexer**—manage multiple terminal sessions in one window. Prefix: `C-a`

## 🚀 Essential

| Key | Action |
|-----|--------|
| `Prefix + ?` | Fuzzy-search this cheat sheet (fzf) |
| `Prefix + M` | Tmux keybindings cheat sheet (nvim) |
| `Prefix + G` | Git aliases cheat sheet (nvim) |
| `Prefix + C` | All cheat sheets directory (nvim) |
| `Prefix + r` | Reload tmux config |
| `Prefix + :` | tmux command prompt |
| `Prefix + T` | Toggle status bar |
| `C-S-k` | Clear terminal (no prefix) |

## 📁 Sessions

| Key | Action |
|-----|--------|
| `Prefix + t` | Open sesh session picker (television) |
| `Prefix + S` | Choose session (native picker) |
| `Prefix + C-s` | Save session (resurrect) |
| `Prefix + C-r` | Restore session (resurrect) |
| `Prefix + C-d` | Detach from session |
| `Prefix + C-x` | Lock tmux server |
| `Prefix + *` | List all clients |

### 🔍 Inside the sesh picker

| Key | Action |
|-----|--------|
| `Enter` | Connect to / create session |
| `Ctrl + d` | Kill selected session + reload list |
| `j` / `k` | Navigate up / down |
| `/` | Search |
| `Ctrl + O` | Toggle preview panel |
| `Ctrl + S` | Cycle sources |

## 🪟 Windows

| Key | Action |
|-----|--------|
| `Prefix + c` | New window (home dir) |
| `Prefix + C-d` | New window (chezmoi dir) |
| `Prefix + C-e` | New window (chezmoi dir + nvim) |
| `Prefix + w` | List windows |
| `Prefix + C-w` | List all windows |
| `Prefix + "` | Choose window interactively |
| `Prefix + C-a` | Switch to last window |
| `Prefix + R` | Rename current window |
| `C-S-p` | Move window left (no prefix) |
| `C-S-n` | Move window right (no prefix) |

## 📐 Panes—Splits

| Key | Action |
|-----|--------|
| `Prefix + \|` | Vertical split |
| `Prefix + -` | Horizontal split |
| `Prefix + \` | Vertical split (current dir) |
| `Prefix + _` | Horizontal split (current dir) |

## 📐 Panes—Navigation

| Key | Action |
|-----|--------|
| `C-h` | Select pane left (works in nvim too) |
| `C-j` | Select pane down |
| `C-k` | Select pane up |
| `C-l` | Select pane right |
| `Prefix + h` | Select pane left |
| `Prefix + j` | Select pane down |
| `Prefix + k` | Select pane up |
| `Prefix + l` | Select pane right |

## 📐 Panes—Management

| Key | Action |
|-----|--------|
| `Prefix + z` | Zoom / unzoom pane |
| `Prefix + X` | Kill current pane |
| `Prefix + x` | Swap pane down |
| `Prefix + *` | Toggle pane synchronization |

## 📐 Panes—Move & Swap

| Key | Action |
|-----|--------|
| `Prefix + {` | Swap current pane with the one before it |
| `Prefix + }` | Swap current pane with the one after it |
| `Prefix + C-o` | Rotate all panes forward (cycle positions) |
| `Prefix + M-o` | Rotate all panes backward |
| `Prefix + !` | Break current pane out into its own window |
| `Prefix + :join-pane -t :N` | Move current pane into window N |
| `Prefix + :join-pane -s :N.P` | Pull pane P from window N into current window |
| `Prefix + :swap-pane -s N -t M` | Swap pane N with pane M (by index) |
| Mouse drag | Drag pane border to resize (mouse mode is on) |

## 📐 Panes—Resize

| Key | Action |
|-----|--------|
| `Prefix + H` | Resize left |
| `Prefix + J` | Resize down |
| `Prefix + K` | Resize up |
| `Prefix + L` | Resize right |

## 📋 Copy Mode (vi-style)

| Key | Action |
|-----|--------|
| `Prefix + [` | Enter copy mode |
| `v` | Start selection |
| `C-v` | Rectangle selection |
| `y` | Copy selection and exit |
| `/` | Search forward |
| `?` | Search backward |
| `h/j/k/l` | Navigate |
| `q` | Exit copy mode |

## 🔗 URLs & Plugins

| Key | Action |
|-----|--------|
| `Prefix + u` | Open URL picker (fzf popup) |
| `Prefix + I` | Install plugins (TPM) |
| `Prefix + U` | Update plugins (TPM) |
| `Prefix + Alt+u` | Uninstall removed plugins (TPM) |

## ⚙️ Misc

| Key | Action |
|-----|--------|
| `Prefix + C-l` | Refresh client |
| `C-a C-a` | Send literal `C-a` to app |
