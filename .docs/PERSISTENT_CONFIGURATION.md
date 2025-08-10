# Persistent Configuration System

The chezmoi dotfiles repository now includes a **persistent configuration system** that provides durable storage for configuration values across system reinstalls and config file deletions.

## Overview

The system provides three-tier configuration precedence:

1. **Environment Variables** (highest priority) - `export SHELL_PREF=zsh`
2. **Persistent Storage** (middle priority) - macOS defaults, Linux dconf/gsettings
3. **Template Defaults** (fallback) - hardcoded in `.chezmoi.toml.tmpl`

This ensures configuration values persist even when `~/.config/chezmoi/chezmoi.toml` is deleted or when setting up on a new machine.

## Architecture

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│ Environment     │───▶│ Persistent       │───▶│ Template        │
│ Variables       │    │ Storage          │    │ Defaults        │
│ (SHELL_PREF)    │    │ (macOS defaults) │    │ ("nu")          │
└─────────────────┘    └──────────────────┘    └─────────────────┘
```

## Components

### 1. Enhanced Template (`.chezmoi.toml.tmpl`)

The template now reads from persistent storage:

```go-template
SHELL = {{ (env "SHELL_PREF") | default (output "bash" "-c" "config-helpers.sh read shell_pref") | default "nu" | quote }}
```

**Precedence flow:**
- Check `SHELL_PREF` environment variable
- If empty, check persistent storage for `shell_pref`
- If empty, use template default `"nu"`

### 2. Backup System (`chezmoi-backup-config`)

Saves current `~/.config/chezmoi/chezmoi.toml` values to persistent storage:

```bash
# Backup current configuration
chezmoi-backup-config

# View stored values  
config-persistence-helpers.sh list
```

**What gets backed up:**
- Core preferences (shell, work environment, etc.)
- Theme configuration (mode, light/dark themes)
- UI settings (font, opacity, window size)
- Git configuration (name, email, username)
- Application settings

### 3. Recovery System (`chezmoi-restore-config`)

Restores configuration from persistent storage:

```bash
# Restore configuration from backup
chezmoi-restore-config

# Apply restored configuration
chezmoi apply
```

**Safety features:**
- Backs up existing config before restoration
- Reports missing values (will use template defaults)
- Adds restore metadata to generated file

### 4. Storage Helpers (`config-persistence-helpers.sh`)

Low-level interface for persistent storage:

```bash
# Read/write individual values
config-persistence-helpers.sh write shell_pref zsh
config-persistence-helpers.sh read shell_pref

# Manage storage
config-persistence-helpers.sh list     # View all values
config-persistence-helpers.sh clear    # Clear all values
config-persistence-helpers.sh detect   # Show storage method
```

## Storage Methods

### macOS (Primary)
- **Method**: `defaults` command
- **Domain**: `com.chezmoi.config`
- **Location**: `~/Library/Preferences/com.chezmoi.config.plist`
- **Features**: Type-aware (string, boolean, integer)

### Linux (Cross-platform ready)
- **dconf**: `/com/chezmoi/config/` keys
- **gsettings**: `com.chezmoi.config` schema
- **XDG config**: `~/.config/chezmoi/persistent-config` file

## Usage Workflows

### Normal Configuration Editing

1. Edit `~/.config/chezmoi/chezmoi.toml` directly
2. Run `chezmoi apply` to apply changes
3. Run `chezmoi-backup-config` to save to persistent storage

### Recovery After Config Loss

1. Run `chezmoi-restore-config` to restore from persistent storage
2. Run `chezmoi apply` to apply restored configuration
3. Edit restored config as needed

### Fresh System Setup

1. Run `chezmoi init` - template uses persistent values if available
2. Values automatically restored from previous machine's defaults
3. Missing values use sensible template defaults

### Environment Override

```bash
# Temporarily override stored preference
SHELL_PREF=zsh chezmoi apply

# Permanently change preference
export SHELL_PREF=zsh
chezmoi apply
chezmoi-backup-config  # Save the change
```

## Configuration Values

### Core Preferences
- `hostname` - System hostname
- `shell_pref` - Preferred shell (nu, zsh, bash)
- `work_environment` - Work environment flag
- `personal_environment` - Personal environment flag
- `install_sketchy_bar` - Install SketchyBar
- `manage_brew_services` - Manage Homebrew services
- `catppuccin_flavor` - Catppuccin theme flavor

### Theme System
- `theme_mode` - Current theme mode (dark/light)
- `theme_light` - Light theme name
- `theme_dark` - Dark theme name

### UI Configuration
- `ui_opacity` - Terminal opacity
- `ui_blur` - Blur amount
- `ui_font_size` - Font size
- `ui_font_family` - Font family
- `ui_window_height` - Window height
- `ui_window_width` - Window width
- `ui_font_thicken` - Font thickening
- `ui_cursor_style` - Cursor style

### Git Configuration
- `git_name` - Git user name
- `github_username` - GitHub username
- `git_email` - Git email
- `git_refresh_period` - Default refresh period
- `work_org` - Work organization
- `git_work_environment` - Git work environment flag

### Application Settings
- `yazi_catppuccin_color` - Yazi theme color
- `sudo_touchid` - TouchID for sudo

## Integration Points

### Chezmoi Template System
- `.chezmoi.toml.tmpl` enhanced with persistent storage lookups
- Maintains backward compatibility with environment variables
- Graceful fallback to template defaults

### Shell Environment
- Environment variables take highest precedence
- Can be used for temporary overrides
- Permanent changes should be backed up

### Cross-Platform Support
- Platform detection in storage helpers
- Consistent API across operating systems
- Graceful degradation to file-based storage

## Troubleshooting

### View Current Configuration
```bash
# Check what template will generate
chezmoi execute-template < .chezmoi.toml.tmpl

# View stored values
config-persistence-helpers.sh list

# Check storage method
config-persistence-helpers.sh detect
```

### Reset Configuration
```bash
# Clear all persistent storage
config-persistence-helpers.sh clear

# Will use template defaults on next chezmoi init
chezmoi init
```

### Backup/Restore Issues
```bash
# Force backup even if config seems missing
chezmoi-backup-config

# Restore with existing config (creates backup)
chezmoi-restore-config

# Check backup metadata
config-persistence-helpers.sh read backup_date
```

## Migration from Previous System

The persistent configuration system is fully backward compatible:

1. **Existing configs continue working** - no migration required
2. **Environment variables still work** - highest precedence maintained
3. **Template defaults unchanged** - same fallback behavior
4. **New feature is opt-in** - run `chezmoi-backup-config` to start using

## Security Considerations

- **No secrets stored** - only configuration preferences
- **Platform-appropriate storage** - uses OS-native secure storage
- **User-scoped** - values only accessible to current user
- **Transparent operation** - all operations logged and reversible

## Future Enhancements

- **Automatic backup hooks** - backup after every `chezmoi apply`
- **Cross-machine sync** - sync settings between machines
- **Web interface** - GUI for configuration management
- **Validation** - schema validation for configuration values