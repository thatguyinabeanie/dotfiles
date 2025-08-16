# Tmux Keybindings Reference

This document provides a comprehensive overview of all tmux keybindings configured in this dotfiles repository, cross-referenced with the actual tmux configuration.

## Configuration Files

- **Main Config**: `dot_config/tmux/tmux.conf`
- **Keybindings**: `dot_config/tmux/tmux.keybindings.conf`
- **Status Bar**: `dot_config/tmux/tmux.status.conf`
- **Theme**: `dot_config/tmux/tmux.theme.catppuccin.conf.tmpl`
- **Symlink**: `symlink_dot_tmux.conf.tmpl` → `~/.tmux.conf`

## Prefix Key

**Default Prefix**: `Ctrl-a` (changed from default `Ctrl-b`)

## Essential Keybindings

### Session Management

| Key | Action | Description |
|-----|--------|-------------|
| `Prefix + S` | `choose-session` | Choose session interactively |
| `Prefix + Ctrl-d` | `detach-client` | Detach from current session |
| `Prefix + $` | `rename-session` | Rename current session |
| `Prefix + d` | `detach-client` | Detach from session |

### Window Management

| Key | Action | Description |
|-----|--------|-------------|
| `Prefix + c` | `new-window -c ~/` | Create new window (home directory) |
| `Prefix + Ctrl-d` | `new-window -c ~/.local/share/chezmoi` | New window at chezmoi directory |
| `Prefix + Ctrl-e` | `new-window -c ~/.local/share/chezmoi + nvim` | New window at chezmoi + open nvim |
| `Prefix + "` | `choose-window` | Choose window interactively |
| `Prefix + w` | `list-windows` | List all windows |
| `Prefix + Ctrl-w` | `list-windows` | List all windows |
| `Prefix + n` | `next-window` | Go to next window |
| `Prefix + p` | `previous-window` | Go to previous window |
| `Prefix + Ctrl-n` | `next-window` | Go to next window |
| `Prefix + Ctrl-p` | `previous-window` | Go to previous window |
| `Prefix + a` | `last-window` | Switch to last window |
| `Prefix + Ctrl-a` | `last-window` | Switch to last window |
| `Prefix + 0-9` | `select-window -t :=N` | Select window by number |
| `Prefix + R` | `rename-window` | Rename current window |
| `Prefix + &` | `kill-window` | Kill current window |
| `Prefix + ,` | `rename-window` | Rename current window |

### Window Navigation (Global - No Prefix)

| Key | Action | Description |
|-----|--------|-------------|
| `Ctrl-Shift-p` | `swap-window -t -1; select-window -t -1` | Move window left |
| `Ctrl-Shift-n` | `swap-window -t +1; select-window -t +1` | Move window right |

### Pane Management

#### Pane Creation

| Key | Action | Description |
|-----|--------|-------------|
| `Prefix + v` | `split-window -h -c "#{pane_current_path}"` | Vertical split (current dir) |
| `Prefix + \|` | `split-window -h -c "#{pane_current_path}"` | Vertical split (current dir) |
| `Prefix + -` | `split-window -v -c "#{pane_current_path}"` | Horizontal split (current dir) |
| `Prefix + s` | `split-window -v -c "#{pane_current_path}"` | Horizontal split (current dir) |
| `Prefix + %` | `split-window -h -c "#{pane_current_path}"` | Vertical split (default) |
| `Prefix + "` | `split-window -v -c "#{pane_current_path}"` | Horizontal split (default) |
| `Prefix + \\` | `split-window -fh -c "#{pane_current_path}"` | Full-width vertical split |
| `Prefix + _` | `split-window -fv -c "#{pane_current_path}"` | Full-height horizontal split |

#### Pane Navigation

| Key | Action | Description |
|-----|--------|-------------|
| `Prefix + h` | `select-pane -L` | Select left pane |
| `Prefix + j` | `select-pane -D` | Select down pane |
| `Prefix + k` | `select-pane -U` | Select up pane |
| `Prefix + l` | `select-pane -R` | Select right pane |
| `Prefix + ;` | `last-pane` | Switch to last pane |
| `Prefix + o` | `select-pane -t :.+` | Select next pane |
| `Prefix + Up/Down/Left/Right` | `select-pane -U/-D/-L/-R` | Select pane by direction |

#### Vim-Tmux Navigator (Global - No Prefix)

