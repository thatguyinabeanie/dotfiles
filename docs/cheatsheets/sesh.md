# Sesh Cheatsheet

**Smart tmux session manager**—create and manage tmux sessions quickly with zoxide integration.

## Basic Usage

| Command | Description |
|---------|-------------|
| `sesh list` | List all sessions (tmux, config, zoxide) |
| `sesh connect SESSION` | Create or connect to session |
| `sesh connect --switch SESSION` | Connect and switch to session |
| `sesh root` | Get root of current git project |
| `sesh last` | Switch to second-most-recent session |

## Session Types

| Type | Source | Example |
|------|--------|---------|
| `tmux` | Active tmux sessions | `myproject` |
| `config` | Configured in `sesh.toml` | `Downloads 📥` |
| `zoxide` | Frequently visited directories | `~/projects/app` |

## Integration with fzf

### Basic fzf picker

```bash
sesh connect $(sesh list | fzf)
```

### With fzf-tmux (in tmux)

```bash
sesh connect $(sesh list -t -c -z | fzf-tmux -p 80%,70%)
```

### Advanced tmux keybind

```bash
bind-key "T" run-shell "sesh connect \\"$(
  sesh list --icons | fzf-tmux -p 80%,70% \\
    --no-sort --ansi --border-label ' sesh ' --prompt '⚡  ' \\
    --header '  ^a all ^t tmux ^g configs ^x zoxide ^d kill' \\
    --bind 'ctrl-a:reload(sesh list --icons)' \\
    --bind 'ctrl-t:reload(sesh list -t --icons)' \\
    --bind 'ctrl-g:reload(sesh list -c --icons)' \\
    --bind 'ctrl-x:reload(sesh list -z --icons)' \\
    --preview 'sesh preview {}'
)\\""
```

## Television Integration

### Simple picker

```bash
bind-key "T" display-popup -E -w 80% -h 70% tv sesh
```

## List Options

| Flag | Description |
|------|-------------|
| `-t` / `--tmux` | Show only tmux sessions |
| `-c` / `--config` | Show only configured sessions |
| `-z` / `--zoxide` | Show only zoxide directories |
| `-i` / `--icons` | Display Nerd Font icons |
| `-H` / `--no-header` | Hide header line |
| `-d` / `--dir` | Show directory paths |
| `-T` | Show session type |

## Connect Options

| Flag | Description |
|------|-------------|
| `--switch` / `-s` | Switch to session (useful for nested tmux) |
| `--root` | Connect to root of git worktree |
| `--command` / `-c` | Run command instead of startup script |

## Configuration (sesh.toml)

### Basic setup

```toml
# ~/.config/sesh/sesh.toml

blacklist = ["scratch", "temp"]
dir_length = 2  # Use last 2 directories in session names

[[session]]
name = "Downloads 📥"
path = "~/Downloads"
startup_command = "ls"

[[wildcard]]
pattern = "~/projects/*"
startup_command = "nvim"
```

### Multiple windows

```toml
[[session]]
name = "dev"
path = "~/projects/myapp"
windows = ["editor", "server", "git"]

[[window]]
name = "editor"
startup_script = "nvim"

[[window]]
name = "server"
startup_script = "npm run dev"
```

### Wildcard patterns

```toml
[[wildcard]]
pattern = "~/projects/*"
startup_command = "nvim"
preview_command = "ls -la {}"

[[wildcard]]
pattern = "~/repos/**"  # Matches nested directories
startup_command = "git status"
```

## Window Management

| Command | Description |
|---------|-------------|
| `sesh window` | List windows in current session |
| `sesh window WINDOW_NAME` | Switch to or create window |
| `sesh window ~/path` | Create window at directory |
| `sesh window -s SESSION` | Target specific session |

### With fzf

```bash
sesh window $(sesh window | fzf)
```

## Tips & Tricks

### Auto-start dev server

```toml
[default_session]
startup_command = "npm run dev"
preview_command = "eza --all --git --icons {}"
```

### Kill session from picker

In your fzf keybind, use:

```bash
--bind 'ctrl-d:execute(tmux kill-session -t {2..})'
```

### Clone and connect

```bash
sesh connect --clone https://github.com/user/repo
```

### Last session switching

```bash
bind-key "L" run-shell "sesh last"
```

### Preview command

See directory contents in picker:

```bash
sesh list --icons | fzf --preview 'sesh preview {}'
```

## Recommended tmux Settings

```bash
# ~/.config/tmux/tmux.conf
bind x kill-pane
set -g detach-on-destroy off  # Don't exit tmux when closing session
```

## Integration with Zosh/Fish

### Zsh keybind

```bash
function sesh-sessions() {
  exec </dev/tty
  sesh connect $(sesh list | fzf)
}
zle -N sesh-sessions
bindkey '\es' sesh-sessions  # Alt+S
```
