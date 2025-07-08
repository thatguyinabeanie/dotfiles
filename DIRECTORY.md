# 📂 Repository Directory Map

Welcome to the **dotfiles** repository! This document provides a visual and descriptive map of the project structure.
Explore how everything fits together and what each part is for.

---

## 🗺️ Directory Structure (ASCII Tree)

```text
dotfiles/
├── .github/                        # GitHub Actions workflows and issue templates
├── assetts/                        # Art, ASCII, and other assets for theming or docs
│   └── ascii-art/
│       └── dotfiles/               # ASCII art for documentation or theming
├── MISSION_CONTROL/                # Main dotfiles, configs, scripts, and tests
│   ├── .chezmoidata/               # Chezmoi-specific data
│   ├── .chezmoiscripts/            # Custom scripts run by chezmoi (e.g., precommit)
│   │   └── precommit/              # Pre-commit hook scripts
│   ├── .chezmoitemplates/          # Templated config files for dynamic setup
│   ├── .tests/                     # Helpers and integration/unit tests
│   │   ├── helpers/                # Test helpers
│   │   ├── integration/            # Integration tests
│   │   │   └── scripts/            # Integration test scripts
│   │   └── unit/                   # Unit tests
│   ├── dot_cache/                  # Cache directories for tools
│   │   └── carapace/               # Carapace cache
│   ├── dot_config/                 # App configs (Neovim, Tmux, Starship, etc.)
│   │   ├── 1Password/              # 1Password config
│   │   │   └── private_ssh/        # 1Password SSH keys
│   │   ├── bat/                    # Bat config
│   │   ├── btop/                   # Btop config
│   │   ├── chezmoi/                # Chezmoi config
│   │   │   └── encryption/         # Chezmoi encryption config
│   │   ├── code/                   # VS Code config
│   │   ├── code-insiders/          # VS Code Insiders config
│   │   ├── fastfetch/              # Fastfetch config
│   │   ├── ghostty/                # Ghostty terminal config
│   │   ├── git/                    # Git config
│   │   │   └── hooks/              # Git hooks
│   │   ├── gitleaks/               # Gitleaks config
│   │   ├── k9s/                    # K9s config
│   │   ├── karabiner/              # Karabiner config
│   │   ├── kitty/                  # Kitty terminal config
│   │   ├── lefthook/               # Lefthook config
│   │   ├── mise/                   # Mise config
│   │   ├── nushell/                # Nushell config
│   │   ├── nvim/                   # Neovim config
│   │   │   ├── .lazyextras/        # Neovim lazy extras
│   │   │   └── lua/
│   │   │       ├── config/         # Neovim Lua config
│   │   │       └── plugins/        # Neovim plugins
│   │   │           ├── ci/         # CI plugins
│   │   │           ├── git/        # Git plugins
│   │   │           ├── llm/        # LLM plugins
│   │   │           ├── lsp/        # LSP plugins
│   │   │           ├── utilities/  # Utility plugins
│   │   │           └── visuals/    # Visual plugins
│   │   ├── obsidian/               # Obsidian config
│   │   ├── starship/               # Starship prompt config
│   │   ├── tmux/                   # Tmux config
│   │   ├── wallpapers/             # Wallpapers
│   │   ├── yazi/                   # Yazi file manager config
│   │   └── zsh/                    # Zsh config
│   ├── dot_local/                  # User-level data and scripts
│   │   └── share/
│   │       └── nushell/
│   │           └── vendor/
│   │               └── autoload/   # Nushell autoload scripts
│   ├── dot_personal/               # Personal files
│   ├── dot_rustup/                 # Rustup data
│   ├── dot_scratch/                # Scratch space
│   ├── empty_dot_config/           # Empty template directories for new configs
│   │   └── empty_obsidian/
│   │       └── empty_obsidian-vault/ # Personal vault directory
│   ├── Library/                    # macOS Library files (fonts, agents, etc.)
│   │   ├── Application Support/
│   │   │   ├── nushell/
│   │   │   └── private_Cursor/
│   │   │       └── User/
│   │   ├── fonts/                  # Custom fonts
│   │   └── LaunchAgents/           # macOS launch agents
│   ├── obsidian/                   # Obsidian vaults and related config
│   ├── private_dot_ssh/            # Private SSH keys (secure, not tracked)
│   └── source/                     # Source files
├── .chezmoiroot                    # Marker file for chezmoi root
├── .gitignore                      # Git ignore rules
├── .markdown-link-check.json        # Markdown link checker config
├── .vale.ini                       # Vale prose linting config
├── .pre-commit-config.yaml         # Pre-commit hook config
├── .yamllint.yml                   # YAML linting config
├── CONTRIBUTING.md                 # Contributing guide
├── CROSS_SHELL_DOTFILES_PLAN.md    # Cross-shell setup plan
├── DIRECTORY.md                    # This directory map
├── install.sh                      # Bootstrap script for new machines
├── lefthook.yml                    # Lefthook config for git hooks
├── LICENSE                         # License for the project
├── README.md                       # Main project overview and instructions
├── SECURITY.md                     # Security policy
└── TODO.md                         # Project todos and ideas
```

---

## 📝 Key Directory & File Descriptions

- **.github/**: GitHub Actions workflows and issue templates.
- **assetts/**: Art, ASCII, and other assets for theming or documentation.
- **MISSION_CONTROL/**: The heart of your dotfiles. Contains all configuration, scripts, templates, and test helpers.
  - **dot_config/**: App configs (Neovim, Tmux, Starship, etc.)
  - **dot_cache/**: Cache directories for tools.
  - **dot_local/**: User-level data and scripts.
  - **.chezmoidata/**: Chezmoi-specific data.
  - **.chezmoiscripts/**: Custom scripts run by chezmoi (e.g., precommit hooks).
  - **.chezmoitemplates/**: Templated config files for dynamic setup.
  - **.tests/**: Helpers and integration/unit tests for your setup.
  - **obsidian/**: Obsidian vaults and related config.
  - **private_dot_ssh/**: Private SSH keys (secure, not tracked).
  - **empty_dot_config/**: Empty template directories for new configs.
  - **Library/**: macOS-specific Library files (fonts, agents, etc.).
- **.chezmoiroot**: Marker file for chezmoi root.
- **install.sh**: Bootstrap script for new machines.
- **README.md**: Main project overview and instructions.
- **CONTRIBUTING.md**: How to contribute to this repo.
- **LICENSE**: License for the project.
- **.todo/**: Project todos and ideas.

---

> Remember to keep your directory map up to date as your repo evolves!
