# fzf

**Fuzzy finder**—fast, interactive command-line search tool.

## ⌨️ Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `Ctrl + J` / `Ctrl + N` | Move cursor down |
| `Ctrl + K` / `Ctrl + P` | Move cursor up |
| `Ctrl + C` / `Esc` | Exit without selection |
| `Enter` | Select highlighted item |
| `Ctrl + V` | Toggle preview window |
| `Ctrl + A` | Select all |
| `Ctrl + D` | Deselect all |
| `Ctrl + T` | Toggle multi-select mode |
| `Ctrl + H` | Show help |

## 🔧 Common Flags

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
| `--ansi` | Preserve ANSI colors from piped input |
| `--no-sort` | Skip sorting (use when input is pre-sorted) |

## 🔍 Search Syntax

| Pattern | Behavior |
|---------|----------|
| `term` | Fuzzy match |
| `'term` | Exact match |
| `!term` | Exclude term |
| `^term` | Prefix match |
| `term$` | Suffix match |
