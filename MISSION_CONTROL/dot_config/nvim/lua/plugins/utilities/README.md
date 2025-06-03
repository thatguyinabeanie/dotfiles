# Utilities Plugins

This directory contains utility plugins that enhance Neovim's productivity and workflow.

## Plugin Overview

### Code Folding

- **nvim-ufo.lua** - Advanced code folding with LSP support
  - Loading: VeryLazy event
  - Features: LSP-based folding, fold preview, custom providers
  - Dependencies: Requires `nvim-treesitter` and `promise-async`

### Navigation

- **vim-tmux-navigator.lua** - Seamless tmux/vim pane navigation
  - Loading: Lazy with keymaps
  - Features: Unified navigation between vim splits and tmux panes
  - Keymaps: `<C-h/j/k/l>` for directional navigation

### Productivity Tools

- **pomodoro.lua** - Built-in Pomodoro timer
  - Loading: On demand with commands
  - Features: Work/break timers, notifications, tmux integration
  - Commands: `:PomodoroStart`, `:PomodoroStop`, `:PomodoroStatus`

- **carbon-now.lua** - Generate beautiful code screenshots
  - Loading: On demand with commands
  - Features: Upload code selections to carbon.now.sh
  - Commands: `:CarbonNow` (visual mode), `:CarbonNowSh`

### Note Taking

- **obsidian.lua.tmpl** - Obsidian vault integration
  - Loading: Conditional based on workspace detection
  - Features: Note creation, daily notes, search, templates
  - Workspace: Configured for `~/obsidian/tdb/`

### Kubernetes

- **kubectl.lua.tmpl** - Kubernetes resource management
  - Loading: On demand with commands
  - Features: Resource viewing, editing, port forwarding
  - Commands: `:Kubectl` prefix commands

### Key Discovery

- **which-key.lua** - Interactive keymap hints
  - Loading: VeryLazy event
  - Features: Shows available keymaps, descriptions, grouping
  - Activation: Automatic on key sequence delay

## Configuration Details

### UFO Folding

```lua
-- Provider priority
provider_selector = function(bufnr, filetype, buftype)
  return { "lsp", "indent" }
end
```

### Pomodoro Settings

- Work duration: 25 minutes
- Break duration: 5 minutes
- Long break: 15 minutes (every 4 pomodoros)
- Notifications: System notifications + tmux status

### Obsidian Workspaces

```lua
workspaces = {
  {
    name = "tdb",
    path = "~/obsidian/tdb",
  },
}
```

## Keymappings

### UFO Folding

- `zR` - Open all folds
- `zM` - Close all folds
- `zr` - Open folds recursively
- `zm` - Close folds recursively
- `K` - Peek folded content (hover)

### Tmux Navigator

- `<C-h>` - Navigate left
- `<C-j>` - Navigate down
- `<C-k>` - Navigate up
- `<C-l>` - Navigate right
- `<C-\\>` - Previous split

### Obsidian

- `<leader>on` - New note
- `<leader>oo` - Quick switch
- `<leader>os` - Search notes
- `<leader>od` - Daily note
- `<leader>ot` - Tags

### Which-Key

- Activates automatically after key delay
- `<leader>` - Show leader mappings
- `g` - Show go-to mappings
- `z` - Show fold mappings

## Performance Considerations

1. **UFO** loads on VeryLazy to defer folding setup
2. **Which-key** has minimal startup impact despite VeryLazy loading
3. **Obsidian** only loads in configured workspaces
4. **Carbon-now** and **kubectl** are fully lazy loaded
5. **Pomodoro** loads only when timer commands are used

## Customization

### Folding Appearance

```lua
vim.o.foldcolumn = "1"
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true
```

### Pomodoro Notifications

- Integrates with system notifications
- Updates tmux status line
- Configurable work/break durations

### Which-Key Groups

Custom group names defined for better organization:

- `<leader>c` = "+code"
- `<leader>f` = "+file/find"
- `<leader>g` = "+git"
- `<leader>o` = "+obsidian"

## Dependencies

### System Requirements

- **carbon-now**: Requires internet connection
- **kubectl**: Requires kubectl CLI installed
- **obsidian**: Requires Obsidian app for full features
- **tmux-navigator**: Requires tmux with proper configuration

### Neovim Dependencies

- **nvim-ufo**: Requires nvim-treesitter and promise-async
- **which-key**: No additional dependencies
- **pomodoro**: Optional tmux integration

## Troubleshooting

### UFO Not Working

- Ensure LSP is running: `:LspInfo`
- Check treesitter installation: `:TSInstallInfo`
- Verify fold settings: `:set foldmethod?`

### Tmux Navigation Issues

- Ensure tmux.conf has matching keybindings
- Check if tmux plugin is installed
- Verify `$TMUX` environment variable

### Obsidian Connection

- Confirm vault path exists
- Check workspace configuration
- Ensure Obsidian app is installed

### Which-Key Delays

- Adjust `vim.o.timeoutlen` for faster/slower activation
- Default is 300ms, can be reduced to 200ms

## Template Files

Files ending in `.tmpl` are Chezmoi templates:

- **kubectl.lua.tmpl**: Conditional loading based on environment
- **obsidian.lua.tmpl**: Path configuration based on user setup

These templates are processed during dotfile installation.
