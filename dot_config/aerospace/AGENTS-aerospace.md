# AGENTS-aerospace.md

## Overview

Aerospace is a tiling window manager for macOS that provides i3-like functionality with native macOS integration. This configuration emphasizes vim-inspired navigation, efficient workspace management, and seamless integration with development tools.

## Configuration Philosophy

### Design Principles
- **Vim-inspired navigation**: Consistent `hjkl` movement patterns
- **Modal operation**: Main mode for general use, service mode for advanced operations
- **Workspace efficiency**: Alphanumeric workspace system for quick switching
- **Developer-focused**: Optimized layouts for coding workflows
- **macOS integration**: Works harmoniously with native macOS features

### Window Management Strategy
- **Automatic tiling**: Windows tile automatically with smart orientation
- **Focus follows mouse**: Mouse movement updates monitor focus
- **Normalization**: Flatten containers and optimize layouts automatically
- **Gap management**: Consistent spacing between windows and screen edges

## Key Features

### 1. **Dual-Mode Operation**
- **Main Mode**: Day-to-day window and workspace management
- **Service Mode**: Advanced operations, window manipulation, and layout control

### 2. **Smart Layouts**
- **Tiles Layout**: Traditional tiling with automatic orientation
- **Accordion Layout**: Nested container management
- **Auto Orientation**: Wide monitors get horizontal, tall get vertical

### 3. **Workspace System**
- **Numbers (1-9)**: Primary workspaces for main activities
- **Letters (A-Z)**: Extended workspaces for specialized tasks
- **Focus-follows-movement**: Windows move with focus to new workspaces

## Keybinding Reference

### **Service Mode Activation**: `Alt+Ctrl+;`
Enter service mode for advanced window operations. All service mode commands automatically return to main mode.

### Main Mode Keybindings

#### **Workspace Navigation**
| Keybinding | Action | Description |
|------------|--------|-------------|
| `Alt+1-9` | Switch to workspace | Navigate to numbered workspace |
| `Alt+A-Z` | Switch to workspace | Navigate to lettered workspace |
| `Alt+Tab` | Workspace back-and-forth | Toggle between current and last workspace |
| `Alt+Shift+Tab` | Move workspace to monitor | Cycle workspace between monitors |

#### **Window Movement to Workspaces**
| Keybinding | Action | Description |
|------------|--------|-------------|
| `Alt+Shift+1-9` | Move window to workspace | Move and follow to numbered workspace |
| `Alt+Shift+A-Z` | Move window to workspace | Move and follow to lettered workspace |
| `Alt+Shift+X` | Move window to workspace X | Move to workspace X (no follow) |

#### **Layout Management**
| Keybinding | Action | Description |
|------------|--------|-------------|
| `Alt+/` | Toggle tiles layout | Switch between horizontal/vertical tiles |
| `Alt+,` | Toggle accordion layout | Switch between horizontal/vertical accordion |

#### **Window Resizing**
| Keybinding | Action | Description |
|------------|--------|-------------|
| `Alt+-` | Resize smart -50 | Decrease window size by 50 units |
| `Alt+=` | Resize smart +50 | Increase window size by 50 units |

### Service Mode Keybindings

#### **Mode Control**
| Keybinding | Action | Description |
|------------|--------|-------------|
| `Esc` | Exit service mode | Return to main mode and reload config |
| `r` | Reset layout | Flatten workspace tree and return to main |
| `f` | Toggle floating/tiling | Switch between floating and tiling layout |
| `Backspace` | Close all but current | Close all windows except focused |

#### **Window Focus Navigation**
| Keybinding | Action | Description |
|------------|--------|-------------|
| `h` | Focus left | Move focus to left window |
| `j` | Focus down | Move focus to down window |
| `k` | Focus up | Move focus to up window |
| `l` | Focus right | Move focus to right window |

