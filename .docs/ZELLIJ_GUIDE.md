# Zellij Configuration Guide

This document describes our comprehensive Zellij configuration that provides a complete tmux replacement with modern improvements and seamless vim integration.

## Overview

Our Zellij setup replicates 100% of tmux functionality while adding:
- **Modern session management** with fuzzy finding and previews
- **Seamless vim navigation** with the vim-zellij-navigator plugin  
- **Beautiful Catppuccin theming** with muted blue aesthetics
- **Enhanced productivity features** like zoxide integration and custom layouts

## Quick Start

### Installation and Setup

1. **Install Zellij** (via mise or homebrew):
   ```bash
   mise install zellij@latest
   # or
   brew install zellij
   ```

2. **Apply dotfiles configuration**:
   ```bash
   chezmoi apply
   ```

3. **Start using Zellij**:
   ```bash
   z        # Launch session manager (replaces tmux SessionX)
   zellij   # Start new session directly
   ```

### Essential Commands

| Command | Description | tmux Equivalent |
|---------|-------------|-----------------|
| `z` | Launch session manager with fuzzy finder | `ta` (SessionX) |
| `zx` | Quick session switcher | `ts` |
| `zw` | Create new session in current directory | `tn` |
| `zcd` | Navigate to chezmoi directory | `td` |
| `zce` | Edit chezmoi with nvim | `te` |

## Key Bindings Reference

Our configuration provides three key binding modes for maximum flexibility:

### 1. Direct Access (No Prefix)

**Vim Navigation** (replaces vim-tmux-navigator):
- `Ctrl+h/j/k/l` - Navigate between panes/tabs seamlessly with vim

**Session Management**:
- `Ctrl+o` - Open session manager (fuzzy finder)
- `Ctrl+d` - Create new tab in chezmoi directory  
- `Ctrl+e` - Create new tab and open nvim in chezmoi

**Pane Operations**:
- `Alt+v` / `Alt+|` - Split pane vertically
- `Alt+s` / `Alt+-` - Split pane horizontally
- `Alt+c` - Create new tab
- `Alt+x` - Close current pane
- `Alt+z` - Toggle fullscreen

**Window Management**:
- `Ctrl+Shift+p/n` - Previous/next tab
- `Alt+t` - Toggle status bar

### 2. Tmux Mode (Ctrl+a Prefix)

Enter tmux mode with `Ctrl+a`, then use familiar tmux bindings:

**Session Operations**:
- `o` / `S` - Session manager
- `d` - Detach session
- `*` - List sessions

**Window/Tab Operations**:  
- `c` - Create new tab
- `w` - Tab switcher
- `"` - Tab mode
- `Ctrl+a` - Previous tab

**Pane Operations**:
- `v` / `|` - Split vertically  
- `-` / `s` - Split horizontally
- `h/j/k/l` - Navigate panes
- `z` - Toggle fullscreen
- `x` - Close pane

**Utility**:
- `r` - Reload configuration
- `R` - Rename tab
- `t` - Toggle status bar

### 3. Mode-Specific Operations

**Resize Mode** (`Ctrl+r`):
- `h/j/k/l` - Resize panes
- `+/-` - Increase/decrease size

**Scroll Mode** (`Ctrl+s`):  
- `j/k` - Scroll up/down
- `Ctrl+f/b` - Page up/down
- `s` - Search
- `e` - Edit scrollback

**Locked Mode** (`Ctrl+g`):
- Passes all keys to underlying application
- `Ctrl+g` again to exit

## Session Management

### SessionX Replacement

Our `zellij-sessionx` script provides enhanced session management:

**Features**:
- **Fuzzy finding** with fzf integration
- **Live previews** with syntax highlighting
- **Smart path detection** (~/source, ~/.config, chezmoi)
- **Zoxide integration** for recent directories
- **Git repository awareness** 

**Usage**:
```bash
z                    # Launch session manager
z my-project         # Create/attach to named session  
z ~/code/project     # Create session in specific directory
```

**Preview Features**:
- File listings with exa/ls
- Git status for repositories  
- Directory size and file counts
- Recent file activity

