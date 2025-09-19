# AGENTS-ghostty.md

## Overview

Ghostty is a modern, fast terminal emulator built for performance and developer productivity. This configuration emphasizes true color support, optimal font rendering, seamless tmux integration, and dynamic theming that adapts to system appearance.

## Configuration Philosophy

### Design Principles
- **Performance first**: Fast rendering with minimal resource usage
- **Developer-focused**: Optimized for coding workflows and terminal applications
- **Aesthetic integration**: Consistent theming with system and other tools
- **Modern terminal features**: True color, undercurl, and advanced text rendering
- **Minimal configuration**: Sensible defaults with targeted customizations

### Core Features
- **True color support**: Full RGB color rendering for modern applications
- **Dynamic theming**: Automatic light/dark mode switching with Catppuccin
- **Font optimization**: Carefully tuned font settings for code readability
- **Tmux integration**: Specialized keybindings and startup behavior
- **macOS integration**: Native behaviors and appearance settings

## Configuration Structure

### **Main Configuration**: `config.tmpl`
- **Window settings**: Size, opacity, and layout configuration
- **Startup behavior**: Automatic tmux session management
- **Theme integration**: Dynamic theme switching based on system settings
- **Font configuration**: Typography settings optimized for development
- **Custom keybindings**: Strategic tmux integration shortcuts

### **Initialization Scripts**:
- **`ghostty-init.nu`**: Nushell startup script for tmux attachment
- **`ghostty-init.zsh`**: Zsh startup script for tmux attachment
- **`ghostty-tmux.zsh`**: Specialized tmux session management

## Window and Display Settings

### **Window Configuration**
```toml
window-height = {{ .ui.window_height }}      # Dynamic height from chezmoi data
window-width = {{ .ui.window_width }}        # Dynamic width from chezmoi data
background-opacity = {{ .ui.opacity }}       # Configurable transparency
background-blur = {{ .ui.blur }}             # Background blur amount
window-padding-y = 4                         # Vertical padding for content
quit-after-last-window-closed = true         # Clean shutdown behavior
```

### **Display Features**
- **Opacity control**: Configurable background transparency
- **Blur effects**: Subtle background blur for visual depth
- **Padding management**: Consistent spacing around terminal content
- **Auto-shutdown**: Graceful application termination

## Font and Typography

### **Font Configuration**
```toml
font-family = {{ .ui.font_family }}          # Primary font (typically DankMono)
font-thicken = {{ .ui.font_thicken }}         # Font weight adjustment
font-size = {{ .ui.font_size }}              # Optimal size for development
```

### **Typography Features**
- **DankMono integration**: Optimized for this premium coding font
- **Dynamic sizing**: Configurable through chezmoi data
- **Weight adjustment**: Fine-tuned font thickness
- **Code optimization**: Designed for extended coding sessions

## Cursor and Input

### **Cursor Configuration**
```toml
cursor-style = {{ .ui.cursor_style }}        # Cursor appearance (block, beam, underline)
cursor-style-blink = {{ .ui.cursor_blink }}  # Blinking behavior
```

### **Input Features**
- **Responsive cursor**: Fast cursor movement and rendering
- **Visual feedback**: Clear cursor visibility in all themes
- **Configurable behavior**: Customizable cursor styles and blinking

## Theme Integration

### **Dynamic Theme System**
The configuration supports sophisticated theme switching based on system appearance:

```toml
{{ if eq .THEME_MODE "system" -}}
theme = light:{{ .THEME_LIGHT }},dark:{{ .THEME_DARK }}
{{ else if eq .THEME_MODE "dark" -}}
theme = {{ .THEME_DARK }}
{{ else if eq .THEME_MODE "light" -}}
theme = {{ .THEME_LIGHT }}
{{ end -}}
```

### **Theme Features**
- **System integration**: Automatically follows macOS light/dark mode
- **Manual override**: Can be locked to specific theme mode
- **Catppuccin variants**: Supports multiple Catppuccin flavors
- **Consistent theming**: Matches tmux, Neovim, and system themes

### **Available Themes**
- **Light mode**: Catppuccin Latte or similar light variants
- **Dark mode**: Catppuccin Mocha or similar dark variants
- **Adaptive switching**: Seamless transitions between modes

## macOS Integration

### **Platform-Specific Settings**
```toml
mouse-hide-while-typing = true               # Hide cursor during typing
macos-option-as-alt = true                   # Option key behaves as Alt
macos-titlebar-style = hidden                # Clean, minimal titlebar
```

### **macOS Features**
- **Native behaviors**: Follows macOS conventions and expectations
- **Keyboard optimization**: Proper Alt/Option key handling
- **Visual integration**: Matches macOS design language
- **Performance tuning**: Optimized for macOS rendering pipeline

## Tmux Integration

### **Startup Behavior**
The terminal automatically launches with tmux integration:

```toml
{{ if and (hasKey . "SHELL") (eq .SHELL "nu") -}}
initial-command = ~/.config/ghostty/ghostty-init.nu
{{ else -}}
initial-command = ~/.config/ghostty/ghostty-init.zsh
{{ end -}}
```

### **Custom Keybindings**
| Keybinding | Action | Description |
|------------|--------|-------------|
| `Super+Ctrl+w` | Close tmux window | Sends `Ctrl+a X` to close tmux window |

