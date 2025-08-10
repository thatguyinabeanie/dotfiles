# SketchyBar Disable Strategy

## Overview

This document outlines the comprehensive strategy for implementing a clean disable/enable toggle for SketchyBar in the dotfiles configuration. When SketchyBar is disabled, the system should gracefully fall back to the native macOS menu bar without leaving any orphaned processes or incorrect system defaults.

## Current SketchyBar Dependencies

### Files and Services
- **Configuration**: `dot_config/sketchybar/` (50+ files - Lua configs, scripts, helpers, plugins)
- **Package**: `sketchybar` in `.chezmoidata/packages/macos/brews.yaml:123`
- **Font**: `Library/fonts/sketchybar-app-font.ttf`
- **Settings**: `.chezmoidata/apps/sketchybar.yaml` (scale, height, fonts, padding)
- **Setup Script**: `.chezmoiscripts/macos/run_once_after_900-setup-sketchybar.sh.tmpl`
- **Service**: Managed via `brew services` in `.chezmoidata/packages/macos/services.yaml:16-19`

### SbarLua Plugin
- **Installation**: Cloned from GitHub and built in setup script
- **Runtime**: Runs inside SketchyBar process (not separate service)
- **Dependencies**: Lua module path configured in `dot_config/sketchybar/helpers/init.lua`
- **Lifecycle**: Automatically stops when SketchyBar stops

### macOS System Defaults
- **Menu Bar Hiding**: `defaults write NSGlobalDomain _HIHideMenuBar -bool true`
- **Service Management**: Conditional restart logic in defaults script
- **System UI**: Requires `killall SystemUIServer` to apply changes

## Implementation Strategy

### 1. Environment Variable Control

**Add to `.chezmoidata/environment/personal.yaml`:**
```yaml
ENABLE_SKETCHYBAR: true  # Default to enabled
```

**Purpose:**
- Single source of truth for SketchyBar enable/disable state
- Accessible across all scripts and templates
- Easy to toggle by changing one value

### 2. Package Management Updates

**Modify `.chezmoidata/packages/macos/brews.yaml`:**
```yaml
# Current:
- sketchybar

# Updated:
{{- if .environment.ENABLE_SKETCHYBAR }}
- sketchybar
{{- end }}
```

**Result:**
- SketchyBar only installed when enabled
- Clean package list when disabled

### 3. Service Management Updates

**Modify `.chezmoidata/packages/macos/services.yaml`:**
```yaml
- name: "sketchybar"
  description: "Custom macOS menu bar"
  {{- if .environment.ENABLE_SKETCHYBAR }}
  action: "restart"
  enable: "ifInstalled"
  {{- else }}
  action: "stop"
  enable: "false"
  {{- end }}
```

**Result:**
- When enabled: restart service if installed
- When disabled: stop service and prevent startup

### 4. macOS Defaults Script Updates

**Modify `.chezmoiscripts/macos/run_onchange_after-100-configure-macos-defaults.sh.tmpl`:**

**Current Logic (lines 112-120):**
```bash
if command -v sketchybar >/dev/null 2>&1; then
  defaults write NSGlobalDomain _HIHideMenuBar -bool true
else
  echo "⚠️  SketchyBar not found - keeping default macOS menu bar visible"
fi
```

**Updated Logic:**
```bash
{{- if .environment.ENABLE_SKETCHYBAR }}
if command -v sketchybar >/dev/null 2>&1; then
  echo "🔧 SketchyBar enabled - hiding default macOS menu bar..."
  defaults write NSGlobalDomain _HIHideMenuBar -bool true
else
  echo "⚠️  SketchyBar not installed - keeping default macOS menu bar visible"
fi
{{- else }}
echo "🔧 SketchyBar disabled - showing default macOS menu bar..."
defaults write NSGlobalDomain _HIHideMenuBar -bool false
# Stop SketchyBar service if running
if command -v brew >/dev/null 2>&1; then
  brew services stop sketchybar 2>/dev/null || true
fi
{{- end }}
```

**Service Restart Logic (lines 178-182):**
```bash
{{- if .environment.ENABLE_SKETCHYBAR }}
if command -v sketchybar >/dev/null 2>&1 && pgrep -f sketchybar >/dev/null 2>&1; then
  echo "🔄 Restarting SketchyBar to apply menu bar changes..."
  brew services restart sketchybar 2>/dev/null || true
fi
{{- else }}
# Ensure SketchyBar is stopped when disabled
if pgrep -f sketchybar >/dev/null 2>&1; then
  echo "🛑 Stopping SketchyBar (disabled)..."
  brew services stop sketchybar 2>/dev/null || true
fi
{{- end }}
```

