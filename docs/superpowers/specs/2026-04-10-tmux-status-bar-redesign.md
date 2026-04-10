# Tmux Status Bar Redesign

## Context

The user is adopting tmux sessions as a core part of their workflow (adding `Prefix + D` for a dedicated dotfiles session via sesh). The current status bar doesn't surface session information — it only shows the active session name blended into the window list. This redesign makes sessions a first-class element and restructures the bar into three clear zones.

## Design

### Layout: Three-zone status bar

```
SESSIONS (left)          DATE/TIME (center)          WINDOWS (right)
grows →                   anchored                          ← grows
```

- **Left zone** — all tmux sessions, separated by `·`, active session in red/bold, inactive in muted color
- **Center zone** — date and time, anchored
- **Right zone** — all windows in the active session, active window in blue/bold, inactive in muted color

### Visual examples

**Normal (3 sessions, 2 windows):**
```
dotfiles · ghostty · config       Thu Apr 10 09:26       0:data-mining  1:chezmoi
 (muted)   (red)    (muted)          (muted)               (muted)      (blue)
```

**Busy (5 sessions, 4 windows):**
```
dotfiles · ghostty · config · popsicle · console    Thu Apr 10 09:26    0:data-mining 1:nvim 2:chezmoi 3:tests
```

**Minimal (1 session, 1 window):**
```
ghostty                             Thu Apr 10 09:26                          0:chezmoi
```

### Color mapping (catppuccin theme variables)

| Element | Color | Variable |
|---------|-------|----------|
| Active session | red, bold | `#{@thm_red}` |
| Inactive session | overlay_0 | `#{@thm_overlay_0}` |
| Session separator `·` | surface_1 | `#{@thm_surface_1}` |
| Active window | blue, bold | `#{@thm_blue}` |
| Inactive window | overlay_0 | `#{@thm_overlay_0}` |
| Date/time | overlay_1 | `#{@thm_overlay_1}` |
| Prefix active indicator | peach, bold | `#{@thm_peach}` |

### Prefix key indicator

When prefix (`Ctrl-a`) is pressed, the active session name changes from red to peach. This provides visual feedback without adding clutter.

```
# Normal
dotfiles · ghostty · config
            (red)

# Prefix active
dotfiles · ghostty · config
           (peach)
```

### Aesthetic

- **Flat/minimal** — no pills, no powerline arrows, no background fills
- **Transparent background** — `@catppuccin_status_background "none"` (unchanged)
- **No emoji** — the `👨🏽‍💻` prefix is removed
- **No window status style** — `@catppuccin_window_status_style "none"` (unchanged)

## Implementation approach

### Session list (left zone)

The built-in tmux `#S` only shows the current session. To list all sessions, use a shell command:

```tmux
#(tmux list-sessions -F '#{session_name}' | ...)
```

A small script or inline shell formats each session name with the appropriate color, highlighting the active session (matched against `#S`) in red and others in the muted color.

### Centered date/time

Tmux's status bar has three areas: `status-left`, window list (center), and `status-right`. To achieve sessions | time | windows:

- **Option A** — Repurpose the window list area for date/time by setting `window-status-current-format` to the time string and `window-status-format` to empty. Use `status-justify centre`. Build the actual window list manually in `status-right`.
- **Option B** — Use a helper script that pads the time string to center it in `status-right` or `status-left`.

Option A is cleaner — it uses tmux's native centering. The actual window list moves to `status-right` using `#{W:format,current_format}` (tmux 3.3+).

### Window list (right zone)

Use `#{W:format,current_format}` in `status-right` to iterate over windows:
- Non-current windows: muted color, `#I:#W` format
- Current window: blue/bold, `#I:#W` format

Windows naturally grow leftward (toward center) since `status-right` is right-aligned.

## Files to modify

| File | Change |
|------|--------|
| `dot_config/tmux/tmux.theme.catppuccin.conf.tmpl` | Replace entire left/right status and window format config |
| `dot_config/tmux/tmux.status.conf` | Potentially adjust status-justify and related settings |

## Files NOT modified

- `dot_config/tmux/tmux.keybindings.conf` — already has the `Prefix + D` binding from earlier
- `dot_config/tmux/tmux.conf` — no structural changes needed

## Verification

1. `chezmoi apply --dry-run` — validate templates
2. `chezmoi apply --force` — apply
3. `tmux source-file ~/.config/tmux/tmux.conf` — reload
4. Visual checks:
   - [ ] Sessions listed on the left, active in red, inactive muted
   - [ ] Date/time centered
   - [ ] Windows listed on the right, active in blue, inactive muted
   - [ ] Pressing prefix changes active session color to peach
   - [ ] Opening a new window grows the right zone toward center
   - [ ] Creating a new session grows the left zone toward center
   - [ ] Single session / single window case looks clean
