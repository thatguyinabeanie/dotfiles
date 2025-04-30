<!-- markdownlint-disable MD033 -->
<div align="center">
<!-- markdownlint-enable MD033 -->

# ⭐️ Dotfiles 🌌

<!-- markdownlint-disable MD013 -->
My personal dotfiles managed with [Chezmoi](https://www.chezmoi.io/), featuring a modern and efficient development environment setup that's out of this world 🚀
<!-- markdownlint-enable MD013 -->

<!-- markdownlint-disable MD013 MD045 -->
<img src="https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/789.png" width="150" />
<!-- markdownlint-enable MD013 MD045 -->

![Shell](https://img.shields.io/badge/Shell-Nushell-blue?style=flat-square&logo=gnu-bash)
![Editor](https://img.shields.io/badge/Editor-Neovim-green?style=flat-square&logo=neovim)
![Theme](https://img.shields.io/badge/Theme-Catppuccin-pink?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-yellow?style=flat-square)
![Tests](https://github.com/thatguyinabeanie/dotfiles/actions/workflows/test.yml/badge.svg)
![Lint](https://github.com/thatguyinabeanie/dotfiles/actions/workflows/lint.yml/badge.svg)
![Security](https://github.com/thatguyinabeanie/dotfiles/actions/workflows/security.yml/badge.svg)

<!-- markdownlint-disable MD033 -->
</div>
<!-- markdownlint-enable MD033 -->

## 🌟 Event Horizon

One command to cross the event horizon and pull in all configurations:

<!-- markdownlint-disable MD040 -->
```
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply thatguyinabeanie
```
<!-- markdownlint-enable MD040 -->

## 🌠 Cosmic Variables

During installation, you'll be prompted for several configuration values that will shape your universe:

| Variable | Description | Default |
|----------|-------------|---------|
| `WORK_ENVIRONMENT` | Enable work-specific configurations | `false` |
| `SHELL` | Preferred shell (nu/zsh) | `nu` |
| `CATPPUCCIN_FLAVOR` | Theme variant (mocha/macchiato/frappe/latte) | `mocha` |
| `GIT_NAME` | Git commit author name | - |
| `GIT_EMAIL` | Git commit author email | - |
| `GITHUB_USERNAME` | GitHub username | - |

## ⚡ Features

### 🚀 Modern Development Environment

<!-- markdownlint-disable MD013 MD045 -->
<img src="https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/25.png" width="50" align="right" />
<!-- markdownlint-enable MD013 MD045 -->

- Nushell for enhanced shell experience
- Neovim for efficient editing
- Tmux for terminal multiplexing
- Git for version control

### 📝 Knowledge Management

<!-- markdownlint-disable MD013 MD045 -->
<img src="https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/790.png" width="50" align="right" />
<!-- markdownlint-enable MD013 MD045 -->

- Obsidian for note-taking
- Multiple vault support
- Neovim integration

### ⚡ Productivity Tools

<!-- markdownlint-disable MD013 MD045 -->
<img src="https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/774.png" width="50" align="right" />
<!-- markdownlint-enable MD013 MD045 -->

- K9s for Kubernetes management
- Yazi for file management
- Fastfetch for system info
- Custom Pokemon system info display

## 🌌 Configuration Structure

```shell
dotfiles/
├── 🌟 ROOT/
│   ├── 🚀 dot_config/
│   │   ├── nvim/
│   │   ├── obsidian/
│   │   ├── tmux/
│   │   └── ...
│   └── ...
└── 🌠 .chezmoi.toml.tmpl
```

## 🌍 Dependencies

- [Chezmoi](https://www.chezmoi.io/) - Dotfile manager
- [Nushell](https://www.nushell.sh/) - Modern shell
- [Neovim](https://neovim.io/) - Text editor
- [Obsidian](https://obsidian.md/) - Knowledge management
- [Homebrew](https://brew.sh/) - Package manager

## 🌠 Contributing

<!-- markdownlint-disable MD013 -->
Feel free to submit issues and enhancement requests! Together we can make this configuration shine brighter than a supernova! ✨
<!-- markdownlint-enable MD013 -->

## 📜 License

MIT License - See [LICENSE](LICENSE) for details

<!-- markdownlint-disable MD033 MD013 MD045 -->
<div align="center">
<img src="https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/792.png" width="100" />

Made with ❤️ and cosmic energy
</div>
<!-- markdownlint-enable MD033 MD013 MD045 -->