#### **Window Movement**
| Keybinding | Action | Description |
|------------|--------|-------------|
| `Alt+h` | Move window left | Move focused window left |
| `Alt+j` | Move window down | Move focused window down |
| `Alt+k` | Move window up | Move focused window up |
| `Alt+l` | Move window right | Move focused window right |

#### **Window Joining**
| Keybinding | Action | Description |
|------------|--------|-------------|
| `Alt+Shift+h` | Join with left | Join focused window with left container |
| `Alt+Shift+j` | Join with down | Join focused window with down container |
| `Alt+Shift+k` | Join with up | Join focused window with up container |
| `Alt+Shift+l` | Join with right | Join focused window with right container |

## Workspace Organization Strategy

### **Numbered Workspaces (1-9)**
Primary workspaces for core development activities:

- **1**: Main editor (Neovim/IDE)
- **2**: Terminal and command-line tools
- **3**: Browser and documentation
- **4**: Communication (Slack, Discord, etc.)
- **5**: File management and system tools
- **6-9**: Project-specific or temporary workspaces

### **Lettered Workspaces (A-Z)**
Extended workspaces for specialized tasks:

- **A**: Admin and system configuration
- **B**: Background tasks and monitoring
- **C**: Creative tools (design, media)
- **D**: Database and data tools
- **E**: Email and calendar
- **G**: Git and version control interfaces
- **N**: Notes and documentation
- **O**: Overflow and temporary work
- **P**: Presentations and demos
- **Q**: Quality assurance and testing
- **R**: Research and reference materials
- **S**: Staging and development servers
- **T**: Time tracking and productivity
- **U**: Utilities and system tools
- **V**: Virtual machines and containers
- **W**: Web development and design
- **X**: Experimental and sandbox
- **Y**: Year-end and archival
- **Z**: Zen mode and distraction-free work

### **Disabled Workspaces**
Some workspaces are commented out to avoid conflicts:
- **F**: Conflicts with layout toggle
- **I**: Reserved for potential future use
- **M**: Reserved for potential future use

## Layout Management

### **Tiles Layout**
- **Horizontal**: Windows arranged side-by-side
- **Vertical**: Windows stacked top-to-bottom
- **Auto-orientation**: Based on monitor aspect ratio
- **Smart resizing**: Proportional window sizing

### **Accordion Layout**
- **Nested containers**: Hierarchical window organization
- **Focus-based expansion**: Focused container gets more space
- **Flexible grouping**: Windows can be grouped logically

### **Gap Configuration**
```toml
[gaps]
    inner.horizontal = 4    # Space between windows horizontally
    inner.vertical = 4      # Space between windows vertically
    outer.left = 6          # Space from left screen edge
    outer.bottom = 6        # Space from bottom screen edge
    outer.top = 8           # Space from top screen edge (menu bar)
    outer.right = 6         # Space from right screen edge
```

## Integration with Development Tools

### **Neovim Integration**
- **No keybinding conflicts**: AeroSpace uses Alt+ combinations, Neovim uses Space leader
- **Focus coordination**: Window focus works seamlessly with vim-tmux-navigator
- **Split awareness**: Neovim splits work within AeroSpace tiles

### **Tmux Integration**
- **Complementary navigation**: AeroSpace manages app windows, tmux manages terminal panes
- **Prefix separation**: Tmux uses `Ctrl+a`, AeroSpace uses `Alt+` combinations
- **Session isolation**: Each AeroSpace workspace can have dedicated tmux sessions

### **Terminal Integration (Ghostty)**
- **Window management**: Terminal windows tile automatically
- **Focus behavior**: Terminal focus integrates with window manager
- **Startup optimization**: Terminal launches quickly in assigned workspaces

### **Browser and Apps**
- **Automatic tiling**: Web browsers and apps tile with code editors
- **Workspace assignment**: Specific apps can be assigned to workspaces
- **Focus management**: Mouse follows focus between different app types

## Advanced Configuration

