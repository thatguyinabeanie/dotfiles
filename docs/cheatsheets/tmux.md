# ⌨️ Tmux Keybindings Cheat Sheet

> **Prefix**: `C-a` (Control + a)
> Press `q` to close · `j/k` to scroll · `/` to search

---

## 🚀 Essential

| Alias/Key | Action |
|-----------|--------|
| `Prefix + ?` | 🔍 Fuzzy-search this cheat sheet (fzf) |
| `Prefix + M` | 📖 Open this cheat sheet in nvim |
| `Prefix + G` | 📖 Git aliases cheat sheet |
| `Prefix + C` | 📂 All cheat sheets (nvim) |
| `Prefix + r` | 🔄 Reload tmux config |
| `Prefix + :` | 💬 tmux command prompt |
| `Prefix + t` | 👁️ Toggle status bar |
| `C-S-k` | 🧹 Clear terminal (no prefix) |

---

## 📁 Sessions

| Key | Action |
|-----|--------|
| `Prefix + T` | **Sesh** smart session manager (fzf popup) |
| `Prefix + S` | Choose session (native picker) |
| `Prefix + C-s` | Save session (resurrect) |
| `Prefix + C-r` | Restore session (resurrect) |
| `Prefix + C-d` | Detach from session |
| `Prefix + C-x` | Lock tmux server |
| `Prefix + *` | List all clients |

### 🔍 Inside Sesh picker

| Key | Action |
|-----|--------|
| `Enter` | Switch to / create session |
| `C-a` | Show all sessions |
| `C-t` | Show tmux sessions only |
| `C-g` | Show configured sessions |
| `C-x` | Show zoxide directories |
| `C-d` | Kill selected session |
| `Tab` / `Shift-Tab` | Navigate list |

> Sessions auto-save every 15 min and auto-restore on tmux start.

---

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

---

## 📐 Panes — Splits

| Key | Action |
|-----|--------|
| `Prefix + \|` | Vertical split (tmux-pain-control) |
| `Prefix + -` | Horizontal split (tmux-pain-control) |
| `Prefix + \` | Vertical split, current dir |
| `Prefix + _` | Horizontal split, current dir |

---

## 📐 Panes — Navigation

| Key | Action |
|-----|--------|
| `C-h` | Select pane left (works in nvim too) |
| `C-j` | Select pane down |
| `C-k` | Select pane up |
| `C-l` | Select pane right |
| `Prefix + h` | Select pane left (with prefix) |
| `Prefix + j` | Select pane down |
| `Prefix + k` | Select pane up |
| `Prefix + l` | Select pane right |

> `C-h/j/k/l` navigate seamlessly between nvim splits **and** tmux panes.

---

## 📐 Panes — Management

| Key | Action |
|-----|--------|
| `Prefix + z` | Zoom / unzoom pane |
| `Prefix + X` | Kill current pane |
| `Prefix + x` | Swap pane down |
| `Prefix + *` | Toggle pane synchronization |

---

## 📐 Panes — Move & Swap

| Key | Action |
|-----|--------|
| `Prefix + {` | Swap with previous pane |
| `Prefix + }` | Swap with next pane |
| `Prefix + C-o` | Rotate panes forward |
| `Prefix + M-o` | Rotate panes backward |
| `Prefix + !` | Break pane to new window |

---

## 📐 Panes — Resize

| Key | Action |
|-----|--------|
| `Prefix + H` | Resize left (pain-control) |
| `Prefix + J` | Resize down |
| `Prefix + K` | Resize up |
| `Prefix + L` | Resize right |

> Mouse resize also works!

---

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

---

## 🔗 URLs

| Key | Action |
|-----|--------|
| `Prefix + u` | Open URL picker (fzf popup) |

---

## 🔌 Plugin Management (TPM)

| Key | Action |
|-----|--------|
| `Prefix + I` | Install plugins |
| `Prefix + U` | Update plugins |
| `Prefix + Alt+u` | Uninstall removed plugins |

---

## ⚙️ Misc

| Key | Action |
|-----|--------|
| `Prefix + C-l` | Refresh client |
| `C-a C-a` | Send literal `C-a` to app |

---

## 📚 Config Files

```
~/.config/tmux/
├── tmux.conf                    # Main config + plugins
├── tmux.keybindings.conf        # All custom keybindings
├── tmux.cursor.conf             # Cursor shape settings
├── tmux.status.conf             # Status bar
└── tmux.theme.catppuccin.conf   # Catppuccin theme
```