### Session Aliases

Complete tmux compatibility through shell aliases:

```bash
# tmux-style commands that work with zellij
ta [session]    # Attach to session (with optional name)  
tn [name]       # New session (with optional name)
tl              # List sessions
tk [session]    # Kill session (with optional name)
ts              # Session switcher
td              # New session in chezmoi directory
te              # Edit chezmoi with nvim
```

## Layouts

### Available Layouts

| Layout | Description | Use Case |
|--------|-------------|----------|
| `tmux-like` | Status bar on top (default) | General development |
| `bottom-status` | Status bar on bottom | tmux-like experience |
| `minimal` | Minimal status bar | Distraction-free coding |
| `chezmoi` | Optimized for dotfiles editing | Chezmoi workflow |
| `chezmoi-nvim` | Chezmoi with vim splits | Advanced editing |

### Switching Layouts

```bash
# Command line
zellij --layout chezmoi

# Or modify config.kdl:
default_layout "bottom-status"
```

## Theming

### Current Theme: Catppuccin Blue Minimal

Our custom theme features:
- **Muted blue background** - Easy on the eyes
- **Pink active tab accent** - Clear visual focus
- **Catppuccin Surface1 text** - Perfect contrast and readability
- **Simplified UI** - Clean, professional appearance

### Theme Components

```kdl
themes {
  catppuccin-blue-minimal {
    // Status bar: muted blue with dark text
    ribbon_unselected { base 69 71 90; background 90 120 180 }
    // Active tab: pink with dark text  
    ribbon_selected { base 69 71 90; background 245 194 231 }
    // Maintains full Catppuccin color palette
  }
}
```

### Alternative Themes

| Theme | Description |
|-------|-------------|
| `catppuccin-mocha-dark` | Very dark status bar |
| `terminal-match` | Matches terminal background |
| `transparent-mocha` | Minimal dark theme |

## Vim Integration

### Zellij Navigator Plugin

Replaces vim-tmux-navigator with seamless zellij integration:

**Neovim Configuration**:
```lua
-- dot_config/nvim/lua/plugins/utilities/zellij-navigator.lua
return {
  "hiasr/vim-zellij-navigator",
  lazy = false,
  keys = {
    { "<c-h>", "<cmd>ZellijNavigateLeft<cr>" },
    { "<c-j>", "<cmd>ZellijNavigateDown<cr>" },
    { "<c-k>", "<cmd>ZellijNavigateUp<cr>" },
    { "<c-l>", "<cmd>ZellijNavigateRight<cr>" },
  },
}
```

**Benefits**:
- **Seamless navigation** between vim splits and zellij panes
- **Same key bindings** as vim-tmux-navigator
- **No configuration needed** - works automatically
- **Bi-directional** - works from both vim and zellij

## Tmux vs Zellij Comparison

### Feature Parity

| Feature | tmux | Zellij | Notes |
|---------|------|--------|-------|
| **Session Management** | SessionX plugin | Built-in + fuzzy finder | Zellij has better UX |
| **Pane Splitting** | `prefix + v/s` | `Ctrl+a + v/s` | Identical bindings |
| **Window Navigation** | `prefix + h/j/k/l` | `Ctrl+a + h/j/k/l` | Same experience |
| **Vim Integration** | vim-tmux-navigator | vim-zellij-navigator | Seamless in both |
| **Theming** | Limited | Full UI theming | Zellij much more flexible |
| **Configuration** | Manual setup | Hot reloading | Zellij more developer-friendly |
| **Floating Panes** | Not built-in | Native support | Zellij advantage |
| **Plugin System** | Limited | WebAssembly plugins | Zellij more extensible |

### Migration Benefits

**What You Keep**:
- **Same muscle memory** - all key bindings preserved
- **Same workflow** - sessions, windows, panes work identically  
- **Same vim integration** - transparent navigation
- **Same aliases** - `ta`, `tn`, `tl`, etc. all work

