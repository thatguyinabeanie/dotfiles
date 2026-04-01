# television

**TUI fuzzy finder**—fast, modern terminal UI fuzzy finder with live preview.

## 🚀 CLI Commands

| Command | Action |
|---------|--------|
| `tv` | Open file picker in current directory |
| `tv git` | Browse git-related information |
| `tv sesh` | Browse tmux sessions via sesh |
| `tv processes` | Browse running processes |
| `command \| tv` | Pipe output into television |

## ⌨️ Navigation

| Key | Action |
|-----|--------|
| `j` / `↓` | Move cursor down |
| `k` / `↑` | Move cursor up |
| `g` | Jump to top |
| `G` | Jump to bottom |
| `d` | Page down |
| `u` | Page up |
| `/` | Start search |
| `Esc` | Exit search / cancel |
| `Enter` | Select item |
| `Ctrl + C` | Quit |

## 🔭 Preview Controls

| Shortcut | Action |
|----------|--------|
| `Ctrl + O` | Toggle preview panel |
| `Ctrl + F` | Cycle preview position |
| `Ctrl + L` | Toggle layout |
| `Page Down` / `Page Up` | Scroll preview half page |

## 🔍 Search Syntax

| Syntax | Behavior |
|--------|----------|
| `term` | Fuzzy search |
| `'term` | Exact match |
| `!term` | Exclude term |
| `^term` | Match at start of line |
| `term$` | Match at end of line |

## 🔧 Flags

| Flag | Description |
|------|-------------|
| `-p` | Show preview panel |
| `--no-preview` | Hide preview panel |
| `-m` / `--multi` | Multi-select mode |
| `--border` | Show border around picker |
| `--height N` | Set height in lines |
