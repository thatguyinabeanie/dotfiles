# Herdr

**Terminal workspace manager**, configured for Herdr 0.9.0. Prefix: `Ctrl+a`.
Press and release the prefix, then press the following key. Uppercase letters mean Shift.

## Essential

| Key | Action |
|-----|--------|
| `Prefix + ?` | Built-in help with active keybindings |
| `Prefix + M` | Herdr cheatsheet (Neovim popup) |
| `Prefix + r` | Reload Herdr config |
| `Prefix + ,` | Settings |
| `Prefix + Ctrl+d` | Detach client |
| `Prefix + s` / `Prefix + S` | Workspace picker |
| `Prefix + w` | Session navigator |
| `Prefix + Alt+g` | New worktree |
| `Prefix + Alt+n` | New workspace |

## Tabs

| Key | Action |
|-----|--------|
| `Prefix + c` | New tab |
| `Prefix + n` / `Prefix + p` | Next / previous tab in tab order |
| `Prefix + 1..9` | Select tab by number |
| `Prefix + R` | Rename tab |
| `Prefix + &` | Close tab |
| `Ctrl+Shift+p` / `Ctrl+Shift+n` | Move tab earlier / later (no prefix) |

## Panes

| Key | Action |
|-----|--------|
| `Prefix + \` / `Prefix + \|` | Split current pane to the right |
| `Prefix + "` | Split current pane downward |
| `Prefix + h/j/k/l` | Focus Herdr pane left / down / up / right |
| `Ctrl+h/j/k/l` | Neovim-aware navigation (no prefix; see below) |
| `Prefix + X` | Close pane |
| `Prefix + x` / `Prefix + Alt+j` | Swap pane down |
| `Prefix + Alt+h/k/l` | Swap pane left / up / right |
| `Prefix + Alt+r` | Enter resize mode |
| `Prefix + z` | Toggle pane zoom |
| `Prefix + [` | Enter copy mode |
| `Prefix + Alt+e` | Edit scrollback in `$EDITOR` |

## Popups

| Key | Action | Size |
|-----|--------|------|
| `Prefix + g` | LazyGit | 85% |
| `Prefix + d` | LazyDocker | 85% |
| `Prefix + G` | Git cheatsheet in Neovim | 85% |
| `Prefix + C` | All cheatsheets directory in Neovim | 85% |
| `Prefix + M` | This cheatsheet in Neovim | 85% |
| `Prefix + e` | Edit `~/mise.toml`; set permissions to 600 after successful editor exit | 85% |
| `Prefix + N` | Existing `note-capture` command | 80% |

Size applies to both width and height. Popups receive all terminal input, including
Escape, until their command exits. Exit the application to return to the tiled panes.

## Neovim-aware navigation

- Herdr's direct `Ctrl+h/j/k/l` bindings invoke the upstream `navigate.sh` via Bash.
  They adapt `HERDR_ACTIVE_PANE_ID` to `HERDR_PANE_ID`; the router uses the
  `HERDR_BIN_PATH` supplied by Herdr.
- With the companion Neovim configuration loaded, **normal-mode** navigation moves
  between Neovim splits, then crosses to a Herdr pane at the editor's edge.
- Foreground `fzf` and `nu` receive the original Ctrl chord through the explicit
  `HERDR_NAV_PASSTHROUGH_RE='^(fzf|nu)$'` setting. Use `Prefix + h/j/k/l` to leave
  those panes; passthrough does not add edge detection to these applications.
- Other foreground programs use these Ctrl chords for Herdr pane navigation.
  This replaces shell shortcuts such as Ctrl+l (clear) and Ctrl+k (kill line).
- The router requires `jq` for process detection. Without it, navigation falls back
  to Herdr panes without Neovim awareness.
- Neovim insert-mode and terminal-mode navigation parity is **not implemented**.
  Leave those modes for editor split navigation, or use prefix navigation to move
  directly between Herdr panes. Popup input also stays within the popup.
- Ctrl+Shift and Alt chords depend on the outer terminal forwarding distinct keys.
  Ctrl+h can be indistinguishable from Backspace without the Kitty keyboard protocol.

## Differences and deferred behavior

- **Full-height split:** Herdr 0.9.0 does not expose the tmux full-height split action
  used here. Both `Prefix + \` and `Prefix + \|` make a normal current-pane split.
- **Previous-tab toggle:** `Prefix + p` selects the previous tab in order; no
  last-visited-tab toggle is configured.
- **Move to window:** moving a pane to another tab/window and breaking it into a
  new window are deferred. Directional swaps are configured instead.
- **Sesh:** `Prefix + s/S` opens Herdr's workspace picker; sesh and its tmux session
  workflow are not integrated.
- **Restoration:** no tmux-resurrect/continuum save/restore bindings or equivalent
  restoration workflow are implemented here. Herdr's native persistence is separate.
- **Synchronization:** synchronized pane input is not configured.

## Source and provisioning

- Config: `dot_config/herdr/config.toml.tmpl` → `~/.config/herdr/config.toml`.
- Pin: `.chezmoidata/herdr.yaml` selects `paulbkim-dev/vim-herdr-navigation` at
  `79679dacc791f70fc34de8b29a3cf9706c0f5b2f`.
- `dot_local/share/herdr/.chezmoiexternal.toml.tmpl` provisions the pinned GitHub
  archive using `stripComponents = 1`. Plugin contents live directly in
  `~/.local/share/herdr/vim-herdr-navigation`, including `navigate.sh` and
  `editor/nvim.lua`. The Herdr and Neovim sides share this directory.
- The shell bindings call that router directly; they do not require plugin-action
  registration or a custom installer.
- Existing onboarding, system-toast delivery, and Catppuccin settings are preserved.

Reference: [Herdr config keys](https://herdr.dev/docs/config-reference/),
[custom command bindings](https://herdr.dev/docs/configuration/#custom-command-keybindings),
and `herdr --default-config`. These describe configured behavior; interactive
navigation and terminal key forwarding still require runtime verification.
