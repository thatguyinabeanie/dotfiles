# WezTerm Configuration

> GPU-accelerated terminal emulator with Zellij integration

## Quick Start

1. Launch WezTerm from Applications or Spotlight
2. Zellij automatically starts with shared session "wezterm"
3. Use `Ctrl+a` prefix for Zellij commands (tmux-like)

## Configuration Files

| File               | Purpose                  |
| ------------------ | ------------------------ |
| `wezterm.lua`      | Main configuration (Lua) |
| `wezterm-init.zsh` | Zellij auto-launcher     |

## Features

- **Dynamic theming**: Auto-switches light/dark with macOS
- **Catppuccin theme**: Built-in, no external files needed
- **Zellij integration**: Auto-launches multiplexer
- **Font ligatures**: Enabled for programming symbols
- **WebGpu rendering**: Maximum performance
- **Copy on select**: Mouse selection → clipboard

## Key Bindings

| Shortcut      | Action               |
| ------------- | -------------------- |
| `Cmd+T`       | New WezTerm window   |
| `Cmd+W`       | Close window         |
| `Cmd+K`       | Clear scrollback     |
| `Cmd++`       | Increase font size   |
| `Cmd+-`       | Decrease font size   |
| `Cmd+0`       | Reset font size      |
| `Right-click` | Paste from clipboard |
| `Cmd+click`   | Open hyperlink       |

## Environment Variables

| Variable             | Effect                       |
| -------------------- | ---------------------------- |
| `WEZTERM_NO_ZELLIJ=1`| Skip Zellij, start plain zsh |

## Template Variables

This configuration uses chezmoi template variables:

- `.ui.font_family` - Font name
- `.ui.font_size` - Font size
- `.ui.opacity` - Window transparency
- `.ui.blur` - Background blur
- `.ui.cursor_style` - Cursor shape
- `.ui.cursor_blink` - Cursor animation
- `.CATPPUCCIN_FLAVOR` - Theme flavor
- `.THEME_MODE` - Theme switching mode

## Customization

### Modify appearance

Edit `.chezmoidata/*.yaml` files, then run `chezmoi apply`.

### Add keybindings

Edit `wezterm.lua.tmpl` in the `config.keys` table.

### Enable tab bar

Set `config.enable_tab_bar = true` in `wezterm.lua.tmpl`.

## Troubleshooting

### Check for errors

```bash
wezterm --config-file ~/.config/wezterm/wezterm.lua
```

### View debug overlay

Press `Ctrl+Shift+L` or View → Show Debug Overlay

### List available fonts

```bash
wezterm ls-fonts --list-system
```

## Related

- [Zellij inline docs](../zellij/AGENTS-zellij.md)
- [Full WezTerm docs](https://wezfurlong.org/wezterm/)
- [Agent guide](../../.docs/agent/WEZTERM_AGENT.md)
