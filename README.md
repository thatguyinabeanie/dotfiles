# 🏠 Dotfiles

A modern, feature-rich dotfiles configuration managed with [chezmoi](https://www.chezmoi.io/), featuring a carefully curated selection of tools and configurations for an optimal development environment.

## ✨ Features

- 🛠️ **Shell Environment**
  - Primary shell: [Nushell](https://www.nushell.sh/) with ZSH fallback
  - Customized prompt using [Starship](https://starship.rs/)
  - Smart directory navigation with [Zoxide](https://github.com/ajeetdsouza/zoxide)

- 📝 **Development Tools**
  - [Neovim](https://neovim.io/) with LazyVim configuration
  - [Git](https://git-scm.com/) with delta diff viewer
  - [GitHub CLI](https://cli.github.com/) with custom aliases
  - [mise](https://mise.jdx.dev/) for runtime version management

- 🎨 **Theming**
  - [Catppuccin](https://github.com/catppuccin) theme integration across all tools
  - Configurable opacity and blur settings
  - Custom font configuration (default: Dank Mono)

- 📊 **Development Utilities**
  - [K9s](https://k9scli.io/) for Kubernetes cluster management
  - [btop](https://github.com/aristocratos/btop) for system monitoring
  - [Yazi](https://yazi-rs.github.io/) modern file manager
  - [Pipeline.nvim](https://github.com/topaxi/pipeline.nvim) for CI integration

- 📝 **Note-taking**
  - [Obsidian](https://obsidian.md/) integration with vault management
  - Git-based sync for multiple vaults

## 🚀 Installation

1. Clone and install:
```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply thatguyinabeanie
```

2. The installation script will prompt for:
   - Git configuration (name, email, GitHub username)
   - Shell preference (nu/zsh)
   - Catppuccin theme flavor
   - Work/Personal environment setup

## 🔧 Configuration

The configuration is managed through several key files:

- `.chezmoi.toml.tmpl`: Core configuration and user preferences
- `.chezmoiexternal.toml.tmpl`: External dependencies and git repositories
- `.chezmoidata/*.yaml`: Tool-specific configurations

### 📦 Package Management

- macOS: Homebrew packages defined in `.chezmoidata/homebrew.yaml`
- Runtime versions: managed by mise, configured in `.chezmoidata/mise.yaml`

## 🔄 Updates

To update your dotfiles:

```bash
# Pull and apply changes
chezmoi update

# Update external dependencies
chezmoi upgrade
```

## 🛠️ Customization

### Adding New Tools

1. Add the package to `.chezmoidata/homebrew.yaml`
2. Create configuration in `dot_config/tool_name/`
3. Add any external dependencies to `.chezmoiexternal.toml.tmpl`

### Modifying Existing Configurations

Most configurations are templated and can be customized through `.chezmoi.toml.tmpl` variables.

## 📝 License

MIT License - feel free to use and modify as needed!
