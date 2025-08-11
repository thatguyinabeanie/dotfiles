# Zellij Configuration - Complete Tmux Replacement

A comprehensive Zellij setup that replicates your tmux workflow with vim integration, session management, and Catppuccin theming.

## 🚀 Features

### **Vim Integration**
- **Seamless navigation** between Zellij panes and Vim/Neovim using `Ctrl+h/j/k/l`
- **Auto-unlock mode** when exiting vim to prevent key binding conflicts
- **vim-zellij-navigator plugin** provides tmux-vim-navigator equivalent functionality

### **Session Management (SessionX Replacement)**
- **Fuzzy session finder** with fzf integration and preview
- **Custom paths** support (~/source, ~/.config, ~/.local/share/chezmoi)
- **Zoxide integration** for recent directory access
- **Git repository detection** in previews
- **Beautiful Catppuccin-themed interface**

### **Tmux-like Key Bindings**
- **Ctrl+a prefix mode** - exactly like your tmux setup
- **All your tmux bindings** mapped to Zellij equivalents
- **Direct access shortcuts** for common operations
- **Muscle memory preserved** with tmux compatibility aliases

### **Chezmoi Workflow**
- **Ctrl+d** - Quick chezmoi session (matches tmux)
- **Ctrl+e** - Chezmoi editing session with nvim (matches tmux)
- **Dedicated layouts** for dotfiles management

## 🔧 Installation & Setup

The configuration is automatically managed by Chezmoi. After applying:

```bash
# Apply dotfiles (installs themes, scripts, configs)
chezmoi apply

# Start using zellij
z                    # Launch session manager
zellij              # Start with tmux-like layout
```

## 📋 Commands & Aliases

### **Primary Commands**
```bash
z                   # Session manager (replaces SessionX)
zx                  # Smart attach/create session
zw                  # Switch between sessions  
zcd                 # Quick chezmoi session
zce                 # Quick chezmoi editing session
```

### **Session Management**
```bash
zs                  # Session manager (same as 'z')
za <session>        # Attach to session
zl                  # List sessions
zk <session>        # Kill session
zK                  # Kill session with confirmation
zd                  # Detach from session
```

### **Tmux Compatibility**
```bash
ta <session>        # tmux attach-session equivalent
tn <session>        # tmux new-session equivalent
tl                  # tmux list-sessions equivalent
tk <session>        # tmux kill-session equivalent
```

## ⌨️ Key Bindings

### **Vim Navigation (Works in Vim & Zellij)**
- `Ctrl+h` - Move left (vim ↔ zellij seamless)
- `Ctrl+j` - Move down
- `Ctrl+k` - Move up  
- `Ctrl+l` - Move right

### **Tmux-style Prefix Mode (Ctrl+a)**
```bash
Ctrl+a o            # Session manager
Ctrl+a v            # Split vertical
Ctrl+a s/-          # Split horizontal
Ctrl+a z            # Toggle fullscreen
Ctrl+a x            # Close pane
Ctrl+a c            # New tab
Ctrl+a h/j/k/l      # Navigate panes
Ctrl+a r            # Reload config
Ctrl+a d            # Detach
```

### **Direct Access (No Prefix)**
```bash
Ctrl+o              # Session manager (replaces SessionX)
Ctrl+d              # Quick chezmoi session
Ctrl+e              # Quick chezmoi editing
Ctrl+g              # Lock mode (for vim)
Alt+v/s/-/|         # Quick pane splits
Alt+c               # New tab
Alt+x               # Close pane
Alt+z               # Toggle fullscreen
Ctrl+Shift+k        # Clear screen
```

## 🎨 Layouts

### **tmux-like** (default)
Status bar on top, full tmux experience

### **minimal** 
Compact bar, minimal UI noise

### **chezmoi**
Optimized for dotfiles work in ~/.local/share/chezmoi