**What You Gain**:
- **Better session manager** - fuzzy finding, previews, smart defaults
- **Beautiful themes** - proper color schemes and visual polish
- **Hot configuration reload** - no restart needed for changes
- **Modern plugin system** - WebAssembly based extensibility
- **Better documentation** - comprehensive help system
- **Improved stability** - memory safe Rust implementation

## Configuration Files

### Primary Configuration

```
~/.config/zellij/
├── config.kdl                           # Main configuration
├── layouts/                             # Layout definitions
│   ├── tmux-like.kdl                   # Default layout  
│   ├── bottom-status.kdl               # Status bar on bottom
│   ├── minimal.kdl                     # Minimal interface
│   ├── chezmoi.kdl                     # Dotfiles workflow
│   └── chezmoi-nvim.kdl                # Advanced editing
├── themes/                             # Color schemes
│   ├── catppuccin-blue-minimal.kdl     # Current theme
│   ├── custom.kdl                      # Alternative themes
│   └── transparent.kdl                 # Minimal options
├── scripts/                            # Utility scripts
│   └── zellij-sessionx                 # Session manager
└── zellij-functions.zsh                # Shell integration
```

### Key Configuration Options

```kdl
// Core settings for optimal experience
simplified_ui true                       # Clean appearance
pane_frames false                       # No pane borders  
theme "catppuccin-blue-minimal"         # Beautiful theme
default_layout "tmux-like"              # Familiar layout

// Hide session names for cleaner look
ui {
    pane_frames {
        rounded_corners false
        hide_session_name true
    }
}
```

## Troubleshooting

### Common Issues

**Zellij won't start**:
```bash
zellij setup --check    # Verify configuration
zellij --clean          # Start without config
```

**Key bindings not working**:
- Check if you're in locked mode (`Ctrl+g` to toggle)
- Verify vim navigator plugin is loaded
- Restart zellij session

**Theme not applying**:
- Configuration hot-reloads automatically
- Check theme file syntax with `zellij setup --check`
- Verify theme name matches file

**Session manager issues**:
- Ensure fzf is installed: `brew install fzf`
- Check script permissions: `chmod +x ~/.config/zellij/scripts/zellij-sessionx`
- Verify zoxide is available: `mise install zoxide`

### Performance Tips

- **Use session serialization** for persistence across reboots
- **Limit scrollback** if memory usage is high
- **Use simplified_ui** for better performance on slower terminals
- **Disable mouse mode** if experiencing issues

## Advanced Usage

### Custom Layouts

Create your own layouts in `~/.config/zellij/layouts/`:

```kdl
layout {
    default_tab_template {
        pane size=1 borderless=true {
            plugin location="zellij:tab-bar"
        }
        children
    }
    tab name="main" {
        pane split_direction="vertical" {
            pane size="70%"
            pane split_direction="horizontal" {
                pane command="htop"  
                pane command="git" { args "status" }
            }
        }
    }
}
```

### Custom Themes

Extend theming by creating new files in `~/.config/zellij/themes/`:

```kdl
themes {
  my-theme {
    ribbon_unselected { base 255 255 255; background 50 50 50 }
    ribbon_selected { base 0 0 0; background 100 200 255 }
    // ... other components
  }
}
```

### Shell Integration

Add to your `.zshrc` for enhanced functionality:

```bash
# Source zellij functions
source ~/.config/zellij/zellij-functions.zsh

# Auto-attach to sessions
export ZELLIJ_AUTO_ATTACH=true

# Custom session creation
function dev() {
    zellij attach "$1" || zellij --session "$1" --layout chezmoi
}
```

## Migration Checklist

From tmux to Zellij:

- [ ] Install zellij via mise/homebrew
- [ ] Apply dotfiles configuration  
- [ ] Test basic session creation (`z`)
- [ ] Verify vim navigation (`Ctrl+h/j/k/l`)
- [ ] Test tmux-style bindings (`Ctrl+a`)
- [ ] Configure shell aliases
- [ ] Update terminal profiles if needed
- [ ] Train muscle memory with new session manager

**Result**: Complete tmux functionality with modern improvements and better user experience.