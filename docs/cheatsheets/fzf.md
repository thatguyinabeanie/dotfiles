# fzf Cheatsheet

**Fuzzy finder**—fast, interactive command-line search tool.

## Basic Usage

| Command | Description |
|---------|-------------|
| `command \| fzf` | Pipe output through fzf to select interactively |
| `fzf` | Open fuzzy finder for files in current directory |
| `cat file.txt \| fzf` | Select lines from file |

## Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `Ctrl+J` / `Ctrl+N` | Move cursor down |
| `Ctrl+K` / `Ctrl+P` | Move cursor up |
| `Ctrl+C` / `Esc` | Exit without selection |
| `Enter` | Select highlighted item |
| `Ctrl+V` | Toggle preview window |
| `Ctrl+A` | Select all |
| `Ctrl+D` | Deselect all |
| `Ctrl+T` | Toggle multi-select mode |
| `Ctrl+H` | Show help |

## Common Patterns

### Search files by name

```bash
vim $(fzf)
```

### Search git commits

```bash
git log --oneline | fzf
```

### Kill process interactively

```bash
ps aux | fzf | awk '{print $2}' | xargs kill -9
```

### Search command history

```bash
history | fzf
```

### Find and edit file

```bash
nvim $(find . -type f | fzf)
```

## Options

| Flag | Description |
|------|-------------|
| `-m` / `--multi` | Enable multi-select mode |
| `-e` / `--exact` | Exact match (no fuzzy matching) |
| `--reverse` | Display list top-to-bottom |
| `--height 50%` | Set height as percentage of screen |
| `--preview 'cat {}'` | Show preview of selected item |
| `--bind 'ctrl-a:select-all'` | Custom keybinding |
| `--prompt '> '` | Custom prompt text |
| `--header 'Select a file'` | Add header text |

## Integration with Tools

### With ripgrep (rg)

```bash
rg --files | fzf --preview 'bat --color=always {}'
```

### With git

```bash
git checkout $(git branch | fzf)
```

### With tmux (fzf-tmux)

```bash
fzf-tmux -p 80%,50%  # Open in tmux popup
```

## Tips

- **Preview command**: Add `--preview 'cat {}'` to preview file contents
- **Color output**: Use `--ansi` to preserve ANSI colors from piped input
- **Case sensitivity**: fzf is case-insensitive by default; type `'` to toggle
- **Performance**: Use `--no-sort` if input is pre-sorted