### **chezmoi-nvim**
Starts with nvim in chezmoi directory

## 🔌 Session Manager Features

Launch with `z` or `Ctrl+o`:

### **Session Types**
- 🔗 **Active Sessions** - Attach to existing sessions
- 📁 **Custom Paths** - ~/source, ~/.config, ~/.local/share/chezmoi
- 📂 **Zoxide Directories** - Recently visited directories  
- 💼 **Project Directories** - Auto-discovered from ~/source, ~/projects

### **Preview Features**
- **Git status** for repositories
- **Directory contents** listing
- **Session information** for active sessions
- **Catppuccin colors** throughout

### **Keyboard Shortcuts in Manager**
- `Enter` - Select/create session
- `Esc` - Cancel
- `Ctrl+d/u` - Scroll preview
- `?` - Toggle preview pane

## 🎯 Migration from Tmux

### **Muscle Memory Preserved**
Your exact tmux workflow is replicated:
- Same prefix key (Ctrl+a)
- Same split bindings (v, s, -, |)
- Same navigation (h, j, k, l)
- Same session management (o for SessionX)
- Same chezmoi shortcuts (Ctrl+d, Ctrl+e)

### **Compatibility Layer**
```bash
tmux                # Reminds you to use zellij
ta/tn/tl/tk         # Work exactly like tmux commands
```

### **Enhanced Features**
- **Better vim integration** (auto-unlock, seamless navigation)
- **Modern fzf interface** for session management
- **Git-aware previews** in session manager
- **Floating windows** support
- **WASM plugin system** for extensibility

## 🛠 Configuration Files

```
~/.config/zellij/
├── config.kdl                     # Main configuration
├── themes/catppuccin.kdl          # Auto-downloaded themes
├── layouts/
│   ├── tmux-like.kdl              # Default layout
│   ├── minimal.kdl                # Minimal layout
│   ├── chezmoi.kdl                # Chezmoi layout
│   └── chezmoi-nvim.kdl           # Chezmoi + nvim
├── scripts/
│   ├── zellij-sessionx            # Session manager script
│   └── zellij-sessionx-preview    # Preview helper
├── zellij-functions.zsh           # Shell integration
└── README.md                      # This file
```

## 🎨 Theming

Uses **Catppuccin Mocha** theme to match your existing setup:
- Status bar colors match your tmux theme
- fzf integration uses Catppuccin colors
- Session manager interface themed consistently

## 🔄 Workflow Examples

### **Daily Development**
```bash
z                           # Launch session manager
# Select project from fzf interface
# Auto-creates session in project directory
```

### **Dotfiles Management**
```bash
zcd                         # Quick chezmoi session
# OR
zce                         # Edit dotfiles with nvim
```

### **Session Switching**
```bash
zw                          # Switch between active sessions
# OR
Ctrl+a o                    # Session manager from within zellij
```

## 🔧 Troubleshooting

### **Vim Navigation Not Working**
1. Ensure vim-zellij-navigator plugin is downloaded
2. Check that fzf is installed for session manager
3. Verify zoxide is available for directory history

### **Session Manager Not Loading**
1. Check that the scripts have execute permissions
2. Ensure fzf is installed and in PATH
3. Verify custom paths exist in filesystem

### **Themes Not Loading**
1. Run `chezmoi apply` to download Catppuccin themes
2. Check internet connection for theme downloads
3. Verify `.chezmoiexternal.toml` configuration

## 🎉 Benefits Over Tmux

1. **Modern Architecture** - WASM plugins vs shell scripts
2. **Better Defaults** - Sensible configuration out of box
3. **Vim Integration** - Built for vim users
4. **Session Management** - Superior to basic tmux sessions
5. **Theming** - First-class theme support
6. **Performance** - Rust-based, faster than tmux
7. **Cross-platform** - Works identically everywhere

---

**Result**: You get 100% of your tmux workflow with modern improvements and seamless vim integration.