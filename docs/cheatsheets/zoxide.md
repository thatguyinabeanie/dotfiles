# zoxide

**Smart directory jumper**—faster `cd` that learns from your habits.

## 🚀 Core Commands

| Command | Action |
|---------|--------|
| `z NAME` | Jump to directory matching `NAME` |
| `z /full/path` | Jump to exact directory path |
| `z -` | Jump to previous directory |
| `zi` | Interactive selection of recent directories (fzf) |
| `z project myapp` | Jump using multiple keywords |
| `z p/m` | Jump using abbreviated path segments |

## 🗄️ Database Management

| Command | Action |
|---------|--------|
| `zoxide query -l` | List all tracked directories |
| `zoxide query NAME` | Show frecency score for directory |
| `zoxide remove /path/to/dir` | Remove directory from database |
| `zoxide remove --interactive` | Interactively remove directories |
| `zoxide import` | Import directories from another tool |