| Key | Action | Description |
|-----|--------|-------------|
| `Ctrl-h` | Smart left navigation | Navigate left (vim-aware) |
| `Ctrl-j` | Smart down navigation | Navigate down (vim-aware) |
| `Ctrl-k` | Smart up navigation | Navigate up (vim-aware) |
| `Ctrl-l` | Smart right navigation | Navigate right (vim-aware) |
| `Ctrl-\` | Smart last navigation | Go to last pane (vim-aware) |

#### Pane Resizing

| Key | Action | Description |
|-----|--------|-------------|
| `Prefix + z` | `resize-pane -Z` | Toggle pane zoom |
| `Prefix + ,` | `resize-pane -L 20` | Resize left by 20 units |
| `Prefix + .` | `resize-pane -R 20` | Resize right by 20 units |
| `Prefix + =` | `resize-pane -U 7` | Resize up by 7 units |
| `Prefix + H` | `resize-pane -L 5` | Resize left by 5 units |
| `Prefix + J` | `resize-pane -D 5` | Resize down by 5 units |
| `Prefix + K` | `resize-pane -U 5` | Resize up by 5 units |
| `Prefix + L` | `resize-pane -R 5` | Resize right by 5 units |
| `Prefix + Ctrl-Up/Down/Left/Right` | `resize-pane` | Resize by direction |
| `Prefix + Alt-Up/Down/Left/Right` | `resize-pane -[UDLR] 5` | Resize by direction (5 units) |

#### Pane Actions

| Key | Action | Description |
|-----|--------|-------------|
| `Prefix + X` | `kill-pane` | Kill current pane |
| `Prefix + x` | `swap-pane -D` | Swap pane down |
| `Prefix + {` | `swap-pane -U` | Swap pane up |
| `Prefix + }` | `swap-pane -D` | Swap pane down |
| `Prefix + !` | `break-pane` | Break pane into new window |
| `Prefix + m` | `select-pane -m` | Mark current pane |
| `Prefix + M` | `select-pane -M` | Clear marked pane |
| `Prefix + q` | `display-panes` | Display pane numbers |

### Copy Mode

#### Entering Copy Mode

| Key | Action | Description |
|-----|--------|-------------|
| `Prefix + [` | `copy-mode` | Enter copy mode |
| `Prefix + PgUp` | `copy-mode -u` | Enter copy mode and scroll up |

#### Copy Mode Navigation (Vi-style)

| Key | Action | Description |
|-----|--------|-------------|
| `h/j/k/l` | Cursor movement | Left/Down/Up/Right |
| `w/b` | Word movement | Next word/Previous word |
| `e` | `next-word-end` | End of word |
| `W/B/E` | WORD movement | Next/Previous/End WORD |
| `0/^/$` | Line movement | Start/First char/End of line |
| `g/G` | Buffer movement | Top/Bottom of buffer |
| `H/M/L` | Screen movement | Top/Middle/Bottom of screen |
| `Ctrl-f/Ctrl-b` | Page movement | Page down/Page up |
| `Ctrl-d/Ctrl-u` | Half-page movement | Half page down/up |
| `Ctrl-e/Ctrl-y` | Scroll | Scroll down/up |

#### Copy Mode Selection

| Key | Action | Description |
|-----|--------|-------------|
| `v` | `begin-selection` | Start selection |
| `V` | `select-line` | Select entire line |
| `Ctrl-v` | `rectangle-toggle` | Toggle rectangle selection |
| `y` | `copy-selection-and-cancel` | Copy selection and exit |
| `Enter` | `copy-selection-and-cancel` | Copy selection and exit |

#### Copy Mode Search

| Key | Action | Description |
|-----|--------|-------------|
| `/` | `search-forward` | Search forward |
| `?` | `search-backward` | Search backward |
| `n` | `search-again` | Next search result |
| `N` | `search-reverse` | Previous search result |

#### Copy Mode Custom Bindings

| Key | Action | Description |
|-----|--------|-------------|
| `o` | Open file/URL | Copy selection and open with system default |
| `Ctrl-o` | Open in nvim | Copy selection and open in nvim |
| `!` | Copy to clipboard (no newline) | Copy without trailing newline |
| `Y` | Copy and paste | Copy selection and paste immediately |

### Plugin-Specific Keybindings

#### SessionX (Fuzzy Session Manager)

| Key | Action | Description |
|-----|--------|-------------|
| `Prefix + o` | Launch SessionX | Open fuzzy session manager |

**SessionX Internal Controls:**
- `Enter`: Switch to session or create new
- `Alt-Backspace`: Delete selected session
- `Ctrl-u/Ctrl-d`: Scroll preview up/down
- `Ctrl-n/Ctrl-p`: Select next/previous item
- `Ctrl-r`: Rename session
- `Ctrl-w`: Window mode (show all windows)
- `Ctrl-x`: Search in ~/.local/share/chezmoi
- `Ctrl-e`: Expand PWD for local directories
- `Ctrl-b`: Back to main session list
- `Ctrl-t`: Tree mode (hierarchical view)
- `?`: Toggle preview pane

#### FZF URL

| Key | Action | Description |
|-----|--------|-------------|
| `Prefix + u` | `fzf-url` | Open URLs from pane in FZF |

#### Tmux Yank

| Key | Action | Description |
|-----|--------|-------------|
| `Prefix + y` | Copy line | Copy current line |
| `Prefix + Y` | Copy PWD | Copy current working directory |

#### Tmux Logging

| Key | Action | Description |
|-----|--------|-------------|
| `Prefix + P` | Toggle logging | Start/stop logging current pane |
| `Prefix + Alt-p` | Screen capture | Save visible text to file |
| `Prefix + Alt-P` | Save complete history | Save complete pane history |
| `Prefix + Alt-c` | Clear history | Clear pane history |

### Layouts

| Key | Action | Description |
|-----|--------|-------------|
| `Prefix + Space` | `next-layout` | Cycle through layouts |
| `Prefix + Alt-1` | `even-horizontal` | Even horizontal layout |
| `Prefix + Alt-2` | `even-vertical` | Even vertical layout |
| `Prefix + Alt-3` | `main-horizontal` | Main horizontal layout |
| `Prefix + Alt-4` | `main-vertical` | Main vertical layout |
| `Prefix + Alt-5` | `tiled` | Tiled layout |

### Miscellaneous

| Key | Action | Description |
|-----|--------|-------------|
| `Prefix + ?` | `list-keys -N` | Show all key bindings |
| `Prefix + :` | `command-prompt` | Enter tmux command |
| `Prefix + i` | `display-message` | Display session info |
| `Prefix + t` | `set-option status` | Toggle status bar |
| `Prefix + ~` | `show-messages` | Show tmux messages |
| `Prefix + r` | Reload config | Reload tmux configuration |
| `Prefix + Ctrl-l` | `refresh-client` | Refresh tmux client |
| `Prefix + Ctrl-x` | `lock-server` | Lock tmux server |
| `Prefix + *` | `synchronize-panes` | Toggle pane synchronization |

### Global Keybindings (No Prefix Required)

| Key | Action | Description |
|-----|--------|-------------|
| `Ctrl-Shift-k` | Clear terminal | Send clear command and enter |
| `Ctrl-Shift-p` | Move window left | Swap window left and select it |
| `Ctrl-Shift-n` | Move window right | Swap window right and select it |

## Mouse Support

Mouse support is enabled with the following features:

- **Click to select pane**: Click on any pane to select it
- **Drag to resize**: Drag pane borders to resize
- **Scroll wheel**: Scroll up/down in panes (enters copy mode automatically)
- **Right-click menus**: Context menus for panes, windows, and status bar
- **Double-click**: Select word in copy mode
- **Triple-click**: Select line in copy mode
- **Drag selection**: Start selection and copy in copy mode

## Status Bar

- **Position**: Top of screen
- **Default state**: Hidden (toggle with `Prefix + t`)
- **Theme**: Catppuccin with custom configuration
- **Content**: Session name, window list, date/time

## Color and Terminal Support

- **Default terminal**: `tmux-256color`
- **True color support**: Enabled for RGB colors
- **Undercurl support**: Enabled for modern terminal features
- **Clipboard integration**: Enabled with `reattach-to-user-namespace` on macOS

## Plugin Configuration

### Installed Plugins

1. **TPM** (Tmux Plugin Manager) - Base plugin manager
2. **SessionX** - Advanced session manager with fuzzy finding
3. **vim-tmux-navigator** - Seamless navigation between vim and tmux panes
4. **tmux-which-key** - Key binding help system
5. **tmux-fzf-url** - Open URLs from terminal output
6. **tmux-open** - Open highlighted text with system applications
7. **tmux-sensible** - Sensible defaults for tmux
8. **tmux-yank** - Copy to system clipboard
9. **tmux-pain-control** - Better pane management
10. **tmux-logging** - Log tmux output to files
11. **tmux-battery** - Battery status display
12. **tmux-cpu** - CPU usage display
13. **tmux-mem-cpu-load** - Memory and CPU load display
14. **catppuccin/tmux** - Beautiful color theme

### Plugin Management

| Key | Action | Description |
|-----|--------|-------------|
| `Prefix + I` | Install plugins | Install new plugins |
| `Prefix + U` | Update plugins | Update all plugins |
| `Prefix + Alt-u` | Clean plugins | Remove unlisted plugins |

## Integration Features

### Vim/Neovim Integration

- Smart navigation between vim splits and tmux panes
- Seamless `Ctrl-h/j/k/l` navigation
- Automatic detection of vim/nvim/fzf processes
- Copy mode navigation similar to vim

### macOS Integration

- `reattach-to-user-namespace` for clipboard support
- System `open` command integration for URLs and files
- LaunchAgent support for background updates

### Shell Integration

- Preserves current working directory in new panes/windows
- Environment variable preservation
- Custom PATH configuration for Homebrew

## Troubleshooting

### Common Issues

1. **Key bindings not working**: Reload config with `Prefix + r`
2. **Colors not displaying**: Check terminal true color support
3. **Clipboard not working**: Ensure `reattach-to-user-namespace` is installed
4. **Plugin issues**: Try `Prefix + I` to reinstall plugins

### Debugging Commands

```bash
# List all key bindings
tmux list-keys

# Show tmux server info
tmux info

# Check tmux version
tmux -V

# Validate configuration
tmux source-file ~/.tmux.conf
```

## Configuration Hierarchy

1. **Main config**: `~/.tmux.conf` (symlinked from repo)
2. **Modular configs**: Sourced from `~/.config/tmux/`
3. **Plugin configs**: Loaded by TPM
4. **Theme configs**: Catppuccin theme with custom overrides

This comprehensive keybinding reference covers all configured shortcuts and provides context for their usage within the broader tmux ecosystem.