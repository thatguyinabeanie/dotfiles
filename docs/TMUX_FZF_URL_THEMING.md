# tmux-fzf-url Theming Configuration

## Overview

This document provides comprehensive theming configuration for tmux-fzf-url to ensure the fuzzy finder overlay matches your existing terminal and tmux theme setup.

## Key Configuration Setting

The primary setting for theming tmux-fzf-url is the `@fzf-url-fzf-options` configuration variable, which allows you to pass custom color and styling options to the underlying fzf process.

```bash
set -g @fzf-url-fzf-options '--color fg:#bbccdd,fg+:#ddeeff,bg:#334455,border:#778899'
```

## Available Color Elements

fzf provides extensive color customization options for different UI elements:

### Basic Colors

- `fg` - Default foreground color
- `bg` - Default background color
- `fg+` - Foreground color for current line
- `bg+` - Background color for current line

### Highlight Colors

- `hl` - Highlight color for matching characters
- `hl+` - Highlight color for matching characters on current line

### Interface Elements

- `info` - Info line color (shows match count, etc.)
- `prompt` - Input prompt color
- `pointer` - Selection pointer/cursor color
- `marker` - Multi-select marker color
- `spinner` - Loading spinner color
- `header` - Header text color
- `border` - Border color around the interface

### Preview Window (if used)

- `preview-fg` - Preview window foreground color
- `preview-bg` - Preview window background color
- `preview-border` - Preview window border color

## Theme Examples

### Catppuccin Mocha Theme

Perfect for dark terminal setups using the Catppuccin color palette:

```bash
set -g @fzf-url-fzf-options '--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8,fg:#cdd6f4,header:#94e2d5,info:#cba6f7,pointer:#f5e0dc,marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8,border:#6c7086'
```

### Catppuccin Latte Theme

For light terminal setups:

```bash
set -g @fzf-url-fzf-options '--color=bg+:#ccd0da,bg:#eff1f5,spinner:#dc8a78,hl:#d20f39,fg:#4c4f69,header:#179299,info:#8839ef,pointer:#dc8a78,marker:#dc8a78,fg+:#4c4f69,prompt:#8839ef,hl+:#d20f39,border:#acb0be'
```

### Dracula Theme

Popular dark theme with purple accents:

```bash
set -g @fzf-url-fzf-options '--color=bg+:#44475a,bg:#282a36,spinner:#ffb86c,hl:#ff79c6,fg:#f8f8f2,header:#8be9fd,info:#bd93f9,pointer:#ffb86c,marker:#ffb86c,fg+:#f8f8f2,prompt:#bd93f9,hl+:#ff79c6,border:#6272a4'
```

### Nord Theme

Clean, minimal theme with blue/cyan accents:

```bash
set -g @fzf-url-fzf-options '--color=bg+:#3b4252,bg:#2e3440,spinner:#81a1c1,hl:#bf616a,fg:#e5e9f0,header:#8fbcbb,info:#81a1c1,pointer:#81a1c1,marker:#81a1c1,fg+:#e5e9f0,prompt:#81a1c1,hl+:#bf616a,border:#4c566a'
```

### Gruvbox Dark Theme

Retro, warm color scheme:

```bash
set -g @fzf-url-fzf-options '--color=bg+:#3c3836,bg:#282828,spinner:#fe8019,hl:#fb4934,fg:#ebdbb2,header:#8ec07c,info:#fabd2f,pointer:#fe8019,marker:#fe8019,fg+:#ebdbb2,prompt:#fabd2f,hl+:#fb4934,border:#665c54'
```

## Complete Configuration Examples

### Basic Setup with Theming

```bash
# tmux-fzf-url configuration with theming
set -g @plugin 'wfxr/tmux-fzf-url'
set -g @fzf-url-open "lynx -accept_all_cookies"
set -g @fzf-url-bind 'u'
set -g @fzf-url-fzf-options '--tmux center,80%,60% --multi --exit-0 --no-preview --border --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8,fg:#cdd6f4,header:#94e2d5,info:#cba6f7,pointer:#f5e0dc,marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8,border:#6c7086'
set -g @fzf-url-history-limit '3000'
```

### Advanced Setup with Conditional Theming

```bash
# Theme-aware configuration that adapts to system theme
set -g @plugin 'wfxr/tmux-fzf-url'
set -g @fzf-url-open "lynx -accept_all_cookies"
set -g @fzf-url-bind 'u'
set -g @fzf-url-history-limit '3000'

# Catppuccin Mocha (dark mode) - default
set -g @fzf-url-fzf-options '--tmux center,80%,60% --multi --exit-0 --no-preview --border --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8,fg:#cdd6f4,header:#94e2d5,info:#cba6f7,pointer:#f5e0dc,marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8,border:#6c7086'

# For light mode users, uncomment the following line instead:
# set -g @fzf-url-fzf-options '--tmux center,80%,60% --multi --exit-0 --no-preview --border --color=bg+:#ccd0da,bg:#eff1f5,spinner:#dc8a78,hl:#d20f39,fg:#4c4f69,header:#179299,info:#8839ef,pointer:#dc8a78,marker:#dc8a78,fg+:#4c4f69,prompt:#8839ef,hl+:#d20f39,border:#acb0be'
```

## Layout and Positioning Options

Beyond colors, you can customize the appearance and behavior of the fzf overlay:

### Popup Positioning

```bash
# Center popup, 80% width, 60% height
--tmux center,80%,60%

# Bottom popup, full width, 40% height
--tmux bottom,100%,40%

# Left side popup, 50% width
--tmux left,50%

# Top popup, 70% width, 30% height
--tmux top,70%,30%
```

