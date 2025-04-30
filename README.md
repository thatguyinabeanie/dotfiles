<!-- markdownlint-disable MD033 -->
<div align="center">
<!-- markdownlint-enable MD033 -->

<!-- markdownlint-disable MD013 MD040 -->
```
                      .              .
                     ,O.            ,O,
                    ,OOO\          /OOO,
                   ,OOOOO\        /OOOOO,
                  ,OOOOOOO\      /OOOOOOO,
                 ,OOOOOOOOO\    /OOOOOOOOO,
           ⭐️   ,OOOOOOOOOOO\  /OOOOOOOOOOO,   🌌
               ,OOOOOOOOOOOOO\/OOOOOOOOOOOOO,
              ,OOOOOOOOOOOOOOOOOOOOOOOOOOOOOO,
             ,OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO,
            ,OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO,
           ,OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO,
          ,OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO,
         ,OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO,
        ,OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO,
       ,OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO,
      ,OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO,
     ,OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO,
    ,OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO,
   ,OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO,
  ,OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO,
 ,OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO,
 ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
                 D O T F I L E S
         ✨ Cosmic Development Environment ✨
 _________________________________________________________________
```
<!-- markdownlint-enable MD013 MD040 -->

# ⭐️ Dotfiles 🌌

<!-- markdownlint-disable MD013 -->
My personal dotfiles managed with [Chezmoi](https://www.chezmoi.io/), featuring a modern and efficient development environment setup that's out of this world 🚀
<!-- markdownlint-enable MD013 -->

<!-- markdownlint-disable MD013 MD045 -->
<img src="https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/789.png" width="150" />
<!-- markdownlint-enable MD013 MD045 -->

## 🎬 Demo

<!-- markdownlint-disable MD033 -->
<div align="center">
<!-- markdownlint-enable MD033 -->

*A cosmic journey through my development environment*

<!-- Replace this with your actual GIF once created -->
[Animated demo of the dotfiles in action will appear here]

**See it in action:** Nushell, Neovim, Tmux, and more with Catppuccin theming

<!-- markdownlint-disable MD033 -->
</div>
<!-- markdownlint-enable MD033 -->

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

## 🎨 Theme Showcase

<!-- markdownlint-disable MD013 -->
Experience the beauty of Catppuccin in four delicious flavors that transform your development environment:
<!-- markdownlint-enable MD013 -->

<div align="center">

| Mocha (Dark) | Macchiato (Dark) | Frappe (Dark) | Latte (Light) |
|:------------:|:----------------:|:-------------:|:-------------:|
| [Placeholder] | [Placeholder] | [Placeholder] | [Placeholder] |
| Rich dark background with vibrant accents | Balanced dark theme with medium contrast | Cozy dark theme with lower contrast | Creamy light theme for daytime coding |

</div>

> **Note:** Replace [Placeholder] with actual screenshots of your environment in each theme variant.

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
