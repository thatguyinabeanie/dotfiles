<!-- markdownlint-disable MD033 -->
<div align="center">
<!-- markdownlint-enable MD033 -->

# 🖥️ Tmux Configuration 🔄

A modern and functional Tmux configuration with Catppuccin theme integration, custom keybindings, and productivity features.

<!-- markdownlint-disable MD013 MD045 -->
<img src="https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/137.png" width="150" />
<!-- markdownlint-enable MD013 MD045 -->

![Tmux](https://img.shields.io/badge/Tool-Tmux_3.0+-blue?style=flat-square&logo=tmux)
![Theme](https://img.shields.io/badge/Theme-Catppuccin-pink?style=flat-square)
![Chezmoi](https://img.shields.io/badge/Managed_with-Chezmoi-blue?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-yellow?style=flat-square)

<!-- markdownlint-disable MD033 -->
</div>
<!-- markdownlint-enable MD033 -->

## 🌟 Features

### 🎨 Theme

<!-- markdownlint-disable MD013 MD045 -->
<img src="https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/133.png" width="50" align="right" />
<!-- markdownlint-enable MD013 MD045 -->

- Catppuccin theme integration
- Transparent background support
- Custom status line

### ⚡ Productivity

- Pomodoro timer integration
- Custom keybindings
- Enhanced status bar
- Session management

## 📁 Configuration Structure

The configuration is split into multiple files for better organization:

```shell
tmux/
├── 📝 tmux.conf - Main configuration file
├── ⌨️ tmux.keybindings.conf - Custom keybindings
├── ⏱️ tmux.pomodoro.conf - Pomodoro timer settings
├── 📊 tmux.status.conf - Status bar configuration
└── 🎨 tmux.theme.catppuccin.conf.tmpl - Theme configuration (Chezmoi template)
```

## 🌠 Installation

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

<!-- markdownlint-disable MD013 MD045 -->
<img src="https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/134.png" width="50" align="right" />
<!-- markdownlint-enable MD013 MD045 -->

The configuration uses Catppuccin theme with:

- Transparent background support
- Custom status line colors
- Theme variables managed through Chezmoi

### ⌨️ Keybindings

Custom keybindings are organized in `tmux.keybindings.conf`:

- Window management
- Pane splitting and navigation
- Session management
- Copy mode enhancements

### ⏱️ Pomodoro Timer

The Pomodoro timer configuration includes:

- Custom timer durations
- Visual notifications
- Status bar integration

## 🌍 Dependencies

- Tmux 3.0+
- [Chezmoi](https://www.chezmoi.io/) (for dotfiles management)

## 🌠 Contributing

Feel free to submit issues and enhancement requests! Together we can make this terminal multiplexer configuration even better! ✨

<!-- markdownlint-disable MD033 MD013 MD045 -->
<div align="center">
<img src="https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/135.png" width="100" />

Made with ❤️ and terminal magic
</div>
<!-- markdownlint-enable MD033 MD013 MD045 -->