### Border Styles

```bash
# Add border around the interface
--border

# Specific border styles
--border=rounded
--border=sharp
--border=bold
--border=double
--border=horizontal
--border=vertical
```

### Layout Options

```bash
# Reverse layout (input at top)
--layout=reverse

# Default layout (input at bottom)
--layout=default

# Reverse with results at bottom
--layout=reverse-list
```

## Integration with System Theme

### Automatic Theme Detection

If you use a system theme switcher, you can create a script to detect the current theme and apply appropriate colors:

```bash
#!/bin/bash
# ~/.local/bin/tmux-fzf-theme-sync

THEME_MODE=$(defaults read -g AppleInterfaceStyle 2>/dev/null || echo "Light")

if [[ "$THEME_MODE" == "Dark" ]]; then
    # Apply dark theme
    tmux set-option -g @fzf-url-fzf-options '--tmux center,80%,60% --multi --exit-0 --no-preview --border --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8,fg:#cdd6f4,header:#94e2d5,info:#cba6f7,pointer:#f5e0dc,marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8,border:#6c7086'
else
    # Apply light theme
    tmux set-option -g @fzf-url-fzf-options '--tmux center,80%,60% --multi --exit-0 --no-preview --border --color=bg+:#ccd0da,bg:#eff1f5,spinner:#dc8a78,hl:#d20f39,fg:#4c4f69,header:#179299,info:#8839ef,pointer:#dc8a78,marker:#dc8a78,fg+:#4c4f69,prompt:#8839ef,hl+:#d20f39,border:#acb0be'
fi
```

### Chezmoi Template Integration

For dynamic theming with chezmoi, you can use template variables:

```bash
{{- if eq .THEME_MODE "dark" }}
set -g @fzf-url-fzf-options '--tmux center,80%,60% --multi --exit-0 --no-preview --border --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8,fg:#cdd6f4,header:#94e2d5,info:#cba6f7,pointer:#f5e0dc,marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8,border:#6c7086'
{{- else }}
set -g @fzf-url-fzf-options '--tmux center,80%,60% --multi --exit-0 --no-preview --border --color=bg+:#ccd0da,bg:#eff1f5,spinner:#dc8a78,hl:#d20f39,fg:#4c4f69,header:#179299,info:#8839ef,pointer:#dc8a78,marker:#dc8a78,fg+:#4c4f69,prompt:#8839ef,hl+:#d20f39,border:#acb0be'
{{- end }}
```

## Color Format Reference

fzf accepts colors in several formats:

### Hex Colors

```bash
--color fg:#ffffff,bg:#000000
```

### Named Colors

```bash
--color fg:white,bg:black
```

### 256-Color Palette

```bash
--color fg:15,bg:0
```

### ANSI Colors

```bash
--color fg:bright-white,bg:black
```

## Testing Your Theme

### Quick Theme Test

```bash
# Test your theme configuration
echo -e "https://github.com\nhttps://google.com\nhttps://stackoverflow.com" | fzf --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8,fg:#cdd6f4,header:#94e2d5,info:#cba6f7,pointer:#f5e0dc,marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8,border:#6c7086 --tmux center,80%,60% --border
```

### Theme Validation Script

```bash
#!/bin/bash
# ~/.local/bin/validate-fzf-theme

echo "Testing current tmux-fzf-url theme..."

# Get current tmux fzf options
CURRENT_OPTIONS=$(tmux show-option -gv @fzf-url-fzf-options 2>/dev/null)

if [[ -n "$CURRENT_OPTIONS" ]]; then
    echo "Current options: $CURRENT_OPTIONS"
    echo -e "https://github.com\nhttps://google.com\nhttps://example.com" | fzf $CURRENT_OPTIONS
else
    echo "No theme configured. Using default fzf colors."
    echo -e "https://github.com\nhttps://google.com\nhttps://example.com" | fzf
fi
```

## Troubleshooting

### Common Issues

1. **Colors not applying**: Ensure your terminal supports true color
2. **Theme not loading**: Restart tmux after configuration changes
3. **Inconsistent appearance**: Check for conflicting FZF_DEFAULT_OPTS

### Debug Commands

```bash
# Check current tmux-fzf-url configuration
tmux show-options -g | grep fzf-url

# Test fzf color support
fzf --color=bg:#ff0000 < /dev/null

# Verify terminal color support
echo $TERM
echo $COLORTERM
```

## Best Practices

1. **Consistency**: Match your existing tmux and terminal theme
2. **Contrast**: Ensure sufficient contrast for readability
3. **Testing**: Test themes in different lighting conditions
4. **Accessibility**: Consider colorblind-friendly palettes
5. **Performance**: Simpler themes may perform better over SSH

## Color Palette Resources

- [Catppuccin](https://catppuccin.com/) - Soothing pastel theme
- [Dracula](https://draculatheme.com/) - Dark theme with purple accents
- [Nord](https://www.nordtheme.com/) - Minimal arctic color palette
- [Gruvbox](https://github.com/morhetz/gruvbox) - Retro groove color scheme
- [FZF Theme Playground](https://vitormv.github.io/fzf-themes/) - Interactive theme builder

## Related Configuration

This theming works in conjunction with:

- [Terminal Browser Integration](./TERMINAL_BROWSER_INTEGRATION.md)
- tmux color scheme configuration
- Terminal emulator theme settings
- System-wide appearance preferences
