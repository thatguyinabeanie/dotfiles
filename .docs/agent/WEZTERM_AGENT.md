# WezTerm Agent Guide

Instructions for AI assistants working with WezTerm terminal configuration.

## Overview

WezTerm is a GPU-accelerated terminal emulator with built-in multiplexing capabilities.
In this configuration, it's set up to work with Zellij for tabs/panes management.

## Configuration Files

| File               | Location                             | Purpose                   |
| ------------------ | ------------------------------------ | ------------------------- |
| `wezterm.lua`      | `~/.config/wezterm/wezterm.lua`      | Main configuration (Lua)  |
| `wezterm-init.zsh` | `~/.config/wezterm/wezterm-init.zsh` | Zellij auto-launcher      |

## Template Variables Used

### UI Variables (from `.chezmoidata`)

- `{{ .ui.font_family }}` - Font name (for example, "Dank Mono")
- `{{ .ui.font_size }}` - Font size in points
- `{{ .ui.opacity }}` - Window background opacity (0.0-1.0)
- `{{ .ui.blur }}` - macOS background blur radius
- `{{ .ui.cursor_style }}` - Cursor shape (block, block_hollow, bar, underline)
- `{{ .ui.cursor_blink }}` - Whether cursor blinks (boolean)
- `{{ .ui.window_width }}` - Initial window width in columns
- `{{ .ui.window_height }}` - Initial window height in rows

### Theme Variables

- `{{ .CATPPUCCIN_FLAVOR }}` - Catppuccin flavor (mocha, macchiato, frappe, latte)
- `{{ .THEME_MODE }}` - Theme mode (system, dark, light)

### Shell Variables

- `{{ .env_shared.shell_paths.zsh }}` - Path to zsh executable

## Key Features

### Dynamic Theme Switching

WezTerm automatically switches between light and dark Catppuccin themes based on
macOS system appearance when `THEME_MODE` is set to "system."

### Zellij Integration

WezTerm launches Zellij automatically via `wezterm-init.zsh`:

- Creates/attaches to shared session named "wezterm"
- All WezTerm windows share the same Zellij session
- Bypass with `WEZTERM_NO_ZELLIJ=1` environment variable

### Tab Bar Disabled

The WezTerm tab bar is disabled since Zellij handles tabs/panes.
Use Zellij keybindings (Ctrl+a prefix) for tab management.

## Common Customizations

### Change Font

Edit the template variable in your chezmoi data:

```yaml
# .chezmoidata/personal.yaml or similar
ui:
  font_family: "JetBrains Mono"
  font_size: 14
```

### Adjust Opacity/Blur

```yaml
ui:
  opacity: 0.8    # More opaque
  blur: 100       # Less blur
```

### Enable WezTerm Tab Bar

Edit `wezterm.lua.tmpl` and change:

```lua
config.enable_tab_bar = true
config.use_fancy_tab_bar = true
```

### Add Custom Keybindings

Add to the `config.keys` table in `wezterm.lua.tmpl`:

```lua
{
  key = 'Enter',
  mods = 'CMD|SHIFT',
  action = wezterm.action.ToggleFullScreen,
},
```

## Troubleshooting

### WezTerm won't start

1. Check for Lua syntax errors: `wezterm --config-file ~/.config/wezterm/wezterm.lua`
2. Verify template rendered correctly: `chezmoi diff`
3. Check WezTerm logs: View → Show Debug Overlay (or Ctrl+Shift+L)

### Zellij doesn't launch

1. Check if Zellij is installed: `which zellij`
2. Check init script is executable: `ls -la ~/.config/wezterm/wezterm-init.zsh`
3. Run init script manually: `~/.config/wezterm/wezterm-init.zsh`

### Theme not applying

1. Verify CATPPUCCIN_FLAVOR is set: `chezmoi data | grep CATPPUCCIN`
2. Check color_scheme in generated config: `grep color_scheme ~/.config/wezterm/wezterm.lua`
3. WezTerm has built-in Catppuccin themes - no external files needed

### Font not rendering correctly

1. Check font is installed: `wezterm ls-fonts --list-system | grep "Dank Mono"`
2. Verify font name matches exactly (case-sensitive)
3. Try fallback: `wezterm.font_with_fallback({'Dank Mono', 'JetBrains Mono'})`

## Validation Checklist

Before committing changes:

- [ ] `chezmoi apply --dry-run` succeeds
- [ ] WezTerm launches without errors
- [ ] Zellij auto-attaches to session
- [ ] Theme matches system appearance
- [ ] Font and cursor render correctly
- [ ] Keybindings work (Cmd+T for new window, etc.)

## Related Documentation

- [Zellij Agent Guide](./ZELLIJ_AGENT.md)
- [WezTerm Official Docs](https://wezfurlong.org/wezterm/)
- [Catppuccin Theme](https://github.com/catppuccin/wezterm)
