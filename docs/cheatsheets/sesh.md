# sesh

**Smart tmux session manager**—create and switch tmux sessions with zoxide integration.

## 🚀 Core Commands

| Command | Action |
|---------|--------|
| `sesh list` | List all sessions (tmux + config + zoxide) |
| `sesh connect SESSION` | Create or connect to a session |
| `sesh connect --switch SESSION` | Connect and switch to session |
| `sesh root` | Get root of current git project |
| `sesh last` | Switch to second-most-recent session |
| `sesh preview SESSION` | Preview session contents |

## 🪟 Window Commands

| Command | Action |
|---------|--------|
| `sesh window` | List windows in current session |
| `sesh window WINDOW_NAME` | Switch to or create window |
| `sesh window ~/path` | Create window at directory |
| `sesh window -s SESSION` | Target a specific session |

## 📋 List Flags

| Flag | Description |
|------|-------------|
| `-t` / `--tmux` | Show only active tmux sessions |
| `-c` / `--config` | Show only configured sessions |
| `-z` / `--zoxide` | Show only zoxide directories |
| `-i` / `--icons` | Display Nerd Font icons |
| `-H` / `--no-header` | Hide header line |
| `-d` / `--dir` | Show directory paths |
| `-T` | Show session type |

## 🔗 Connect Flags

| Flag | Description |
|------|-------------|
| `--switch` / `-s` | Switch to session (for nested tmux) |
| `--root` | Connect to root of git worktree |
| `--command` / `-c` | Run command instead of startup script |
| `--clone URL` | Clone repo and connect |

## 🖥️ Tmux Integration

| Keybind | Action |
|---------|--------|
| `Prefix + t` | Open sesh session picker (television) |

### Inside the sesh picker

| Key | Action |
|-----|--------|
| `Enter` | Connect to / create session |
| `Ctrl + d` | Kill selected session + reload list |
| `j` / `k` | Navigate up / down |
| `/` | Search |
| `Ctrl + O` | Toggle preview panel |
| `Ctrl + S` | Cycle sources |
