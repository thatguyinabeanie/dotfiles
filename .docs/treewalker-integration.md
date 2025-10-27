# Treewalker Integration Guide

## 📋 Table of Contents

- [Overview](#overview)
- [Keybinding Reference](#keybinding-reference)
- [Architecture Decision](#architecture-decision)
- [Usage Guide](#usage-guide)
- [Integration Details](#integration-details)
- [Troubleshooting](#troubleshooting)
- [Implementation History](#implementation-history)

---

## Overview

### What is Treewalker?

**Treewalker.nvim** is a Neovim plugin that provides fast, predictable code navigation using Tree-sitter's syntax tree structure. Unlike traditional line-based or word-based movement, Treewalker navigates through logical code constructs (functions, blocks, statements, etc.).

### Why Integrate Treewalker?

- **Semantic navigation**: Move by code meaning, not just text layout
- **Consistency**: Works the same across all file types with Tree-sitter parsers
- **Refactoring**: Easily navigate and reorder code structures
- **Speed**: Faster than traditional navigation for structural code exploration
- **Jumplist integration**: Works with `Ctrl+o` / `Ctrl+i` for navigation history

### Architecture Decision: Alt+hjkl

After comprehensive analysis and real-world testing, **Alt+hjkl** was chosen for Treewalker because:

✅ **Preserves hjkl pattern** - Non-negotiable requirement
✅ **Terminal compatible** - Works reliably across all terminals (Ctrl+Shift+hjkl had issues)
✅ **Vim-native feel** - Single modifier for primary navigation
✅ **Zero conflicts** - LazyVim's Alt+jk moved to Alt+Ctrl+jk
✅ **Aerospace coexists** - Service mode changed to Alt+Ctrl+s
✅ **Visual mode support** - Can select syntax tree nodes

---

## Keybinding Reference

### Complete Navigation Hierarchy

This configuration uses a **modifier-based hierarchy** to separate different navigation contexts:

| Modifier Pattern | Purpose | Scope | Plugin/Feature |
|-----------------|---------|-------|----------------|
| `Ctrl+hjkl` | Pane/window navigation | Cross-application | vim-tmux-navigator |
| **`Alt+hjkl`** | **Tree navigation** | **Syntax-tree-level** | **Treewalker** |
| `Alt+Shift+hjkl` | Node swapping | Syntax-tree-level | Treewalker |
| `Alt+Ctrl+jk` | Line movement (up/down) | Line-level | LazyVim (remapped) |
| `Alt+Ctrl+hl` | Line indentation | Line-level | Custom |
| `Shift+H/L` | Buffer navigation | Buffer-level | LazyVim defaults |
| `Shift+J/K` | Join lines / Keyword lookup | Line/word-level | Vim essentials |

### Treewalker Keybindings

#### Tree Navigation (Normal + Visual Mode)

```
Alt+h  →  Move to previous sibling node (Treewalker Left)
Alt+j  →  Move to child node (Treewalker Down)
Alt+k  →  Move to parent node (Treewalker Up)
Alt+l  →  Move to next sibling node (Treewalker Right)
```

**Modes**: Normal (`n`) and Visual (`v`)
**Jumplist**: Movements >1 line added to jumplist (use `Ctrl+o` / `Ctrl+i` to navigate back/forward)

#### Node Swapping (Normal Mode Only)

```
Alt+Shift+h  →  Swap node with previous sibling (Swap Left)
Alt+Shift+j  →  Swap node downward (Swap Down)
Alt+Shift+k  →  Swap node upward (Swap Up)
Alt+Shift+l  →  Swap node with next sibling (Swap Right)
```

**Mode**: Normal (`n`) only
**Purpose**: Reorder function arguments, array elements, sibling statements, etc.

### Quick Reference Card

```
┌─────────────────────────────────────────────────────────────┐
│                   NAVIGATION HIERARCHY                      │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Ctrl + h/j/k/l         →  Vim/Tmux Panes (UNTOUCHABLE)   │
│  Alt + h/j/k/l          →  Syntax Tree Navigation          │
│  Alt+Shift + h/j/k/l    →  Node Swapping                   │
│  Alt+Ctrl + j/k         →  Line Movement (up/down)         │
│  Alt+Ctrl + h/l         →  Line Indent/Dedent              │
│  Shift + H/L            →  Buffers (Prev/Next)             │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Architecture Decision

### Keybinding Space Analysis

During integration planning, every modifier combination was analyzed to find available space:

#### ❌ Rejected Options

| Option | Reason for Rejection |
|--------|---------------------|
| `Ctrl+hjkl` | Used by vim-tmux-navigator (critical global binding - UNTOUCHABLE) |
| `Ctrl+Shift+hjkl` | **Terminal compatibility issue** - gets interpreted as Ctrl+hjkl by terminal |
| `Shift+H/L` | Used for buffer prev/next navigation |
| `Shift+J/K` | J = Join lines (vim essential), K = Keyword lookup (LSP hover) |
| `F-keys` | User requirement: must use hjkl |
| `Leader+T` | User requirement: must feel vim-native, not leader-based |
| `g+hjkl` | User preference: didn't love vim prefix patterns |
| `v+hjkl` | User preference: didn't like 'v' prefix |
| `Cmd+hjkl` | User preference: no Cmd keys in vim |

#### ✅ Chosen Solution: Alt+hjkl

**Rationale**:
1. **Uses hjkl** - Non-negotiable requirement satisfied
2. **Terminal compatible** - Works reliably across all terminals (Ctrl+Shift had issues)
3. **Vim-native feel** - Single modifier for primary navigation
4. **Minimal conflicts** - Only LazyVim's Alt+jk (line movement), easily remapped
5. **Clean separation** - Ctrl = panes, Alt = trees, Alt+Ctrl = line ops

### Conflict Resolution

#### LazyVim Line Operations Remapping

**Original bindings**:
- `Alt+j` / `Alt+k` = Move lines up/down
- `Alt+h` / `Alt+l` = Not used

**New bindings**:
- `Alt+Ctrl+j` / `Alt+Ctrl+k` = Move lines up/down
- `Alt+Ctrl+h` / `Alt+Ctrl+l` = Dedent/indent lines
- `Alt+hjkl` = **Freed for Treewalker**

**File modified**: `dot_config/nvim/lua/config/keymaps.lua`

#### Aerospace Service Mode Trigger

**Original trigger**: `Alt+Ctrl+;` (semicolon)
**Issue**: Potential conflicts with Neovim Alt+Ctrl line operations
**New trigger**: `Alt+Ctrl+s` (mnemonic: "s" for service mode)

**File modified**: `dot_config/aerospace/aerospace.toml` line 256

**Priority**: Aerospace takes back seat to Neovim (user requirement)

---

## Usage Guide

### Basic Tree Navigation

#### Example 1: Navigating Function Definitions

```python
def outer_function():           # Starting position
    def inner_function():       # Ctrl+Shift+j → Move into function
        x = 1                   # Ctrl+Shift+j → Move into body
        return x                # Ctrl+Shift+l → Move to next sibling

    return inner_function()     # Ctrl+Shift+k → Move up to parent
```

**Navigation flow**:
1. Start at `outer_function` definition
2. `Ctrl+Shift+j` - Descend into `inner_function` (child node)
3. `Ctrl+Shift+j` - Descend into function body
4. `Ctrl+Shift+l` - Move to next statement (`return x`)
5. `Ctrl+Shift+k` - Ascend to parent scope

#### Example 2: Navigating Conditionals

```javascript
if (condition1) {        // Starting position
    doSomething();
} else if (condition2) { // Ctrl+Shift+l → Move to next sibling (else if)
    doOtherThing();
} else {                 // Ctrl+Shift+l → Move to next sibling (else)
    doDefault();
}
```

**Pattern**: `Ctrl+Shift+h/l` navigates between sibling blocks (if/else if/else)

#### Example 3: Array/Object Navigation

```json
{
    "name": "config",       // Starting position
    "version": "1.0",      // Ctrl+Shift+l → Next property
    "dependencies": {...}   // Ctrl+Shift+l → Next property
}
```

**Pattern**: `Ctrl+Shift+h/l` moves between sibling properties or array elements

### Node Swapping Workflows

#### Example 1: Reordering Function Arguments

**Before**:
```python
def calculate(a, b, c):  # Want to swap 'b' and 'c'
    pass
```

**Steps**:
1. Position cursor on `b`
2. Press `Ctrl+Shift+Alt+l` - Swap with next sibling

**After**:
```python
def calculate(a, c, b):
    pass
```

#### Example 2: Reordering Array Elements

**Before**:
```javascript
const items = [
    "first",
    "second",  // Want to move this up
    "third"
];
```

**Steps**:
1. Position cursor on `"second"`
2. Press `Ctrl+Shift+Alt+k` - Swap with previous sibling

**After**:
```javascript
const items = [
    "second",
    "first",
    "third"
];
```

### Visual Mode Selection

Treewalker works in **visual mode** to select entire syntax tree nodes:

```python
def example():
    if condition:        # Start here
        statement1       # Ctrl+Shift+j in visual mode
        statement2       # → Selects entire if block
```

**Workflow**:
1. Enter visual mode: `v`
2. Use `Ctrl+Shift+hjkl` to select by syntax tree structure
3. Operate on selection (yank, delete, change, etc.)

### Jumplist Integration

Treewalker movements >1 line are added to the jumplist:

```
1. Navigate with Ctrl+Shift+hjkl
2. Jump back with Ctrl+o (jumplist backward)
3. Jump forward with Ctrl+i (jumplist forward)
```

This allows you to explore code structure and easily return to previous positions.

---

## Integration Details

### LazyVim Defaults Preserved

All LazyVim default keybindings remain unchanged:

#### Line Manipulation (Alt+hjkl)
```
Alt+j  →  Move current line down
Alt+k  →  Move current line up
Alt+h  →  Dedent line (shift left)
Alt+l  →  Indent line (shift right)
```

**Modes**: Normal, Insert, Visual
**Source**: LazyVim core keymaps
**Status**: ✅ Unchanged

#### Buffer Navigation (Shift+H/L)
```
H (Shift+h)  →  Previous buffer (:bprevious)
L (Shift+l)  →  Next buffer (:bnext)
```

**Mode**: Normal
**Source**: LazyVim overrides vim's native H/L (High/Low screen movement)
**Status**: ✅ Unchanged

#### Vim Essentials (Shift+J/K)
```
J (Shift+j)  →  Join lines
K (Shift+k)  →  Keyword lookup / LSP hover
```

**Mode**: Normal
**Source**: Vim native (J), LazyVim enhanced (K with LSP)
**Status**: ✅ Unchanged

### vim-tmux-navigator Harmony

The **vim-tmux-navigator** plugin provides seamless navigation between Neovim windows and tmux panes:

```
Ctrl+h/j/k/l  →  Navigate windows/panes in any direction
Ctrl+\        →  Navigate to previous window/pane
```

**Status**: ✅ Unchanged
**Coexistence**: Ctrl alone = panes, Ctrl+Shift = tree navigation
**Plugin file**: `dot_config/nvim/lua/plugins/utilities/vim-tmux-navigator.lua`

### Aerospace Window Manager Coexistence

**Aerospace** is a tiling window manager for macOS. Its service mode originally used hjkl navigation:

#### Original Aerospace Service Mode
```
Alt+Ctrl+;           →  Enter service mode
h/j/k/l (in mode)    →  Focus window in direction
Alt+h/j/k/l (in mode) →  Move window in direction
```

#### Current Status
**No changes needed** - Aerospace operates at the window manager level (system-wide), while Treewalker operates within Neovim (application-level). The contexts are completely separate:

- **Outside Neovim**: Aerospace service mode works normally
- **Inside Neovim**: `Ctrl+Shift+hjkl` triggers Treewalker before Aerospace sees it

**Aerospace config file**: `dot_config/aerospace/aerospace.toml`
**Status**: ✅ Unchanged

### Tmux Keybinding Adjustments

One minor adjustment was made to tmux:

#### Clear Terminal Binding

**Before**: `Ctrl+Shift+K` = clear terminal (global binding)
**After**: `Ctrl+Shift+C` = clear terminal (global binding)

**Reason**: Free up `Ctrl+Shift+K` for Treewalker Up navigation
**Mnemonic**: "C" for "clear"
**File**: `dot_config/tmux/tmux.keybindings.conf` line 96

#### Other Tmux Bindings (Unchanged)
```
Ctrl+Shift+p  →  Move tmux window left
Ctrl+Shift+n  →  Move tmux window right
```

**Status**: ✅ Unchanged

---

## Troubleshooting

### Terminal Support for Ctrl+Shift

**Issue**: Some terminals don't properly handle `Ctrl+Shift` combinations.

**Solutions**:

1. **Ghostty** (recommended): Full support for modern key sequences
2. **iTerm2**: Enable "Report modifiers using CSI u sequences" in Preferences → Profiles → Keys
3. **Alacritty**: Add to config:
   ```yaml
   key_bindings:
     - { key: H, mods: Control|Shift, chars: "\x1b[72;6u" }
     - { key: J, mods: Control|Shift, chars: "\x1b[74;6u" }
     - { key: K, mods: Control|Shift, chars: "\x1b[75;6u" }
     - { key: L, mods: Control|Shift, chars: "\x1b[76;6u" }
   ```
4. **Kitty**: Should work out of the box

**Testing**: Run `:verbose map <C-S-h>` in Neovim to verify bindings are recognized

### Karabiner Interactions

**Karabiner-Elements** remaps Right Alt+hjkl to arrow keys at the keyboard level:

```
Right Alt + h  →  Left Arrow
Right Alt + j  →  Down Arrow
Right Alt + k  →  Up Arrow
Right Alt + l  →  Right Arrow
```

**Impact on Treewalker**: None - Treewalker uses `Ctrl+Shift`, not `Alt`
**Impact on Alt+hjkl line ops**: None - Left Alt is unmodified, Right Alt produces arrows

**Karabiner config**: `dot_config/karabiner/karabiner.json`

### Tree-sitter Parser Missing

**Issue**: Treewalker doesn't work in a specific file type.

**Cause**: Tree-sitter parser not installed for that language.

**Solution**:
```vim
:TSInstall <language>
```

Example: `:TSInstall python`, `:TSInstall lua`, `:TSInstall javascript`

Check installed parsers: `:TSInstallInfo`

### Highlight Not Showing

**Issue**: No visual feedback when jumping.

**Check configuration** in `dot_config/nvim/lua/plugins/core/treewalker.lua`:
```lua
opts = {
  highlight = true,              -- Must be true
  highlight_duration = 250,      -- Adjust timing (milliseconds)
  highlight_group = "CursorLine", -- Change highlight style if needed
}
```

### Jumplist Not Working

**Issue**: `Ctrl+o` / `Ctrl+i` don't jump to Treewalker positions.

**Check configuration**:
```lua
opts = {
  jumplist = true,  -- Must be true
}
```

**Note**: Only movements >1 line are added to jumplist by default.

### Keybinding Conflicts

**Issue**: Treewalker keybindings don't work or trigger unexpected behavior.

**Debug steps**:
1. Check for mapping conflicts:
   ```vim
   :verbose map <C-S-h>
   :verbose map <C-S-j>
   :verbose map <C-S-k>
   :verbose map <C-S-l>
   ```
2. Verify plugin is loaded:
   ```vim
   :Lazy
   ```
   Look for "aaronik/treewalker.nvim" in the list
3. Test Treewalker commands directly:
   ```vim
   :Treewalker Left
   :Treewalker Down
   :Treewalker Up
   :Treewalker Right
   ```

---

## Implementation History

### Research Process

The integration required comprehensive analysis of the entire keybinding ecosystem:

1. **LazyVim defaults**: Analyzed all default keymaps, discovered Alt+hjkl used for line operations
2. **Plugin keybindings**: Cataloged all plugin-specific keymaps (vim-tmux-navigator, kulala, etc.)
3. **LazyVim extras**: Checked for additional keybindings from enabled extras
4. **Tmux configuration**: Mapped all tmux keybindings, found Ctrl+Shift+K conflict
5. **Aerospace window manager**: Understood service mode navigation patterns
6. **Karabiner remapping**: Documented Right Alt+hjkl → arrows transformation
7. **Vim essentials**: Confirmed Shift+J (join) and Shift+K (keyword) must be preserved

### Alternative Approaches Considered

#### Option 1: Alt+hjkl
- **Pros**: Most vim-native feeling, single modifier
- **Cons**: Conflicts with LazyVim line movement operations
- **Result**: ❌ Rejected

#### Option 2: F-keys (F7-F14)
- **Pros**: Zero conflicts, hardware keys
- **Cons**: User requirement violated (must use hjkl)
- **Result**: ❌ Rejected

#### Option 3: Leader+T prefix
- **Pros**: Mnemonic ("t" for tree), LazyVim-consistent
- **Cons**: User requirement violated (must feel vim-native, not leader-based)
- **Result**: ❌ Rejected

#### Option 4: g+hjkl or z+hjkl
- **Pros**: Vim-native prefix pattern
- **Cons**: User preference (didn't love prefix patterns)
- **Result**: ❌ Rejected

#### Option 5: v+hjkl
- **Pros**: Mnemonic ("v" for visual/view structure)
- **Cons**: User preference (didn't like 'v'), conflicts with visual mode entry
- **Result**: ❌ Rejected

#### Option 6: Shift+J/K only
- **Pros**: Half of Shift+hjkl available
- **Cons**: Loses J (join lines) and K (keyword lookup) - too important
- **Result**: ❌ Rejected

#### Option 7: Ctrl+Shift+hjkl (CHOSEN)
- **Pros**: Uses hjkl, zero conflicts, vim-native feel, semantic separation
- **Cons**: Two-modifier chord (slightly more complex)
- **Result**: ✅ **Accepted**

### Why Ctrl+Shift+hjkl Succeeded

The final solution satisfied all requirements:

✅ **Uses hjkl** - Non-negotiable user requirement
✅ **Vim-native feel** - Modifier-based navigation is standard
✅ **Zero conflicts** - All existing bindings preserved
✅ **Terminal compatible** - Works in modern terminals
✅ **Semantic clarity** - Modifier count indicates scope
✅ **Visual mode support** - Works in both normal and visual modes
✅ **Jumplist integration** - Enhances navigation workflow
✅ **User approval** - Met all user preferences

---

## Configuration Files

### Primary Implementation

**File**: `dot_config/nvim/lua/plugins/core/treewalker.lua`

```lua
return {
  {
    "aaronik/treewalker.nvim",

    keys = {
      -- Tree navigation
      { "<C-S-h>", "<cmd>Treewalker Left<cr>", desc = "Treewalker Left", mode = { "n", "v" } },
      { "<C-S-j>", "<cmd>Treewalker Down<cr>", desc = "Treewalker Down", mode = { "n", "v" } },
      { "<C-S-k>", "<cmd>Treewalker Up<cr>", desc = "Treewalker Up", mode = { "n", "v" } },
      { "<C-S-l>", "<cmd>Treewalker Right<cr>", desc = "Treewalker Right", mode = { "n", "v" } },

      -- Node swapping
      { "<C-S-M-h>", "<cmd>Treewalker SwapLeft<cr>", desc = "Treewalker Swap Left", mode = "n" },
      { "<C-S-M-j>", "<cmd>Treewalker SwapDown<cr>", desc = "Treewalker Swap Down", mode = "n" },
      { "<C-S-M-k>", "<cmd>Treewalker SwapUp<cr>", desc = "Treewalker Swap Up", mode = "n" },
      { "<C-S-M-l>", "<cmd>Treewalker SwapRight<cr>", desc = "Treewalker Swap Right", mode = "n" },
    },

    opts = {
      highlight = true,
      highlight_duration = 250,
      highlight_group = "CursorLine",
      select = false,
      jumplist = true,
    },
  },
}
```

### Central Keymaps Reference

**File**: `dot_config/nvim/lua/config/keymaps.lua`

```lua
--
-- TREEWALKER KEYBINDINGS
--
-- Treewalker keybindings are now defined in the plugin file:
-- dot_config/nvim/lua/plugins/core/treewalker.lua
--
-- Quick reference:
--   Ctrl+Shift+hjkl       → Tree navigation (previous/down/up/next sibling)
--   Ctrl+Shift+Alt+hjkl   → Node swapping (reorder nodes)
--
-- See .docs/treewalker-integration.md for comprehensive documentation.
```

### Tmux Adjustment

**File**: `dot_config/tmux/tmux.keybindings.conf` line 96

```bash
bind-key -n C-S-c send-keys "clear"\; send-keys "Enter"  # Ctrl-Shift-c = clear terminal
```

---

## Related Documentation

- [Neovim Agent Guide](.docs/agent/NEOVIM_AGENT.md) - Main Neovim configuration documentation
- [Treewalker Plugin File](../dot_config/nvim/lua/plugins/core/treewalker.lua) - Plugin implementation
- [LazyVim Keymaps](https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua) - Upstream defaults
- [Treewalker.nvim GitHub](https://github.com/aaronik/treewalker.nvim) - Plugin repository

---

## Future Enhancements

Potential improvements to consider:

1. **Custom highlight group**: Create dedicated Treewalker highlight for better visual feedback
2. **Which-key integration**: Add which-key descriptions for better discoverability
3. **Language-specific behavior**: Customize tree navigation per language/filetype
4. **Visual selection refinement**: Explore `select = true` mode for different workflow
5. **Custom Tree-sitter queries**: Define custom node types for navigation

---

**Last Updated**: 2025-01-24
**Configuration Version**: LazyVim-based Neovim with Treewalker integration
**Maintained by**: AI Agent (Claude Code)
