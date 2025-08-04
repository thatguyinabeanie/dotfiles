
<div align="center">


# 🖥️ Tmux Configuration 🔄


A modern and functional Tmux configuration with Catppuccin theme integration, custom keybindings, and productivity features.



<div align="center">
  <img src="https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/85.png" width="150" alt="Dodrio" />
</div>


![Tmux](https://img.shields.io/badge/Tool-Tmux_3.0+-blue?style=flat-square&logo=tmux)
![Theme](https://img.shields.io/badge/Theme-Catppuccin-pink?style=flat-square)
![Chezmoi](https://img.shields.io/badge/Managed_with-Chezmoi-blue?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-yellow?style=flat-square)


</div>


## 🌟 Features

### 🎨 Theme


<img src="https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/133.png" width="50" align="right" />


- **Catppuccin Integration**: Beautiful and consistent theming
- **Transparency**: Support for transparent backgrounds
- **Custom Status Line**: Tailored status line display

### ⚡ Productivity

- **SessionX**: Advanced session manager with fuzzy finding and preview
- **Pomodoro Timer**: Integrated for focus management
- **Custom Keybindings**: Personalized shortcuts for efficiency
- **Enhanced Status Bar**: More informative status bar
- **Session Management**: Robust session handling features
- **Zoxide Integration**: Smart directory jumping for session creation

## 📂 Configuration Structure

The configuration is split into multiple files for better organization:

```shell
tmux/
├── 📝 tmux.conf - Main configuration file
├── ⌨️ tmux.keybindings.conf - Custom keybindings
├── ⏱️ tmux.pomodoro.conf - Pomodoro timer settings
├── 📊 tmux.status.conf - Status bar configuration
└── 🎨 tmux.theme.catppuccin.conf.tmpl - Theme configuration (Chezmoi template)
```

## 🛠️ Installation

1. Clone this configuration using Chezmoi:

   ```shell
   chezmoi init --apply
   ```

2. Ensure Tmux is installed:

   ```shell
   brew install tmux
   ```

## ⚙️ Customization

### 🎨 Theme


<img src="https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/134.png" width="50" align="right" />


The configuration uses Catppuccin theme with:

- **Transparency Support**: For see-through terminal backgrounds
- **Custom Colors**: Tailored status line colors
- **Chezmoi Variables**: Theme elements managed via Chezmoi data

### ⌨️ Keybindings

Custom keybindings are organized in `tmux.keybindings.conf`:

- **SessionX Manager**: `Prefix + O` launches advanced session manager
- **Window Management**: Efficient control over windows
- **Pane Splitting & Navigation**: Easy pane manipulation
- **Session Control**: Simplified session management
- **Copy Mode**: Enhancements for text selection and copying

#### SessionX Commands (after `Prefix + O`):
- `Enter`: Switch to session or create new
- `alt+backspace`: Delete selected session  
- `Ctrl-u` / `Ctrl-d`: Scroll preview up/down
- `Ctrl-n` / `Ctrl-p`: Select next/previous item
- `Ctrl-r`: Rename session
- `Ctrl-w`: Window mode (show all windows)
- `Ctrl-x`: Search dotfiles directory
- `Ctrl-e`: Expand current directory for local sessions
- `Ctrl-b`: Back to main session list
- `Ctrl-t`: Tree mode (hierarchical view)
- `?`: Toggle preview pane

### ⏱️ Pomodoro Timer

The Pomodoro timer configuration includes:

- **Custom Durations**: Adjustable timer lengths
- **Visual Notifications**: On-screen alerts for timer events
- **Status Bar Integration**: Timer display in the status bar

## 🔗 Dependencies

- **Tmux**: Version 3.0+ required
- **Chezmoi**: For dotfiles management ([Chezmoi](https://www.chezmoi.io/))
- **fzf**: Fuzzy finder for SessionX
- **bat**: Syntax highlighting in previews
- **zoxide**: Smart directory jumping (optional but recommended)

## 🙏 Contributing


Feel free to submit issues and enhancement requests! Together we can make this terminal multiplexer configuration even better! ✨



<div align="center">
<img src="https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/135.png" width="100" />

Made with ❤️ and terminal magic
</div>

