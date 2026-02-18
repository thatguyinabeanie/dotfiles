# 🎯 Zellij Terminal Multiplexer Guide

**Quick Reference**: Your complete guide to using Zellij with seamless Neovim integration

---

## 📋 Table of Contents

1. [What is Zellij?](#what-is-zellij)
2. [Quick Start](#quick-start)
3. [Keybindings Cheat Sheet](#keybindings-cheat-sheet)
4. [Seamless Navigation with Neovim](#seamless-navigation-with-neovim)
5. [Working with Tabs](#working-with-tabs)
6. [Working with Panes](#working-with-panes)
7. [Floating Tools](#floating-tools)
8. [Sessions & Workflows](#sessions--workflows)
9. [Tips & Tricks](#tips--tricks)
10. [Troubleshooting](#troubleshooting)

---

## What is Zellij?

Zellij is a **terminal multiplexer** (like tmux or screen) that lets you:

- Split your terminal into multiple panes
- Create tabs to organize different workflows
- Detach and reattach sessions (your work persists)
- Use floating overlays for quick tasks

**Key Features in This Setup:**

- 🎨 Catppuccin theme integration
- ⌨️ Tmux-style keybindings (`Ctrl+a` prefix)
- 🔄 Seamless navigation between Zellij panes and Neovim splits
- 🚀 Floating quick-access tools (LazyGit, Yazi, btop, etc.)
- 🎯 Auto-lock when Neovim is focused

---

## Quick Start

### Opening Zellij

Zellij is automatically launched when you open WezTerm (configured to use a shared session named "wezterm").

### Basic Workflow

1. **Create a new pane**: `Ctrl+a |` (vertical) or `Ctrl+a -` (horizontal)
2. **Navigate between panes**: `Ctrl+h/j/k/l` (works across Zellij AND Neovim!)
3. **Open a floating tool**: `Ctrl+a g` (LazyGit), `Ctrl+a y` (Yazi), etc.
4. **Create a new tab**: `Ctrl+a c`
5. **Switch tabs**: `Ctrl+a n` (next) or `Ctrl+a p` (previous)

---

## Keybindings Cheat Sheet

> **Note**: All commands use `Ctrl+a` as the prefix key (press `Ctrl+a`, release, then press the command key)

### Essential Commands

| Keys | Action | Example Use Case |
|------|--------|------------------|
| `Ctrl+a c` | New tab | Start working on a different project |
| `Ctrl+a \|` | Vertical split | Code editor + terminal side-by-side |
| `Ctrl+a -` | Horizontal split | Code editor + logs below |
| `Ctrl+a z` | Zoom pane | Focus on one pane temporarily |
| `Ctrl+a d` | Detach | Leave session running, come back later |

### Tab Management

| Keys | Action |
|------|--------|
| `Ctrl+a c` | Create new tab |
| `Ctrl+a n` | Next tab |
| `Ctrl+a p` | Previous tab |
| `Ctrl+a 1-9` | Jump to tab number |
| `Ctrl+a ,` | Rename tab |
| `Ctrl+a &` | Close tab |
| `Ctrl+a Tab` | Toggle to last tab |

### Pane Management

| Keys | Action |
|------|--------|
| `Ctrl+a \|` or `%` | Split vertically (side-by-side) |
| `Ctrl+a -` or `"` | Split horizontally (top/bottom) |
| `Ctrl+a x` | Close current pane |
| `Ctrl+a z` | Toggle zoom (fullscreen pane) |
| `Ctrl+a _` | Toggle zoom (alternative) |
| `Ctrl+a o` | Cycle through panes |
| `Ctrl+a Space` | Toggle all floating panes |
| `Ctrl+a f` | Toggle current pane floating |

### Navigation (Vim-Style)

| Keys | Action |
|------|--------|
| `Ctrl+h` | Move left (works in Zellij AND Neovim!) |
| `Ctrl+j` | Move down |
| `Ctrl+k` | Move up |
| `Ctrl+l` | Move right |

### Resize Mode

| Keys | Action |
|------|--------|
| `Ctrl+a r` | Enter resize mode |
| `h/j/k/l` | Increase size in direction |
| `H/J/K/L` | Decrease size in direction |
| `=` or `+` | Increase size (balanced) |
| `-` | Decrease size (balanced) |
| `Esc` or `q` | Exit resize mode |

### Move Mode

| Keys | Action |
|------|--------|
| `Ctrl+a m` | Enter move mode |
| `h/j/k/l` | Move pane in direction |
| `Esc` or `q` | Exit move mode |

### Scroll/Copy Mode

| Keys | Action |
|------|--------|
| `Ctrl+a [` | Enter scroll mode |
| `j/k` | Scroll down/up |
| `Ctrl+d/u` | Half page down/up |
| `Ctrl+f/b` | Full page down/up |
| `/` | Search |
| `n/N` | Next/previous search result |
| `Esc` or `q` | Exit scroll mode |

### Session Management

| Keys | Action |
|------|--------|
| `Ctrl+a d` | Detach from session |
| `Ctrl+a s` | Session manager (list/switch) |
| `Ctrl+a w` | Session manager (floating) |

### Floating Tools (Quick Access)

| Keys | Tool | Description |
|------|------|-------------|
| `Ctrl+a g` | LazyGit | Git management interface |
| `Ctrl+a y` | Yazi | File browser and picker |
| `Ctrl+a D` | LazyDocker | Docker container management |
| `Ctrl+a M` | btop | System monitor |
| `Ctrl+a b` | Strider | Built-in file picker |
| `Ctrl+a P` | Plugin Manager | Manage Zellij plugins |

### Miscellaneous

| Keys | Action |
|------|--------|
| `Ctrl+a Ctrl+a` | Send literal `Ctrl+a` to shell |
| `Ctrl+a :` | Command/search mode |
| `Ctrl+a e` | Toggle pane frames |
| `Esc` | Return to normal mode |

---

## Seamless Navigation with Neovim

This setup includes **smart navigation** that works seamlessly between Zellij panes and Neovim splits.

### How It Works

1. **When Neovim is focused**: Zellij automatically enters "locked" mode
2. **Press `Ctrl+h/j/k/l`**: Navigates between Neovim splits
3. **At the edge of Neovim**: Automatically switches to adjacent Zellij pane
4. **When Neovim exits**: Zellij automatically unlocks

### Example Workflow

```text
┌─────────────────────────────────┬───────────────────┐
│                                 │                   │
│         Neovim                  │    Terminal       │
│    Ctrl+h/j/k/l (splits)        │    (zsh)          │
│                                 │                   │
│  N | main.ts ● | 2 errors      │                   │
└─────────────────────────────────┴───────────────────┘
```

**Navigation Example:**

- In Neovim, editing `main.ts`
- Press `Ctrl+l` repeatedly → Moves through Neovim splits → Reaches edge → Switches to terminal pane
- Press `Ctrl+h` → Returns to Neovim
- **No prefix needed!** It just works.

### Plugins Involved

- **In Zellij**: `autolock` plugin (auto-locks when Neovim is running)
- **In Neovim**: `zellij-nav.nvim` (handles navigation and pane switching)

---

## Working with Tabs

Tabs are like different workspaces. Each tab can have its own pane layout.

### Common Tab Patterns

**Pattern 1: Project-Based Tabs**

```text
Tab 1: "backend"   → API server + logs + database
Tab 2: "frontend"  → Neovim + dev server + browser sync
Tab 3: "tests"     → Test runner + coverage viewer
```

**Pattern 2: Tool-Based Tabs**

```text
Tab 1: "code"      → Full-screen Neovim
Tab 2: "git"       → LazyGit + git log
Tab 3: "docker"    → LazyDocker + container logs
Tab 4: "monitor"   → btop + network monitor
```

### Tab Shortcuts

```bash
# Create multiple tabs quickly
Ctrl+a c    # New tab (edit backend)
Ctrl+a ,    # Rename to "backend"
Ctrl+a c    # New tab (edit frontend)
Ctrl+a ,    # Rename to "frontend"
Ctrl+a 1    # Jump to "backend"
Ctrl+a 2    # Jump to "frontend"
```

---

## Working with Panes

Panes let you split a single tab into multiple views.

### Common Pane Layouts

**Layout 1: Code + Terminal**

```text
┌─────────────────────┬─────┐
│                     │     │
│      Neovim         │ zsh │
│                     │     │
└─────────────────────┴─────┘

Commands: Ctrl+a | (or Ctrl+a %)
```

**Layout 2: Code + Terminal + Logs**

```text
┌─────────────────────┬─────┐
│                     │ zsh │
│      Neovim         ├─────┤
│                     │logs │
└─────────────────────┴─────┘

Commands:
  Ctrl+a |    # Vertical split
  Ctrl+a l    # Move right
  Ctrl+a -    # Horizontal split
```

**Layout 3: Editor + REPL + Docs**

```text
┌─────────┬─────┐
│         │REPL │
│ Neovim  ├─────┤
│         │Docs │
└─────────┴─────┘
```

### Pane Tips

- **Resize panes**: `Ctrl+a r`, then use `h/j/k/l` to adjust
- **Balance panes**: `Ctrl+a r` then `=` to equalize sizes
- **Zoom a pane**: `Ctrl+a z` to go fullscreen, `Ctrl+a z` again to restore
- **Close unnecessary panes**: `Ctrl+a x`

---

## Floating Tools

Floating tools appear as overlays on top of your current work. Press `Esc` or `q` to dismiss them.

### Available Floating Tools

#### LazyGit (`Ctrl+a g`)

**Use for**: Git operations (commit, push, pull, merge, rebase)

```text
┌─────────────────────────────────────┐
│            LazyGit                  │
│  Status | Files | Branches | Stash  │
│  ● main.ts (modified)               │
│  ● utils.ts (staged)                │
│                                     │
│  [c] commit  [p] push  [q] quit    │
└─────────────────────────────────────┘
```

#### Yazi (`Ctrl+a y`)

**Use for**: File browsing, quick navigation, file operations

```text
┌─────────────────────────────────────┐
│              Yazi                   │
│  📁 src/                            │
│    📄 main.ts                       │
│    📄 utils.ts                      │
│  📁 tests/                          │
│                                     │
│  [Enter] open  [q] quit             │
└─────────────────────────────────────┘
```

#### LazyDocker (`Ctrl+a D` - Shift+D)

**Use for**: Docker container management

```text
┌─────────────────────────────────────┐
│           LazyDocker                │
│  Containers | Images | Volumes      │
│  ✓ api-server (running)             │
│  ✗ database (stopped)               │
│                                     │
│  [s] start  [r] restart  [q] quit   │
└─────────────────────────────────────┘
```

#### btop (`Ctrl+a M` - Shift+M)

**Use for**: System monitoring (CPU, RAM, processes)

```text
┌─────────────────────────────────────┐
│              btop                   │
│  CPU: 45%  RAM: 8.2GB / 16GB       │
│  ████████░░░░░░░░░░░░░░░░           │
│                                     │
│  Top Processes:                     │
│  • nvim       1.2GB                 │
│  [q] quit                           │
└─────────────────────────────────────┘
```

### Floating vs. Split Panes

**Use Floating For:**

- Quick tasks (check git status, browse files)
- Temporary actions (monitor system, manage containers)
- Tools you don't need to see constantly

**Use Split Panes For:**

- Persistent terminals (dev servers, watchers)
- Side-by-side workflows (editor + logs)
- Long-running processes

---

## Sessions & Workflows

### Understanding Sessions

**What is a session?**

- A session contains all your tabs and panes
- Sessions persist even after you close your terminal
- You can detach from a session and reattach later

**Your Default Session:**

- WezTerm automatically creates a session named `"wezterm"`
- All WezTerm windows attach to this shared session
- The session ends when the last window is closed

### Session Commands

```bash
# List all sessions
zellij list-sessions

# Attach to a session
zellij attach wezterm

# Create a new named session
zellij -s myproject

# Detach from current session
Ctrl+a d

# Kill a session
zellij kill-session wezterm
```

### Example Workflows

#### Workflow 1: Web Development

```text
Session: "webapp"
├─ Tab 1: "backend"
│  ├─ Neovim (editing API code)
│  └─ Terminal (running server)
├─ Tab 2: "frontend"
│  ├─ Neovim (editing React components)
│  └─ Terminal (running dev server)
└─ Tab 3: "database"
   ├─ PostgreSQL CLI
   └─ Database logs
```

#### Workflow 2: DevOps

```text
Session: "infrastructure"
├─ Tab 1: "code"
│  └─ Neovim (editing Terraform/K8s configs)
├─ Tab 2: "deploy"
│  ├─ Terminal (kubectl commands)
│  └─ Terminal (logs)
└─ Tab 3: "monitor"
   ├─ K9s (Kubernetes dashboard)
   └─ btop (system monitor)
```

#### Workflow 3: Learning/Exploration

```text
Session: "learning"
├─ Tab 1: "code"
│  ├─ Neovim (writing code)
│  └─ REPL (testing snippets)
├─ Tab 2: "docs"
│  ├─ Browser (documentation)
│  └─ Terminal (running examples)
└─ Tab 3: "notes"
   └─ Neovim (taking notes)
```

---

## Tips & Tricks

### Productivity Tips

1. **Muscle Memory**: Learn `Ctrl+a c`, `Ctrl+a |`, `Ctrl+a -` first
2. **Name Your Tabs**: Use `Ctrl+a ,` to give tabs meaningful names
3. **Zoom for Focus**: `Ctrl+a z` to fullscreen a pane when you need to concentrate
4. **Floating for Speed**: Use `Ctrl+a g` for quick git operations instead of switching panes
5. **Session Per Project**: Create separate sessions for different projects

### Visual Customization

**Pane Borders:**

- Borders are subtle (Catppuccin surface colors)
- Active pane has a blue border
- Inactive panes have gray borders

**Theme:**

- Currently using Catppuccin {{ .CATPPUCCIN_FLAVOR | default "Mocha" }}
- Change flavor in `.chezmoidata/shared.yaml`:

  ```yaml
  CATPPUCCIN_FLAVOR: "macchiato"  # or frappe, latte, mocha
  ```

### Power User Shortcuts

```bash
# Quick project setup
zellij -s myproject
Ctrl+a c     # New tab for code
Ctrl+a , "code" Enter
Ctrl+a c     # New tab for tests
Ctrl+a , "tests" Enter
Ctrl+a 1     # Back to code tab
Ctrl+a |     # Split for terminal
```

### Copy-Paste Integration

- **Mouse selection**: Automatically copies to clipboard
- **Scroll mode**: `Ctrl+a [` then select text with mouse
- **System clipboard**: Works with `Ctrl+V` paste

---

## Troubleshooting

### Common Issues

#### Ctrl+h/j/k/l Not Working

**Problem**: Navigation keys not switching panes

**Solutions**:

1. Check if Neovim is running: `ps aux | grep nvim`
2. Ensure `autolock` plugin is loaded: Check `~/.config/zellij/config.kdl`
3. Try exiting and re-entering Neovim
4. Check ZELLIJ environment variable: `echo $ZELLIJ`

#### Panes Not Showing Borders

**Problem**: All panes blend together

**Solution**:

- Toggle pane frames: `Ctrl+a e`
- Check config: `pane_frames true` in `~/.config/zellij/config.kdl`

#### Session Persists When I Don't Want It To

**Problem**: Old tabs/panes keep coming back

**Solution**:

```bash
# List sessions
zellij list-sessions

# Kill the persistent session
zellij kill-session wezterm

# Restart WezTerm (creates fresh session)
```

#### Floating Tools Don't Open

**Problem**: `Ctrl+a g` (or y/D/M) does nothing

**Solutions**:

1. Ensure tools are installed:

   ```bash
   which lazygit yazi lazydocker btop
   ```

2. Run `chezmoi apply` to update Zellij config
3. Restart Zellij session

#### Can't Detach from Session

**Problem**: `Ctrl+a d` not working

**Solution**:

- Ensure you're in "tmux" mode: Press `Ctrl+a` first, then `d`
- Alternatively: `Ctrl+a s` to open session manager, then select "detach"

---

## Additional Resources

**Official Documentation:**

- Zellij Docs: <https://zellij.dev/documentation/>
- Zellij GitHub: <https://github.com/zellij-org/zellij>

**Related Configurations:**

- Neovim Integration: [../nvim/GUIDE.md](../nvim/GUIDE.md)
- WezTerm Setup: [../wezterm/GUIDE.md](../wezterm/GUIDE.md)
- Tmux Comparison: [../tmux/GUIDE.md](../tmux/GUIDE.md)

---

## Quick Reference Card

```text
┌─────────────────────────────────────────────────────────┐
│              ZELLIJ QUICK REFERENCE                     │
├─────────────────────────────────────────────────────────┤
│  PREFIX: Ctrl+a                                         │
│                                                         │
│  TABS        PANES          FLOATING      MISC          │
│  c  new      |  vsplit      g  lazygit    z  zoom       │
│  n  next     -  hsplit      y  yazi       d  detach     │
│  p  prev     x  close       D  docker     [  scroll     │
│  ,  rename   o  cycle       M  btop       r  resize     │
│  1-9 jump    Space toggle   b  files      :  search     │
│                                                         │
│  NAVIGATION (no prefix needed)                          │
│  Ctrl+h/j/k/l  →  Works in Zellij AND Neovim!          │
└─────────────────────────────────────────────────────────┘
```