### **Normalization Features**
```toml
enable-normalization-flatten-containers = true
enable-normalization-opposite-orientation-for-nested-containers = true
```

- **Flatten containers**: Prevents unnecessary nesting
- **Opposite orientation**: Alternates horizontal/vertical for nested containers

### **macOS Integration**
```toml
automatically-unhide-macos-hidden-apps = true
on-focused-monitor-changed = ['move-mouse monitor-lazy-center']
```

- **Unhide apps**: Prevents accidental app hiding with Cmd+H
- **Mouse centering**: Cursor moves to center of focused monitor

### **Startup Configuration**
```toml
start-at-login = true
default-root-container-layout = 'tiles'
default-root-container-orientation = 'auto'
```

## Troubleshooting

### **Common Issues**

1. **Windows not tiling**: Check if app supports window management
2. **Keybindings not working**: Verify no conflicts with other apps
3. **Focus issues**: Restart AeroSpace or check mouse settings
4. **Layout problems**: Use service mode `r` to reset layout

### **Debugging Commands**

```bash
# Check AeroSpace status
aerospace list-windows

# Reload configuration
aerospace reload-config

# Check workspace assignments
aerospace list-workspaces

# Debug window hierarchy
aerospace debug
```

### **Configuration Validation**

```bash
# Test configuration syntax
aerospace --config-path ~/.aerospace.toml --dry-run

# Check for conflicts
aerospace --check-config
```

## Performance Optimization

### **Memory Usage**
- Minimal background processes
- Efficient window tracking
- Optimized focus management

### **Responsiveness**
- Fast workspace switching
- Immediate window operations
- Minimal animation delays

### **Startup Time**
- Quick launch at login
- Efficient workspace restoration
- Minimal initialization overhead

## Customization Guidelines

### **Adding New Workspaces**
1. Choose appropriate number/letter
2. Add to both navigation and movement sections
3. Document purpose in workspace strategy
4. Test for keybinding conflicts

### **Modifying Layouts**
1. Test changes in service mode first
2. Adjust gap settings for visual preference
3. Consider monitor size differences
4. Maintain consistency across workspaces

### **Integration with New Tools**
1. Check for keybinding conflicts
2. Test focus behavior
3. Consider workspace assignments
4. Document integration points

## Best Practices

### **Workspace Hygiene**
1. **Keep workspaces focused**: One primary task per workspace
2. **Use consistent layouts**: Maintain similar arrangements
3. **Regular cleanup**: Close unused windows and workspaces
4. **Logical grouping**: Group related apps and tools

### **Keybinding Discipline**
1. **Learn service mode**: Master advanced operations
2. **Use workspace shortcuts**: Develop muscle memory for numbers/letters
3. **Avoid mouse dependency**: Rely on keyboard navigation
4. **Practice focus movement**: Efficient window navigation

### **Development Workflow**
1. **Editor workspace**: Dedicated space for code editing
2. **Terminal workspace**: Command-line operations
3. **Reference workspace**: Documentation and browsers
4. **Communication workspace**: Team coordination tools

## OpenCode Integration Notes

### **Keybinding Compatibility**
- **No conflicts**: AeroSpace Alt+ keys don't interfere with OpenCode
- **Complementary navigation**: Window management works with OpenCode sessions
- **Focus awareness**: OpenCode sessions integrate with window focus

### **Workspace Strategy for OpenCode**
- **Dedicated workspace**: Consider workspace 2 or E for OpenCode sessions
- **Terminal integration**: Use with tmux for session management
- **Multi-monitor**: Spread OpenCode and supporting tools across workspaces

### **Recommended Setup**
1. **Workspace 1**: Neovim for editing
2. **Workspace 2**: OpenCode terminal sessions
3. **Workspace 3**: Browser for documentation
4. **Service mode**: Quick layout adjustments

This AeroSpace configuration provides efficient window management that enhances rather than interferes with development workflows, creating a seamless and productive environment for coding and system administration tasks.