### 5. Setup Script Updates

**Modify `.chezmoiscripts/macos/run_once_after_900-setup-sketchybar.sh.tmpl`:**

**Add environment check at the top:**
```bash
{{- if not .environment.ENABLE_SKETCHYBAR }}
echo "ℹ️  SketchyBar is disabled - skipping setup"
exit 0
{{- end }}

# Existing script content continues...
```

**Result:**
- Script only runs when SketchyBar is enabled
- Clean exit when disabled

### 6. Configuration File Handling

**Strategy: Keep files, prevent execution**
- **Don't use `.chezmoiignore`** - this would delete existing configs
- **Keep all config files in place** - allows easy re-enabling
- **Rely on service management** - disabled service = configs won't execute

**Rationale:**
- Users may want to toggle SketchyBar on/off
- Deleting configs would lose customizations
- Service-level control is cleaner

## Testing Strategy

### Enable/Disable Test Cases

**Test 1: Fresh Install with SketchyBar Enabled**
1. Set `ENABLE_SKETCHYBAR: true`
2. Run `chezmoi apply`
3. Verify: SketchyBar installed, running, native menu bar hidden

**Test 2: Fresh Install with SketchyBar Disabled**
1. Set `ENABLE_SKETCHYBAR: false`
2. Run `chezmoi apply`
3. Verify: SketchyBar not installed, native menu bar visible

**Test 3: Disable SketchyBar (from enabled state)**
1. Start with SketchyBar enabled and running
2. Set `ENABLE_SKETCHYBAR: false`
3. Run `chezmoi apply`
4. Verify: SketchyBar stopped, native menu bar restored, configs preserved

**Test 4: Re-enable SketchyBar**
1. Start with SketchyBar disabled
2. Set `ENABLE_SKETCHYBAR: true`
3. Run `chezmoi apply`
4. Verify: SketchyBar installed, running, configs loaded, native menu bar hidden

### System State Verification

**When SketchyBar Enabled:**
- `brew list | grep sketchybar` → package present
- `brew services list | grep sketchybar` → running
- `defaults read NSGlobalDomain _HIHideMenuBar` → 1 (true)
- `pgrep -f sketchybar` → process running

**When SketchyBar Disabled:**
- `brew list | grep sketchybar` → no output (package not installed)
- `brew services list | grep sketchybar` → stopped or not listed
- `defaults read NSGlobalDomain _HIHideMenuBar` → 0 (false)
- `pgrep -f sketchybar` → no processes

## Implementation Order

### Phase 1: Environment Setup
1. Add `ENABLE_SKETCHYBAR` to environment data
2. Update package management templates
3. Test package installation/removal

### Phase 2: Service Management
1. Update brew services configuration
2. Update setup script with environment check
3. Test service start/stop behavior

### Phase 3: System Defaults
1. Update macOS defaults script with conditional logic
2. Add menu bar show/hide logic
3. Test system UI changes

### Phase 4: Integration Testing
1. Test complete enable/disable cycles
2. Verify clean state transitions
3. Test edge cases (partial installs, interrupted processes)

## Edge Cases and Considerations

### Partial Installation States
- **SketchyBar installed but disabled**: Service should be stopped, menu bar shown
- **SketchyBar configs present but package removed**: Configs remain but can't execute
- **Service running but package removed**: Service should fail gracefully

### System UI Timing
- Always restart SystemUIServer after menu bar changes
- Allow time for UI refresh before checking states
- Handle cases where UI restart fails

### User Experience
- Provide clear feedback about enable/disable actions
- Preserve user customizations when toggling
- Make re-enabling as smooth as initial setup

### Rollback Strategy
- If disable fails, attempt to restore SketchyBar state
- If enable fails, ensure native menu bar is restored
- Provide manual recovery instructions in case of failures

## Success Criteria

1. **Clean Transitions**: Enabling/disabling should be seamless without manual intervention
2. **State Consistency**: System state should always match the enable/disable setting
3. **Configuration Preservation**: User customizations should survive disable/enable cycles
4. **Performance**: Transition should be fast (under 10 seconds)
5. **Reliability**: Should work consistently across different macOS versions and system states

## Future Enhancements

### Dynamic Toggle
- Add shell function/alias to toggle SketchyBar state
- Real-time enable/disable without full chezmoi apply

### Status Checking
- Add command to check current SketchyBar state
- Detect and report configuration drift

### Backup/Restore
- Backup custom configurations before major changes
- Provide restore points for complex setups