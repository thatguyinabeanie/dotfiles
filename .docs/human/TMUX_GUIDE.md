# AGENTS-tmux.md

## Overview

This tmux configuration is designed for a modern terminal-based development workflow with vim-like navigation, aesthetic enhancements, and tight integration with other development tools. The configuration is modular and split across multiple files for maintainability.

## Configuration Structure

The tmux configuration is organized into several focused files:

- **`tmux.conf`** - Main configuration and imports
- **`tmux.keybindings.conf`** - All keybinding definitions  
- **`tmux.status.conf`** - Status bar configuration
- **`tmux.theme.catppuccin.conf.tmpl`** - Theme styling (Catppuccin)
- **`tmux.cursor.conf`** - Cursor and terminal integration
- **`tmux.pomodoro.conf`** - Pomodoro timer integration

## Key Features

### 1. **Vim-Style Navigation**
- Seamless navigation between tmux panes and vim splits
- Consistent hjkl movement patterns
- Smart pane switching that works with vim-tmux-navigator

### 2. **Modern Terminal Integration**
- True color support (24-bit)
- Undercurl support for modern terminals
- Enhanced mouse support
- Clipboard integration with system clipboard

### 3. **Developer-Focused Workflow**
- Session management optimized for project work
- Quick window/pane creation and navigation
- Integration with external tools (fzf, etc.)

## Keybindings Reference

### **Prefix Key**: `Ctrl+a`
All tmux commands are prefixed with `Ctrl+a` (changed from default `Ctrl+b` for ergonomics).

### **Core Navigation**
| Keybinding | Action | Description |
|------------|--------|-------------|
| `Prefix + h/j/k/l` | Navigate panes | Vim-style pane navigation |
| `Prefix + H/J/K/L` | Resize panes | Resize current pane in direction |
| `Prefix + arrow keys` | Navigate panes | Alternative pane navigation |
| `Prefix + Ctrl+h/l` | Navigate windows | Move between windows |

### **Window & Pane Management**
| Keybinding | Action | Description |
|------------|--------|-------------|
| `Prefix + c` | New window | Create new window |
| `Prefix + &` | Kill window | Close current window |
| `Prefix + x` | Kill pane | Close current pane |
| `Prefix + %` | Vertical split | Split pane vertically |
| `Prefix + "` | Horizontal split | Split pane horizontally |
| `Prefix + z` | Zoom pane | Toggle pane zoom |

### **Session Management**
| Keybinding | Action | Description |
|------------|--------|-------------|
| `Prefix + s` | List sessions | Show session selector |
| `Prefix + d` | Detach | Detach from current session |
| `Prefix + $` | Rename session | Rename current session |
| `Prefix + (` | Previous session | Switch to previous session |
| `Prefix + )` | Next session | Switch to next session |

### **Copy Mode (Vim-style)**
| Keybinding | Action | Description |
|------------|--------|-------------|
| `Prefix + [` | Enter copy mode | Start text selection |
| `v` | Begin selection | Start visual selection |
| `y` | Copy selection | Copy to clipboard |
| `q` | Exit copy mode | Return to normal mode |

### **Advanced Features**
| Keybinding | Action | Description |
|------------|--------|-------------|
| `Prefix + r` | Reload config | Reload tmux configuration |
| `Prefix + I` | Install plugins | Install/update plugins |
| `Prefix + U` | Update plugins | Update all plugins |

## Plugin Integration

### **Tmux Plugin Manager (TPM)**
- **tmux-sensible**: Better defaults
- **tmux-resurrect**: Session persistence
- **tmux-continuum**: Automatic session saving
- **vim-tmux-navigator**: Seamless vim/tmux navigation

### **Theme Integration**
- **Catppuccin theme**: Consistent with system theme
- Dynamic theme switching based on system appearance
- Custom status bar with git integration

## Integration Points

### **With Neovim**
- Seamless navigation between vim splits and tmux panes
- Shared clipboard functionality
- Consistent color scheme and styling

### **With Ghostty Terminal**
- True color support
- Custom keybindings for tmux window management
- Optimized for terminal font rendering

### **With Development Workflow**
- Session templates for different project types
- Integration with git status in status bar
- Support for development tools (fzf, ripgrep, etc.)

## Configuration Patterns

### **Window Naming Strategy**
- Automatic window renaming based on current directory
- Custom names for persistent windows (monitoring, logs, etc.)
- Session-specific window arrangements

### **Pane Layout Preferences**
- Main pane for editing (usually vim)
- Side pane for terminal operations
- Bottom pane for monitoring/logs when needed

