<!-- markdownlint-disable MD033 -->
<div align="center">
<!-- markdownlint-enable MD033 -->

# 📝 Obsidian Configuration 🧠

A personalized Obsidian setup for knowledge management and note-taking, integrated with Neovim for enhanced editing capabilities.

<!-- markdownlint-disable MD013 MD045 -->
<img src="https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/151.png" width="150" />
<!-- markdownlint-enable MD013 MD045 -->

![Obsidian](https://img.shields.io/badge/Tool-Obsidian-purple?style=flat-square&logo=obsidian)
![Neovim](https://img.shields.io/badge/Editor-Neovim-green?style=flat-square&logo=neovim)
![Chezmoi](https://img.shields.io/badge/Managed_with-Chezmoi-blue?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-yellow?style=flat-square)

<!-- markdownlint-disable MD033 -->
</div>
<!-- markdownlint-enable MD033 -->

## 🌟 Features

### 📚 Vault Management

<!-- markdownlint-disable MD013 MD045 -->
<img src="https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/150.png" width="50" align="right" />
<!-- markdownlint-enable MD013 MD045 -->

- Multiple vault support
- Custom vault organization
- Neovim integration

### 🔌 Plugin Configuration

- Core plugins
- Community plugins
- Custom settings

### 🎨 Theme and Styling

- Custom CSS snippets
- Theme settings
- Layout preferences

## 📁 Configuration Structure

The configuration is managed through Chezmoi:

```shell
obsidian/
├── 🗄️ .chezmoidata/gitrepos.yaml - Vault repository configurations
├── 🔗 .chezmoiexternal.toml.tmpl - External template configuration
├── 📝 Vault-specific configurations
└── 🔌 Plugin settings
```

## 🌠 Installation

1. Clone this configuration using Chezmoi:

   ```shell
   chezmoi init --apply
   ```

2. Obsidian will be automatically installed via Homebrew during the Chezmoi setup process, as it's defined in the shared casks.

3. Open your vaults in Obsidian

## ⚙️ Customization

### 📚 Vault Management

- Multiple vault support
- Custom vault organization
- Neovim integration for editing

### 🔌 Plugin Settings

Configured plugins include:

- Core plugins
- Community plugins
- Custom settings

### 🎨 Theme and Styling

- Custom CSS snippets
- Theme settings
- Layout preferences

## 🔄 Neovim Integration

<!-- markdownlint-disable MD013 MD045 -->
<img src="https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/149.png" width="50" align="right" />
<!-- markdownlint-enable MD013 MD045 -->

The configuration includes Neovim integration for enhanced editing:

- Custom commands for vault access
- Plugin support
- Syntax highlighting
- LSP integration

## 🌍 Dependencies

- [Obsidian](https://obsidian.md/)
- [Neovim](https://neovim.io/)
- [Chezmoi](https://www.chezmoi.io/) (for dotfiles management)

## 🌠 Contributing

Feel free to submit issues and enhancement requests! Together we can make this knowledge management system even better! ✨

<!-- markdownlint-disable MD033 MD013 MD045 -->
<div align="center">
<img src="https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/152.png" width="100" />

Made with ❤️ and knowledge power
</div>
<!-- markdownlint-enable MD033 MD013 MD045 -->
