# zoxide Cheatsheet

**Smart directory jumper**—faster and smarter alternative to `cd` that tracks frequently visited directories.

## Basic Usage

| Command | Description |
|---------|-------------|
| `z` | Jump to a frequently visited directory |
| `z foldername` | Jump to directory matching `foldername` |
| `z /full/path` | Jump to exact directory path |
| `zi` | Interactive selection of recent directories |

## Common Patterns

### Jump to project directory

```bash
z myproject
```

### Jump to nested directory with partial name

```bash
z config  # Jumps to ~/.config or similar
```

### Interactive directory selection

```bash
zi  # Opens fzf picker of recent directories
```

### Jump to most recent directory

```bash
z -  # Like cd - but smarter
```

## Frecency Algorithm

zoxide uses **frecency** (frequency + recency) to rank directories:

- Frequently visited directories rank higher
- Recently visited directories get a boost
- Rarely visited directories gradually fade

## Integration with Shell

### Add to `.zshrc` or `.bashrc`

```bash
eval "$(zoxide init zsh)"  # For Zsh
eval "$(zoxide init bash)" # For Bash
```

### Fish shell

```bash
zoxide init fish | source
```

## Database Management

| Command | Description |
|---------|-------------|
| `zoxide query -l` | List all tracked directories |
| `zoxide query foldername` | Query frecency score for directory |
| `zoxide remove /path/to/dir` | Remove directory from database |
| `zoxide remove --interactive` | Interactively remove directories |
| `zoxide import` | Import directories from other tools |

## Tips

- **Abbreviations work**: `z p/m` can match `~/projects/myapp`
- **Combine with fzf**: Use `zi` for interactive selection with fzf
- **Multiple words**: `z project myapp` jumps intelligently
- **Watch database grow**: Every `z` jump adds to your frecency data
- **Recent directories**: Less frequently visited dirs still accessible with more specific names

## Using with Other Tools

### With tmux (sesh integration)

```bash
sesh list -z  # Lists zoxide directories in sesh
```

### With fzf

```bash
cd $(zoxide query -l | fzf)
```

### With telescope (Neovim)

Recent directories are available for fuzzy searching