### **Integration Features**
- **Automatic session attachment**: Connects to 'ghostty' tmux session or creates new
- **Shell awareness**: Different startup scripts for Nushell and Zsh
- **Tmux-optimized**: Keybindings designed to work seamlessly with tmux prefix
- **Session management**: Intelligent handling of tmux sessions and windows

## Startup Scripts

### **Nushell Integration** (`ghostty-init.nu`)
- Attaches to existing 'ghostty' tmux session
- Creates new session if none exists
- Optimized for Nushell environment
- Handles session persistence

### **Zsh Integration** (`ghostty-init.zsh`)
- Compatible with Zsh shell environment
- Tmux session management
- Environment variable handling
- Graceful fallback behavior

### **Session Management**
- **Session persistence**: Tmux sessions survive terminal restarts
- **Intelligent attachment**: Smart session discovery and connection
- **Multi-window support**: Proper handling of multiple terminal windows
- **Clean initialization**: Fast startup with minimal overhead

## Advanced Terminal Features

### **Modern Terminal Capabilities**
```toml
shell-integration-features = true            # Enhanced shell integration
auto-update = download                        # Automatic updates
app-notifications = true                     # System notification support
```

### **Color and Rendering**
- **True color support**: Full 24-bit color rendering
- **Advanced text rendering**: Proper handling of ligatures and special characters
- **Performance optimization**: Efficient rendering pipeline
- **Compatibility**: Works with modern terminal applications and tools

## Performance Characteristics

### **Speed and Efficiency**
- **Fast startup**: Quick terminal window creation
- **Efficient rendering**: Optimized text and color rendering
- **Low resource usage**: Minimal CPU and memory footprint
- **Responsive input**: Immediate response to keyboard and mouse input

### **Memory Management**
- **Efficient scrollback**: Smart buffer management
- **Garbage collection**: Automatic cleanup of unused resources
- **Session efficiency**: Optimal handling of long-running sessions

## Integration with Development Tools

### **Neovim Integration**
- **True color support**: Enables rich Neovim color schemes
- **Font rendering**: Optimal display of code and UI elements
- **Performance**: Fast rendering for large files and complex highlighting
- **Terminal mode**: Seamless embedded terminal experience

### **OpenCode Integration**
- **Session management**: Works well with OpenCode terminal sessions
- **Color support**: Rich color rendering for OpenCode output
- **Performance**: Handles intensive AI operations smoothly
- **Tmux compatibility**: Integrates with OpenCode tmux workflows

### **Command-Line Tools**
- **Color support**: Rich rendering for tools like `bat`, `exa`, `delta`
- **Unicode support**: Proper rendering of special characters and symbols
- **Performance**: Fast rendering of large command outputs
- **Integration**: Works seamlessly with modern CLI tools

## Customization Guidelines

### **Theme Customization**
1. **Color adjustments**: Modify theme variables in chezmoi data
2. **Opacity tuning**: Adjust transparency for visual preference
3. **Font modifications**: Change font family, size, or weight
4. **Cursor styling**: Customize cursor appearance and behavior

### **Window Behavior**
1. **Size adjustments**: Modify default window dimensions
2. **Padding changes**: Adjust internal spacing
3. **Startup behavior**: Customize initial commands and session handling
4. **Integration tweaks**: Fine-tune tmux and shell integration

### **Performance Tuning**
1. **Rendering optimization**: Adjust for specific hardware
2. **Memory limits**: Configure scrollback and buffer sizes
3. **Update behavior**: Control automatic update frequency
4. **Notification settings**: Manage system integration level

## Troubleshooting

### **Common Issues**

1. **Colors not displaying correctly**:
   - Verify true color support in applications
   - Check theme configuration and variables
   - Ensure proper terminal type setting

2. **Font rendering problems**:
   - Verify font installation and availability
   - Check font size and weight settings
   - Test with different font configurations

3. **Tmux integration issues**:
   - Verify tmux installation and configuration
   - Check startup script permissions
   - Test manual tmux attachment

4. **Theme switching problems**:
   - Verify system appearance detection
   - Check chezmoi template variables
   - Test manual theme switching

### **Performance Issues**

1. **Slow startup**:
   - Check startup script complexity
   - Verify tmux session state
   - Test without custom initialization

2. **Rendering lag**:
   - Adjust opacity and blur settings
   - Check system graphics performance
   - Test with minimal configuration

### **Integration Problems**

1. **Shell integration failures**:
   - Verify shell configuration
   - Check environment variables
   - Test with different shells

2. **Application compatibility**:
   - Test terminal type detection
   - Verify color support
   - Check escape sequence handling

## Best Practices

### **Configuration Management**
1. **Use chezmoi templates**: Leverage dynamic configuration
2. **Test changes**: Verify modifications before committing
3. **Backup settings**: Maintain configuration history
4. **Document customizations**: Record changes and rationale

### **Performance Optimization**
1. **Monitor resource usage**: Keep track of memory and CPU impact
2. **Optimize startup**: Minimize initialization overhead
3. **Efficient theming**: Use optimized color schemes
4. **Regular updates**: Keep Ghostty updated for performance improvements

### **Development Workflow**
1. **Consistent theming**: Maintain visual coherence across tools
2. **Optimal sizing**: Configure for comfortable long-term use
3. **Efficient navigation**: Use keyboard shortcuts and tmux integration
4. **Session management**: Organize work with proper tmux sessions

This Ghostty configuration provides a modern, efficient terminal experience that integrates seamlessly with the broader development environment while maintaining excellent performance and visual appeal.