# 🚀 WezTerm Terminal Emulator Guide

**Quick Reference**: Your complete guide to using WezTerm with seamless Zellij integration

---

## 📋 Table of Contents

1. [What is WezTerm?](#what-is-wezterm)
2. [Quick Start](#quick-start)
3. [Configuration Overview](#configuration-overview)
4. [Customization](#customization)
5. [Keybindings](#keybindings)
6. [Theme & Appearance](#theme--appearance)
7. [Zellij Integration](#zellij-integration)
8. [Tips & Tricks](#tips--tricks)
9. [Troubleshooting](#troubleshooting)

---

## What is WezTerm?

WezTerm is a **GPU-accelerated terminal emulator** that provides:

- 🎨 Beautiful rendering with font ligatures
- ⚡ Fast performance using GPU acceleration
- 🔧 Extensive Lua-based configuration
- 🎯 Built-in multiplexing (though we use Zellij for this)
- 🌈 Catppuccin theme with auto-switching

**Key Features in This Setup:**

- Automatic Catppuccin theme switching (follows macOS dark/light mode)
- Zellij auto-launch for tab/pane management
- Customizable opacity and blur effects
- Font ligatures for programming symbols
- Hidden tab bar (Zellij handles tabs)

---

## Quick Start

### Opening WezTerm

1. **From Spotlight**: Press `Cmd+Space`, type "WezTerm"
2. **From Aerospace**: `Alt+T` (if configured)
3. **From Dock**: Click the WezTerm icon

### First Launch Behavior

When you open WezTerm, it automatically:

1. Launches your configured shell (zsh)
2. Starts Zellij with a shared session named "wezterm"
3. All subsequent WezTerm windows attach to the same Zellij session

### Bypassing Zellij

If you want to use WezTerm without Zellij:

```bash
# Set environment variable before launching
WEZTERM_NO_ZELLIJ=1 wezterm

# Or from within WezTerm
export WEZTERM_NO_ZELLIJ=1
exec zsh  # Restart shell
```

---

## Configuration Overview

### Configuration Files

| File | Location | Purpose |
|------|----------|---------|
| `wezterm.lua` | `~/.config/wezterm/wezterm.lua` | Main configuration (Lua) |
| `wezterm-init.zsh` | `~/.config/wezterm/wezterm-init.zsh` | Zellij auto-launcher script |

### Configuration Variables

All WezTerm settings are managed through chezmoi templates and data files:

**UI Settings** (`.chezmoidata/shared.yaml` or similar):

```yaml
ui:
  font_family: "Dank Mono"        # Font name
  font_size: 20                   # Font size in points
  opacity: 0.5                    # Background opacity (0.0-1.0)
  blur: 255                       # macOS blur radius
  cursor_style: "block_hollow"    # Cursor shape
  cursor_blink: true              # Cursor blinking
  window_width: 160               # Initial width (columns)
  window_height: 65               # Initial height (rows)
  font_thicken: true              # Font weight adjustment
```

**Theme Settings**:

```yaml
CATPPUCCIN_FLAVOR: "mocha"        # Theme variant
THEME_MODE: "dark"                # system, dark, or light
```

---

## Customization

### Changing the Font

**Edit** `.chezmoidata/shared.yaml` or your personal/work config:

```yaml
ui:
  font_family: "JetBrains Mono"   # Replace with your preferred font
  font_size: 16                   # Adjust size
```

**Popular monospace fonts:**

- JetBrains Mono
- Fira Code
- Cascadia Code
- Hack
- Source Code Pro
- SF Mono (macOS system font)

**Apply changes:**

```bash
chezmoi apply
# Restart WezTerm
```

### Adjusting Opacity & Blur

For more or less transparency:

```yaml
ui:
  opacity: 0.95    # Nearly opaque (less transparent)
  opacity: 0.3     # Very transparent
  blur: 50         # Less blur
  blur: 300        # More blur
```

**Visual effect:**

- **Higher opacity (0.9-1.0)**: Less transparent, more focus
- **Lower opacity (0.3-0.6)**: More transparent, see desktop behind
- **Higher blur**: Softer, more frosted glass effect
- **Lower blur**: Sharper background visibility

### Changing Cursor Style

Available cursor styles:

```yaml
ui:
  cursor_style: "block"           # Solid block
  cursor_style: "block_hollow"    # Hollow block (default)
  cursor_style: "bar"             # Vertical bar (like VS Code)
  cursor_style: "underline"       # Underline cursor
  cursor_blink: true              # Blinking
  cursor_blink: false             # Steady (no blink)
```

### Window Size

Adjust initial window dimensions:

```yaml
ui:
  window_width: 200     # Wider window
  window_height: 80     # Taller window
```

**Units**: Measured in character columns and rows, not pixels.

### Theme Selection

**Auto-switching** (follows macOS appearance):

```yaml
THEME_MODE: "system"
```

**Always dark**:

```yaml
THEME_MODE: "dark"
CATPPUCCIN_FLAVOR: "mocha"      # or macchiato, frappe
```

**Always light**:

```yaml
THEME_MODE: "light"
# Uses Catppuccin Latte automatically
```

**Available Catppuccin flavors:**

- `mocha` - Dark, warm (default)
- `macchiato` - Dark, slightly lighter than mocha
- `frappe` - Dark, cooler tones
- `latte` - Light theme

---

## Keybindings

### macOS-Specific Shortcuts

| Keys | Action |
|------|--------|
| `Cmd+N` | New WezTerm window |
| `Cmd+T` | New tab (if WezTerm tabs enabled) |
| `Cmd+W` | Close window |
| `Cmd+Q` | Quit WezTerm |
| `Cmd+,` | Open preferences (if configured) |

### Copy/Paste

| Keys | Action |
|------|--------|
| `Cmd+C` | Copy |
| `Cmd+V` | Paste |
| Select with mouse | Auto-copy (if enabled) |

### Font Size Adjustment

| Keys | Action |
|------|--------|
| `Cmd++` | Increase font size |
| `Cmd+-` | Decrease font size |
| `Cmd+0` | Reset font size |

### Important Note on Tab Management

**WezTerm's tab bar is disabled** in this configuration because Zellij handles all tab and pane management.

**Instead, use Zellij keybindings:**

- New tab: `Ctrl+a c`
- Next tab: `Ctrl+a n`
- Previous tab: `Ctrl+a p`

See the [Zellij Guide](../zellij/GUIDE.md) for complete tab/pane management.

---

## Theme & Appearance

### Catppuccin Color Palette

WezTerm uses the Catppuccin color scheme, which provides:

**Dark Themes:**

- **Mocha**: Warmest dark theme (default)
  - Background: `#1e1e2e`
  - Foreground: `#cdd6f4`
  - Accent: `#89b4fa` (blue)

- **Macchiato**: Slightly lighter than mocha
  - Background: `#24273a`
  - Foreground: `#cad3f5`
  - Accent: `#8aadf4` (blue)

- **Frappé**: Cooler tones
  - Background: `#303446`
  - Foreground: `#c6d0f5`
  - Accent: `#8caaee` (blue)

**Light Theme:**

- **Latte**: Bright, easy on eyes in daylight
  - Background: `#eff1f5`
  - Foreground: `#4c4f69`
  - Accent: `#1e66f5` (blue)

### Dynamic Theme Switching

When `THEME_MODE: "system"` is set:

1. **macOS Light Mode** → Catppuccin Latte
2. **macOS Dark Mode** → Catppuccin Mocha/Macchiato/Frappé

**How to change macOS appearance:**

- System Settings → Appearance → Light/Dark/Auto

**Testing theme switching:**

```bash
# Toggle macOS appearance
# WezTerm will automatically switch themes
```

### Font Ligatures

WezTerm supports programming ligatures (special character combinations):

**Examples:**

```text
!= → ≠
>= → ≥
<= → ≤
=> → ⇒
-> → →
== → ==
```

**Fonts with great ligatures:**

- Fira Code
- JetBrains Mono
- Cascadia Code
- Dank Mono (default in this config)

---

## Zellij Integration

### How Integration Works

**Auto-Launch Flow:**

1. You open WezTerm
2. `wezterm-init.zsh` runs automatically
3. Checks if Zellij is already running
4. Either attaches to existing session or creates new one
5. All WezTerm windows share the same Zellij session

**Session Persistence:**

- Closing a WezTerm window doesn't kill the Zellij session
- Your tabs and panes persist
- Open a new WezTerm window → Auto-attaches to existing session
- Last window closed → Session ends

### Working with Multiple Windows

```bash
# Window 1: Backend development
Ctrl+a c  # New tab for API server

# Open new WezTerm window (Cmd+N)
# Window 2: Auto-attaches to same session
# You see the same tabs!

# Useful for:
# - Multiple monitors
# - Different workspaces in Aerospace
# - One window fullscreen, one for quick checks
```

### Disabling Zellij

**Temporarily:**

```bash
export WEZTERM_NO_ZELLIJ=1
exec zsh
```

**Permanently:**
Edit `~/.config/wezterm/wezterm-init.zsh` and comment out the Zellij launch section.

---

## Tips & Tricks

### Productivity Tips

1. **Multiple WezTerm Windows**: Use `Cmd+N` for new windows - they all share the same Zellij session
2. **Opacity Adjustment**: Lower opacity when multitasking to see content behind terminal
3. **Font Size**: Increase for presentations, decrease for more screen real estate
4. **Auto-Theme**: Use `THEME_MODE: "system"` to reduce eye strain (dark at night, light during day)

### Performance Optimization

WezTerm is GPU-accelerated, but you can tweak:

```lua
-- In wezterm.lua.tmpl (advanced users)
config.max_fps = 120                    -- Higher refresh rate
config.animation_fps = 10               -- Smooth animations
config.front_end = "WebGpu"             # Use modern graphics API
```

### Visual Enhancements

**Increase opacity for focus:**

```yaml
ui:
  opacity: 0.98
  blur: 30
```

**Dramatic blur effect:**

```yaml
ui:
  opacity: 0.3
  blur: 500
```

**Clean, minimal look:**

```yaml
ui:
  opacity: 1.0    # No transparency
  blur: 0         # No blur
```

### Font Rendering

**Thicker fonts** (for better readability):

```yaml
ui:
  font_thicken: true
```

**Font variations:**

```lua
-- In wezterm.lua.tmpl for advanced users
config.font = wezterm.font_with_fallback {
  'Dank Mono',
  'JetBrains Mono',  # Fallback if Dank Mono missing
  'Courier New',      # System fallback
}
```

---

## Troubleshooting

### Common Issues

#### WezTerm Won't Launch

**Problem**: Double-clicking WezTerm does nothing

**Solutions:**

1. Check if WezTerm is already running (check Dock or `ps aux | grep wezterm`)
2. Try launching from Terminal: `/Applications/WezTerm.app/Contents/MacOS/wezterm-gui`
3. Check logs: `~/Library/Logs/wezterm/`
4. Reinstall: `brew reinstall --cask wezterm`

#### Font Not Found

**Problem**: WezTerm shows default font, not your configured font

**Solutions:**

1. Verify font is installed: Font Book.app
2. Check exact font name: `fc-list | grep "YourFont"`
3. Use fallback fonts in config
4. Run `chezmoi apply` to update config

#### Theme Not Switching Automatically

**Problem**: Stays in dark mode even when macOS is in light mode

**Solutions:**

1. Verify `THEME_MODE: "system"` in chezmoi data
2. Restart WezTerm completely (`Cmd+Q`, not just close window)
3. Check WezTerm version: `wezterm --version` (update if old)
4. Manually reload config: `:reload` in WezTerm or `Ctrl+Shift+R`

#### Zellij Doesn't Auto-Launch

**Problem**: WezTerm opens but Zellij doesn't start

**Solutions:**

1. Check if `wezterm-init.zsh` exists: `ls ~/.config/wezterm/`
2. Verify it's executable: `chmod +x ~/.config/wezterm/wezterm-init.zsh`
3. Check if Zellij is installed: `which zellij`
4. Look at shell init files: `~/.zshrc` should source `wezterm-init.zsh`

#### Opacity/Blur Not Working

**Problem**: Terminal is always opaque

**Solutions:**

1. **macOS only feature**: Opacity and blur only work on macOS
2. Check if "Reduce transparency" is enabled in macOS System Settings
3. Verify values in config: `opacity` should be < 1.0
4. Restart WezTerm after config changes

#### Performance Issues

**Problem**: Terminal feels sluggish or laggy

**Solutions:**

1. **Reduce blur**: High blur values can impact performance

   ```yaml
   ui:
     blur: 50  # Lower value
   ```

2. **Disable opacity**:

   ```yaml
   ui:
     opacity: 1.0
   ```

3. **Lower font size**: Smaller fonts = less rendering
4. **Check GPU**: Ensure GPU acceleration is enabled

#### Configuration Changes Not Applied

**Problem**: Edited config but nothing changed

**Solutions:**

1. **Apply chezmoi changes**:

   ```bash
   chezmoi apply
   ```

2. **Restart WezTerm**: `Cmd+Q`, then reopen
3. **Check for template errors**:

   ```bash
   chezmoi apply --dry-run
   ```

4. **Verify file location**: Config should be at `~/.config/wezterm/wezterm.lua`

---

## Advanced Configuration

### Adding Custom Keybindings

Edit `wezterm.lua.tmpl`:

```lua
config.keys = {
  -- Example: Toggle fullscreen with Cmd+Enter
  {
    key = 'Enter',
    mods = 'CMD',
    action = wezterm.action.ToggleFullScreen,
  },

  -- Example: Open new WezTerm window with Cmd+Shift+N
  {
    key = 'N',
    mods = 'CMD|SHIFT',
    action = wezterm.action.SpawnWindow,
  },
}
```

### Enabling WezTerm Tab Bar

If you want WezTerm's tab bar alongside Zellij:

```lua
-- In wezterm.lua.tmpl
config.enable_tab_bar = true
config.use_fancy_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
```

**Note**: This creates "tabs within tabs" (WezTerm tabs containing Zellij sessions).

### Custom Color Schemes

While Catppuccin is configured, you can try others:

```lua
config.color_scheme = 'Tokyo Night'
-- Or: 'Dracula', 'Nord', 'Gruvbox', etc.
```

See all available: <https://wezfurlong.org/wezterm/colorschemes/>

---

## Quick Reference Card

```text
┌─────────────────────────────────────────────────────┐
│           WEZTERM QUICK REFERENCE                   │
├─────────────────────────────────────────────────────┤
│  WINDOW MANAGEMENT                                  │
│  Cmd+N      New window                              │
│  Cmd+W      Close window                            │
│  Cmd+Q      Quit WezTerm                            │
│                                                     │
│  FONT SIZE                                          │
│  Cmd++      Increase                                │
│  Cmd+-      Decrease                                │
│  Cmd+0      Reset                                   │
│                                                     │
│  COPY/PASTE                                         │
│  Cmd+C      Copy                                    │
│  Cmd+V      Paste                                   │
│                                                     │
│  NOTE: Use Zellij (Ctrl+a) for tabs and panes!     │
│  See: ../zellij/GUIDE.md                            │
└─────────────────────────────────────────────────────┘
```

---

## Configuration Locations

**Managed by chezmoi:**

- Source: `~/.local/share/chezmoi/dot_config/wezterm/`
- Deployed: `~/.config/wezterm/`

**Data files:**

- UI settings: `.chezmoidata/shared.yaml` (or personal/work)
- Theme settings: `.chezmoidata/shared.yaml`

**Apply configuration changes:**

```bash
chezmoi apply
# Then restart WezTerm (Cmd+Q and reopen)
```

---

## Additional Resources

**Official Documentation:**

- WezTerm Docs: <https://wezfurlong.org/wezterm/>
- WezTerm GitHub: <https://github.com/wez/wezterm>

**Related Configurations:**

- Zellij Integration: [../zellij/GUIDE.md](../zellij/GUIDE.md)
- Neovim Setup: [../nvim/GUIDE.md](../nvim/GUIDE.md)
