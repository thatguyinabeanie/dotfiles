# Neovim

**Modal text editor**—LazyVim-based config. Leader: `Space` · Localleader: `\`

## 🧭 Navigation & Windows

| Key | Action |
|-----|--------|
| `Ctrl + h/j/k/l` | Navigate windows / tmux panes |
| `Ctrl + ↑/↓/←/→` | Resize windows |
| `Shift + h` / `Shift + l` | Previous / next buffer |
| `<leader> -` | Split window below |
| `<leader> \|` | Split window right |
| `<leader>wd` | Delete window |
| `<leader>wm` | Toggle zoom (maximize) mode |

## 📁 Files & Search (Snacks Picker)

| Key | Action |
|-----|--------|
| `<leader><space>` | Find files (root dir) |
| `<leader>ff` | Find files (root dir) |
| `<leader>fF` | Find files (cwd) |
| `<leader>fg` | Find git-tracked files |
| `<leader>fr` | Recent files |
| `<leader>fb` | Find buffers |
| `<leader>fc` | Find config file |
| `<leader>fn` | New file |
| `<leader>/` | Live grep (root dir) |
| `<leader>sg` | Live grep (root dir) |
| `<leader>sr` | Search and replace |
| `<leader>sw` | Search word under cursor |
| `<leader>s"` | Registers |
| `<leader>sm` | Marks |
| `<leader>sk` | Keymaps |

## 🔵 LSP & Code

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gr` | References |
| `gI` | Go to implementation |
| `gy` | Go to type definition |
| `K` | Hover documentation |
| `<leader>ca` | Code actions |
| `<leader>cr` | Rename symbol |
| `<leader>cf` | Format code |
| `<leader>cl` | LSP info |
| `<leader>cm` | Mason (tool installer) |
| `<leader>cs` | Symbols (Trouble) |

## 🔴 Diagnostics & Trouble

| Key | Action |
|-----|--------|
| `<leader>xx` | All diagnostics (Trouble) |
| `<leader>xX` | Buffer diagnostics (Trouble) |
| `<leader>xl` | Location list |
| `<leader>xq` | Quickfix list |
| `]d` / `[d` | Next / prev diagnostic |
| `]e` / `[e` | Next / prev error |

## 🌿 Git

| Key | Action |
|-----|--------|
| `<leader>gb` | Git blame line |
| `<leader>gs` | Git status |
| `<leader>gd` | Git diff (hunks) |
| `<leader>gS` | Git stash |
| `<leader>gi` | GitHub issues list (Octo) |
| `<leader>gp` | GitHub PRs list (Octo) |
| `<leader>gr` | GitHub repos list (Octo) |

## 📋 Buffers

| Key | Action |
|-----|--------|
| `<leader>bd` | Delete buffer |
| `<leader>bo` | Delete other buffers |
| `<leader>bl` / `<leader>br` | Delete buffers left / right |
| `<leader>bp` | Toggle pin |
| `<leader>bb` | Switch to other buffer |
| `<leader>bx` | Close all buffers |

## 📄 File Path Operations

| Key | Action |
|-----|--------|
| `<leader>fy` | Copy buffer relative path |
| `<leader>fY` | Copy buffer absolute path |
| `<leader>fd` | Copy parent dir relative path |
| `<leader>fD` | Copy parent dir absolute path |

## 🤖 AI & Sidekick

| Key | Action |
|-----|--------|
| `<leader>aa` | Toggle Sidekick CLI |
| `<leader>as` | Select CLI tool |
| `<leader>at` | Send "this" context |
| `<leader>av` | Send visual selection |
| `<leader>ap` | Select prompt |
| `<leader>ac` | Toggle Claude directly |
| `<leader>am` | MCP Hub |
| `Ctrl + .` | Switch focus (CLI ↔ editor) |
| `Tab` | Apply Next Edit Suggestion (NES) |

## 🧪 Testing (Neotest)

| Key | Action |
|-----|--------|
| `<leader>tt` | Run file |
| `<leader>tr` | Run nearest test |
| `<leader>tl` | Run last test |
| `<leader>ts` | Toggle test summary |
| `<leader>to` | Show test output |

## 🐛 Debugging (DAP)

| Key | Action |
|-----|--------|
| `<leader>db` | Toggle breakpoint |
| `<leader>dc` | Continue |
| `<leader>di` | Step into |
| `<leader>do` | Step over |
| `<leader>du` | DAP UI |
| `<leader>dPt` | Debug Python method |
| `<leader>dPc` | Debug Python class |

## 🔧 Refactoring

| Key | Action |
|-----|--------|
| `<leader>rf` | Extract function |
| `<leader>rv` | Extract variable |
| `<leader>ri` | Inline variable |

## 🌐 REST API (Kulala)

| Key | Action |
|-----|--------|
| `<leader>Rs` | Send request |
| `<leader>Rr` | Replay last request |
| `<leader>Rc` | Copy as cURL |
| `<leader>Ri` | Inspect request |
| `<leader>Rn` / `<leader>Rp` | Next / prev request |
| `<leader>Rt` | Toggle headers/body |

## ⚙️ Overseer (Task Runner)

| Key | Action |
|-----|--------|
| `<leader>oo` | Run task |
| `<leader>ot` | Task action |
| `<leader>ow` | Task list |
| `<leader>ob` | Run background task in tmux window |
| `<leader>og` | Go to tmux window of running task |

## 🎨 UI Toggles

| Key | Action |
|-----|--------|
| `<leader>ul` | Toggle line numbers |
| `<leader>uL` | Toggle relative numbers |
| `<leader>uw` | Toggle wrap |
| `<leader>us` | Toggle spelling |
| `<leader>uf` | Toggle auto format (global) |
| `<leader>uF` | Toggle auto format (buffer) |
| `<leader>ud` | Toggle diagnostics |
| `<leader>uh` | Toggle inlay hints |

## 🌲 Syntax Tree Navigation (Treewalker)

| Key | Action |
|-----|--------|
| `Alt + h/j/k/l` | Move through syntax tree nodes |
| `Alt + Shift + h/l` | Swap nodes left / right |
| `Alt + Ctrl + j/k` | Move line up / down |
| `Alt + Ctrl + h/l` | Indent / dedent line |

## ✂️ Text Objects & Motions

| Key | Action |
|-----|--------|
| `gsa` | Add surrounding |
| `gsd` | Delete surrounding |
| `gsr` | Replace surrounding |
| `gsf` / `gsF` | Find surrounding (forward/back) |
| `s` | Flash jump forward |
| `S` | Flash jump backward |
| `r` | Remote flash (operator mode) |

## 📋 Yank (Yanky)

| Key | Action |
|-----|--------|
| `<leader>p` | Open yank history |
| `]y` / `[y` | Cycle yank history forward / back |
| `p` / `P` | Enhanced put operations |

## 📓 Notebooks (Molten)

| Key | Action |
|-----|--------|
| `<localleader>i` | Initialize kernel |
| `<localleader>r` | Run cell |
| `<localleader>d` | Delete cell output |

## 🗄️ Database & Language-Specific

| Key | Language | Action |
|-----|----------|--------|
| `<leader>D` | Any | Toggle DBUI |
| `<leader>cp` | Markdown | Preview |
| `<localleader>l` | LaTeX | VimTeX menu |
