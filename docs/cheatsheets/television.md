# Television Cheatsheet

**TUI fuzzy finder**—fast, modern terminal UI fuzzy finder with preview capabilities.

## Basic Usage

| Command | Description |
|---------|-------------|
| `tv` | Open television picker for files |
| `tv search-term` | Search for term immediately |
| `command \| tv` | Pipe output to television |

## Keyboard Navigation

| Key | Action |
|-----|--------|
| `j` / `↓` | Move cursor down |
| `k` / `↑` | Move cursor up |
| `g` | Jump to top |
| `G` | Jump to bottom |
| `d` | Page down |
| `u` | Page up |
| `/` | Start search |
| `Esc` | Exit search / Cancel |
| `Enter` | Select item |
| `Ctrl+C` | Quit |

## Television Channels

Television includes built-in "channels" for common tasks:

### File browsing

```bash
tv  # Browse files in current directory
```

### Git integration

```bash
tv git  # Browse git-related information
```

### Sesh integration (tmux sessions)

```bash
tv sesh  # Browse tmux sessions with sesh
```

### Process management

```bash
tv processes  # Browse running processes
```

## Preview Window

| Shortcut | Action |
|----------|--------|
| `Ctrl+O` | Toggle preview panel |
| `Ctrl+F` | Cycle preview position |
| `Ctrl+L` | Toggle layout |
| `Page Down/Up` | Scroll preview half page |

## Search Modifiers

| Syntax | Behavior |
|--------|----------|
| `term` | Fuzzy search for term |
| `'term` | Exact match for term |
| `!term` | Exclude term from results |
| `^term` | Match at start of line |
| `term$` | Match at end of line |

## Integration with Tools

### With tmux (session picker)

```bash
bind-key "t" display-popup -E -w 85% -h 85% "tv sesh"
```

### With fzf-compatible tools

Television can be used as an fzf replacement in many workflows:

```bash
command | tv  # Instead of: command | fzf
```

## Options

| Flag | Description |
|------|-------------|
| `-p` | Show preview panel |
| `--no-preview` | Hide preview panel |
| `-m` / `--multi` | Multi-select mode |
| `--border` | Show border around picker |
| `--height N` | Set height in lines |

## Tips

- **Preview by default**: Preview window shows context for selected item
- **Fast filtering**: Type to filter results in real-time
- **Mouse support**: Click to navigate (terminal-dependent)
- **Color support**: Preserves colors from piped input
- **Performance**: Handles large lists efficiently with streaming preview

## Common Use Cases

### Select file to edit

```bash
nvim $(tv)
```

### Kill process

```bash
ps aux | tv | awk '{print $2}' | xargs kill
```

### Checkout git branch

```bash
git checkout $(git branch | tv)
```

### Docker container selection

```bash
docker ps -a | tv
```