### **Session Organization**
- One session per project/repository
- Shared session for general terminal work
- Temporary sessions for quick tasks

## Customization Guidelines

### **Adding New Keybindings**
1. Add to `tmux.keybindings.conf`
2. Follow vim-style patterns where possible
3. Avoid conflicts with vim-tmux-navigator
4. Document in this file

### **Theme Modifications**
1. Edit `tmux.theme.catppuccin.conf.tmpl`
2. Maintain consistency with system theme
3. Test in both light and dark modes
4. Consider colorblind accessibility

### **Plugin Management**
1. Add plugins to main `tmux.conf`
2. Configure plugin-specific settings in dedicated sections
3. Test plugin compatibility before committing
4. Update documentation when adding plugins

## Troubleshooting

### **Common Issues**
1. **Navigation not working**: Check vim-tmux-navigator installation
2. **Colors not displaying**: Verify terminal true color support
3. **Clipboard not working**: Check system clipboard integration
4. **Plugins not loading**: Run `Prefix + I` to install plugins

### **Performance Optimization**
- Limit status bar update frequency for better performance
- Use efficient plugin configurations
- Minimize unnecessary visual elements

## Best Practices

1. **Keep sessions focused**: One session per project/context
2. **Use descriptive window names**: Makes navigation easier
3. **Leverage pane layouts**: Consistent arrangements improve workflow
4. **Regular config updates**: Keep plugins and configurations current
5. **Document custom modifications**: Maintain this file when making changes

## OpenCode Integration Notes

When using with OpenCode:
- Tmux prefix `Ctrl+a` does not conflict with OpenCode keybindings
- Can run OpenCode within tmux sessions for better session management
- Vim-tmux-navigator works seamlessly with OpenCode's editor integration
- Consider using dedicated tmux windows for OpenCode sessions

## Complete Keybinding Reference

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

## FZF URL and Theming Integration

### FZF URL Features

The `tmux-fzf-url` plugin provides intelligent URL extraction and opening capabilities:

#### URL Detection Patterns
- **HTTP/HTTPS URLs**: Standard web addresses
- **Git URLs**: SSH and HTTPS git repository URLs  
- **File Paths**: Local and remote file paths
- **IP Addresses**: IPv4 and IPv6 addresses with ports
- **Email Addresses**: Mailto links and plain email addresses

#### Usage
1. Press `Prefix + u` to activate FZF URL mode
2. All URLs from the current pane are extracted and displayed in FZF
3. Use arrow keys or vim-style navigation to select a URL
4. Press Enter to open the selected URL with the system default application

#### Custom URL Handlers
- **Web URLs**: Open in default browser
- **Git URLs**: Clone repository or open in Git client
- **File Paths**: Open in default application or editor
- **Email**: Open in default email client

### Theming Strategy

The tmux configuration uses a sophisticated theming approach that integrates with the broader system theme:

#### Theme Components
1. **Base Theme**: Catppuccin color palette with multiple variants
2. **Dynamic Switching**: Automatic light/dark mode based on system settings
3. **Consistent Colors**: Shared color scheme across tmux, Neovim, and terminal
4. **Custom Overrides**: Specific adjustments for better visibility and aesthetics

#### Theme Files
- `tmux.theme.catppuccin.conf.tmpl`: Main theme configuration with Chezmoi templating
- Color variables are sourced from global Chezmoi data for consistency
- Supports multiple Catppuccin flavors (Latte, Frappé, Macchiato, Mocha)

#### Status Bar Theming
- **Window Status**: Active/inactive window indicators with custom colors
- **Session Info**: Session name with highlighting
- **System Info**: CPU, memory, battery status with color coding
- **Time Display**: Custom time format with themed colors

#### Pane Border Theming
- **Active Pane**: Highlighted border color for current pane
- **Inactive Panes**: Subtle border colors for background panes
- **Status Integration**: Border colors match status bar theme

### Advanced Configuration

#### Custom FZF URL Configuration
```bash
# Custom URL patterns can be added to enhance detection
set -g @fzf-url-extra-filter 'grep -oE "(magnet:\?[^\s]*)"'  # Magnet links
set -g @fzf-url-bind 'ctrl-o:execute-silent(open {})'        # Custom open binding
```

#### Theme Customization
```bash
# Custom color overrides in tmux.theme.catppuccin.conf.tmpl
set -g status-style "bg={{ .colors.surface0 }},fg={{ .colors.text }}"
set -g window-status-current-style "bg={{ .colors.blue }},fg={{ .colors.base }}"
```

This comprehensive tmux setup provides a powerful, efficient, and aesthetically pleasing terminal multiplexer experience that integrates seamlessly with the broader development environment.