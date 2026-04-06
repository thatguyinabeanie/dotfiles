# ⭐️ Dotfiles 🌌

## Intro

Personal dotfiles managed with [Chezmoi](https://www.chezmoi.io/), featuring a modern and efficient development environment setup out of this world 🚀

![Cosmoem](https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/789.png)

## 🎬 Demo

### A cosmic journey

A cosmic journey through the development environment

[Animated demo of the dotfiles in action appears here]

![Demo Coming Soon](https://img.shields.io/badge/Demo_Coming_Soon-black?style=for-the-badge)

**See it in action**: zsh, Neovim, Tmux, and more with Catppuccin theming

![Shell](https://img.shields.io/badge/Shell-Zsh-blue?style=flat-square&logo=gnu-bash)
![Editor](https://img.shields.io/badge/Editor-Neovim-green?style=flat-square&logo=neovim)
![Theme](https://img.shields.io/badge/Theme-Catppuccin-pink?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-yellow?style=flat-square)
![Lint](https://img.shields.io/github/actions/workflow/status/gmendoza/dotfiles/lint.yml?label=Lint&style=flat-square)
![Security](https://img.shields.io/github/actions/workflow/status/gmendoza/dotfiles/security.yml?label=Security&style=flat-square)

## 🌟 Event horizon

One command to cross the event horizon and pull in all configurations:

### Personal setup

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin init --apply gmendoza
```

### Work environment setup

```bash
curl -fsLS get.chezmoi.io | WORK_ENVIRONMENT=true sh -s -- -b ~/.local/bin init --apply gmendoza
```

[![View Installation Guide](https://img.shields.io/badge/View_Installation_Guide-22863a?style=for-the-badge)](#-event-horizon)

## 🌠 Cosmic variables

During installation, the system prompts for configuration values that shape your universe:

| Variable            | Description                                  | Default |
| ------------------- | -------------------------------------------- | ------- |
| `WORK_ENVIRONMENT`  | Enable work-specific configurations          | `false` |
| `SHELL`             | Preferred shell (zsh/bash)                   | `zsh`   |
| `CATPPUCCIN_FLAVOR` | Theme variant (mocha/macchiato/frappe/latte) | `mocha` |
| `GIT_NAME`          | Git commit author name                       | -       |
| `GIT_EMAIL`         | Git commit author email                      | -       |
| `GITHUB_USERNAME`   | GitHub username                              | -       |

## 📦 Installation profiles

Tools and apps are organized into **profiles** that describe different parts of the setup. Profile-based selective installation is a **work in progress**: current install scripts may still install most tools regardless of profile activation until the installers are fully profile-aware.

### Available profiles

| Profile | What it includes |
| ------- | ---------------- |
| `default` | Always active. Core shell tools, neovim, tmux, git, Node/Python/Go/Rust, essential GUI apps (Ghostty, Chrome, Raycast, Aerospace, Claude, 1Password) |
| `creative` | Ableton Live, Affinity, Blender, DaVinci Resolve, darktable, OBS |
| `3d-printing` | OrcaSlicer, FreeCAD, OpenSCAD, MeshLab |
| `editors` | Cursor, VS Code Insiders, Zed, Kitty, Helix, Zellij, Fish shell |
| `productivity` | Obsidian, Slack, Firefox, Tidal, Cyberduck, disk-inventory-x, Claude DevTools |
| `mobile-dev` | Android Studio, Expo Orbit |
| `infra` | AWS CLI, Terraform, kubectl, Helm, k9s, dive, CircleCI, Okta, lazydocker, Atlassian CLI, kube-linter, tflint |
| `databases` | PostgreSQL, MySQL, sql-formatter, sqlfluff |
| `languages` | Ruby, Zig, Java, Elixir, Erlang, Julia, Deno, Yarn, Gradle, Maven, and their LSPs/linters/formatters |
| `publishing` | MacTeX, Pandoc, mdbook |
| `social` | Discord, BetterDiscord installer |
| `extras` | Nice-to-have CLI tools (bottom, glances, procs, hyperfine, ncdu, gdu, etc.), extra formatters, specialty linters |

### Usage

```bash
# Fast initial install (default profile only)
chezmoi init --apply

# Activate specific profiles
ACTIVE_PROFILES=default,creative,editors chezmoi apply

# Full workstation (everything)
ACTIVE_PROFILES=default,creative,3d-printing,editors,productivity,mobile-dev,infra,databases,languages,publishing,social,extras chezmoi apply

# Persist your profile selection (survives reinstalls)
defaults write com.chezmoi.config active_profiles "default,creative,editors,productivity"
```

Profiles are additive — `default` is always active. A package matches if **any** of its profiles is active. Packages without a `profiles` field are always installed (part of `default`).

## 💾 Persistent configuration

![Porygon](https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/137.png)

This dotfiles system includes a **persistent configuration system** that ensures your preferences survive across system reinstalls and config deletions.

### 🏗️ **Architecture Overview**

The system provides three-tier configuration precedence:

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│ Environment     │───▶│ Persistent       │───▶│ Template        │
│ Variables       │    │ Storage          │    │ Defaults        │
│ (SHELL_PREF)    │    │ (macOS defaults) │    │ ("nu")          │
└─────────────────┘    └──────────────────┘    └─────────────────┘
```

1. **Environment Variables** (highest) - `export SHELL_PREF=zsh`
2. **Persistent Storage** (middle) - macOS defaults, Linux dconf/gsettings
3. **Template Defaults** (fallback) - hardcoded sensible defaults

### 🛠️ Management commands

```bash
# Backup current configuration to persistent storage
chezmoi-backup-config

# Restore configuration from persistent storage
chezmoi-restore-config

# View stored configuration (macOS example)
defaults read ai.opencode.chezmoi
```

### ⚙️ **Core Configuration Values**

#### Core Preferences

- `hostname` - System hostname
- `shell_pref` - Preferred shell (zsh, bash)
- `work_environment` - Work environment flag
- `personal_environment` - Personal environment flag
- `catppuccin_flavor` - Catppuccin theme flavor

#### Theme System

- `theme_mode` - Current theme mode (dark/light)
- `theme_light` - Light theme name
- `theme_dark` - Dark theme name

#### UI Configuration

- `ui_opacity` - Terminal opacity
- `ui_blur` - Blur amount
- `ui_font_size` - Font size
- `ui_font_family` - Font family
- `ui_window_height` - Window height
- `ui_window_width` - Window width

#### Git Configuration

- `git_name` - Git user name
- `github_username` - GitHub username
- `git_email` - Git email
- `work_org` - Work organization

### 💾 **Storage Methods**

#### macOS (Primary)

- **Method**: `defaults` command
- **Domain**: `com.chezmoi.config`
- **Location**: `~/Library/Preferences/com.chezmoi.config.plist`
- **Features**: Type-aware (string, boolean, integer)

#### Linux (Cross-platform ready)

- **dconf**: `/com/chezmoi/config/` keys
- **gsettings**: `com.chezmoi.config` schema
- **XDG config**: `~/.config/chezmoi/persistent-config` file

### 🔄 **Usage Workflows**

#### Normal Configuration Editing

1. Edit `~/.config/chezmoi/chezmoi.toml` directly
2. Run `chezmoi apply` to apply changes
3. Run `chezmoi-backup-config` to save to persistent storage

#### Recovery After Config Loss

1. Run `chezmoi-restore-config` to restore from persistent storage
2. Run `chezmoi apply` to apply restored configuration
3. Edit restored config as needed

#### Fresh System Setup

1. Run `chezmoi init` - template uses persistent values if available
2. Values automatically restored from previous machine's defaults
3. Missing values use sensible template defaults

#### Environment Override

```bash
# Temporarily override stored preference
SHELL_PREF=zsh chezmoi apply

# Permanently change preference
export SHELL_PREF=zsh
chezmoi apply
chezmoi-backup-config  # Save the change
```

### 🔧 **Troubleshooting**

#### View Current Configuration

```bash
# Check what template will generate
chezmoi execute-template < .chezmoi.toml.tmpl

# View stored values
config-persistence-helpers.sh list

# Check storage method
config-persistence-helpers.sh detect
```

#### Reset Configuration

```bash
# Clear all persistent storage
config-persistence-helpers.sh clear

# Will use template defaults on next chezmoi init
chezmoi init
```

### ✨ Key benefits

- **Durable storage** - Config survives `~/.config/chezmoi/chezmoi.toml` deletion
- **Cross-machine sync** - Restore preferences on new machines
- **Safe recovery** - Always backs up existing config before restoration
- **Platform native** - Uses macOS defaults, Linux dconf/gsettings
- **Backward compatible** - Existing workflows continue unchanged

## ⚡ Features

### 🚀 Modern development environment

![Pikachu](https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/25.png)

- **Shells**: Zsh for an enhanced command-line experience with modern features.
- **Editors**: Neovim as the primary editor, with configurations for VS Code also available.
- **Terminals**: Configurations for Kitty and Ghostty terminal emulators.
- **Multiplexing**: Tmux for powerful terminal session management.
- **Version Control**: Git, integrated with many tools and quality checks.
- **Tool Versioning**: Consistent development tool versions managed by Mise.
- **Prompt**: Highly customizable and informative prompt with Starship.

### 🛠️ Key utilities & productivity boosters

![Minior](https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/774.png)

- **System Info**: Fastfetch for detailed system information (including a custom Pokemon display!).
- **File Management**: Yazi for a fast and intuitive terminal file manager.
- **File Preview**: Bat for syntax-highlighted file viewing (`cat` with wings).
- **Resource Monitoring**: Btop for interactive monitoring of processes and system resources.
- **Kubernetes**: K9s for streamlined Kubernetes cluster management.
- **Git Hooks**: Automated code quality, linting, and security checks managed by Lefthook (detailed in its own section below).

### 🧩 Per-project Neovim configuration

LazyVim extras can be loaded on a per-project basis using lazy.nvim's built-in `.lazy.lua` support. Place a `.lazy.lua` file in your project root that returns a plugin spec:

```lua
-- .lazy.lua (in your project root)
return {
  { import = "lazyvim.plugins.extras.lang.zig" },
  { import = "lazyvim.plugins.extras.lang.docker" },
}
```

Neovim will prompt you to trust the file on first open. Once trusted, those extras load only when editing in that directory. This keeps your global config lean — only universal extras (json, yaml, markdown, etc.) in `.lazyvim.json`, language-specific ones scoped to projects.

> **Reference**: [LazyVim/LazyVim#2115](https://github.com/LazyVim/LazyVim/pull/2115) — now a default feature in lazy.nvim

[![Explore All Features](https://img.shields.io/badge/Explore_All_Features-4A55A5?style=for-the-badge)](#-features)

## 🌌 Configuration Structure

The dotfiles are organized around a powerful, modular data system managed by Chezmoi. At its core is a flat and granular data structure in the `.chezmoidata/` directory, where each file defines a specific domain of the development environment (e.g., `lsp.yaml`, `formatters.yaml`, `tools.yaml`).

This data is consumed by a **Template Factory System** located in `.chezmoitemplates/`. These templates act as generators, transforming the raw data into tool-specific configurations. This architecture ensures a single source of truth for all packages and settings, with changes automatically propagating to all relevant parts of the system.

```shell
dotfiles/
├── 🔭 .chezmoidata/             # Flat, granular YAML data files
│   ├── ai/                     # AI-specific configurations
│   │   ├── agents.yaml
│   │   ├── mcp.yaml
│   │   └── ...
│   ├── lsp.yaml
│   ├── formatters.yaml
│   ├── tools.yaml
│   └── ... (20+ other specific data files)
├── 🏭 .chezmoitemplates/         # Template factory for generating configs
│   ├── nvim/
│   ├── mise/
│   ├── brew/
│   └── ...
├── 🚀 dot_config/                 # Final, generated configuration files
│   ├── nvim/
│   ├── tmux/
│   └── ...
├── 💾 .scripts/                   # Utility and installation scripts
├── 📚 .docs/                      # In-depth documentation
└── 🌠 .chezmoi.toml.tmpl         # Main chezmoi configuration
```

### 📋 **Detailed .chezmoidata Organization**

The configuration data is organized into **27 ultra-specific files**. This flat structure allows for clear, direct access in templates (e.g., `.lsp.language_servers`, `.formatters.formatters`).

- **`lsp.yaml`**: All language servers with metadata.
- **`formatters.yaml`**: All code formatters and their language mappings.
- **`linters.yaml`**: All linters with language/runtime info.
- **`parsers.yaml`**: All TreeSitter parsers for syntax highlighting.
- **`tools.yaml`**: All general development tools, CLIs, and utilities (including AI agents and MCP servers).
- **`ai/agents.yaml`**: All AI agents and their installation details.
- **`ai/mcp.yaml`**: All Model Context Protocol (MCP) servers.
- **`github-extensions.yaml`**: All GitHub CLI extensions.
- **`services.yaml`**: System services and application configurations.
- **`opencode.yaml`**: OpenCode AI-specific settings.
- **`shared.yaml`**, **`personal.yaml`**, **`work.yaml`**: Environment variables for different contexts.

### 🔧 **Template Integration Patterns**

Templates now access this data directly and efficiently, without complex `include` logic.

#### Loading Package Data

```go
{{/* Access all linters to be installed via brew */}}
{{- $brew_linters := (where .linters.linters "install_via" "brew") }}

{{/* Access all formatters to be installed via mise */}}
{{- $mise_formatters := (where .formatters.formatters "install_via" "mise") }}
```

#### Loading Environment Data

```go
{{/* Access a shared environment variable */}}
{{- .shared.env_shared.variables.EDITOR }}

{{/* Access a work-specific variable */}}
{{- .work.env_work.variables.AWS_PROFILE }}
```

#### Loading AI Configurations

```go
{{/* Access the OpenCode provider settings */}}
{{- .opencode.ai_opencode.providers.google.enabled }}
>>>>>>> origin/main

{{/* Loop through all AI agents */}}
{{- range .agents }}
  {{ .name }}
{{- end }}
```

This clean, declarative system makes adding new tools or changing configurations simple, robust, and easy to maintain.

## 🎨 Theme control system

This dotfiles configuration features an advanced theme management system that gives you complete control over your development environment's appearance across all applications.

### 🎛️ Theme configuration

Control your theme experience through three simple variables in `$HOME/.config/chezmoi/chezmoi.toml`:

```toml
[data]
THEME_MODE = "system"              # Control behavior: "system", "dark", "light"
THEME_LIGHT = "catppuccin-latte"   # Your preferred light theme
THEME_DARK = "catppuccin-mocha"    # Your preferred dark theme
```

### 🌈 Theme modes

| Mode       | Behavior                                                                          | Use Case                                            |
| ---------- | --------------------------------------------------------------------------------- | --------------------------------------------------- |
| **system** | Automatically switches between light/dark themes based on macOS system appearance | Perfect for following your system's day/night cycle |
| **dark**   | Always uses your chosen dark theme                                                | For consistent dark mode experience                 |
| **light**  | Always uses your chosen light theme                                               | For consistent light mode experience                |

### 🚀 Supported applications

Both **Ghostty** and **Neovim** automatically respect your theme configuration:

- **Ghostty**: Uses native macOS system appearance detection or forces static themes
- **Neovim**: Employs auto-dark-mode plugin for system mode, static colorschemes for manual modes
- **All other apps**: Consistently themed using the centralized Catppuccin configuration

### 🎨 Available catppuccin flavors

Experience the beauty of Catppuccin in four delicious flavors:

| Theme                | Description                               | Best For              |
| -------------------- | ----------------------------------------- | --------------------- |
| catppuccin-mocha     | Rich dark background with vibrant accents | Night coding sessions |
| catppuccin-macchiato | Balanced dark theme with medium contrast  | Versatile dark theme  |
| catppuccin-frappe    | Cozy dark theme with lower contrast       | Easy on the eyes      |
| catppuccin-latte     | Creamy light theme perfect for daytime    | Daylight coding       |

### ⚡ Quick theme changes

1. Edit your theme preferences in `chezmoi.toml`
2. Run `chezmoi apply` to update all configurations
3. Restart Ghostty and Neovim to see changes
4. All applications automatically use consistent theming

> **Mix & Match**: You can use different themes for light and dark modes, for example `THEME_LIGHT = "catppuccin-latte"` and `THEME_DARK = "catppuccin-frappe"`

## 🧪 Scientific computing

![Rotom](https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/479.png)

Essential scientific Python environment with comprehensive data science tools managed through Mise:

### 📊 **Scientific Computing Stack**

The system includes essential scientific Python libraries via the cross-platform Python configuration:

#### **Core Libraries**

- **NumPy** - Numerical computing foundation
- **Pandas** - Data manipulation and analysis
- **Matplotlib** - Static plotting and visualization
- **SciPy** - Scientific computing library
- **SymPy** - Symbolic mathematics
- **Seaborn** - Statistical data visualization

#### **Development Tools**

- **Black** - Code formatter for clean, readable code
- **Pytest** - Testing framework for scientific code
- **MyPy** - Static type checking
- **Debugpy** - Python debugger adapter

### 🚀 **Quick Start Example**

```python
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

# Generate sample data
x = np.linspace(0, 2*np.pi, 100)
y = np.sin(x)

# Create DataFrame
data = pd.DataFrame({'x': x, 'y': y})

# Plot results
plt.figure(figsize=(10, 6))
plt.plot(data['x'], data['y'], 'b-', linewidth=2)
plt.title('Sine Wave')
plt.xlabel('x')
plt.ylabel('sin(x)')
plt.grid(True, alpha=0.3)
plt.show()

# Statistical analysis
print(f"Mean: {data['y'].mean():.3f}")
print(f"Std:  {data['y'].std():.3f}")
data.describe()
```

### 🛠️ **Environment Setup**

Python scientific packages are automatically installed through the Mise configuration:

```bash
# Scientific packages are installed via mise
mise install python@3.12

# Start Python with scientific stack
python3
# >>> import numpy as np
# >>> import pandas as pd
# >>> import matplotlib.pyplot as plt
```

The configuration ensures a consistent scientific computing environment across all your projects.

## 🌍 Dependencies

- [Chezmoi](https://www.chezmoi.io/) - Dotfile manager
- [Zsh](https://www.zsh.org/) - Modern shell
- [Neovim](https://neovim.io/) - Text editor
- [Homebrew](https://brew.sh/) - Package manager

### ⚙️ **Mise Integration & Dependency Management**

Comprehensive runtime and dependency management using Mise, providing consistent development environments across projects and machines.

#### 🏗️ **Architecture Overview**

The Mise configuration is dynamically generated from the granular data files in `.chezmoidata/`. A dedicated template, `dot_config/mise/config.toml.tmpl`, gathers all tools that specify `install_via: mise` from `tools.yaml`, `linters.yaml`, `formatters.yaml`, etc., and compiles them into a single `config.toml` for Mise to consume.

```text
Dotfiles Mise Integration:
├── Configuration Data (.chezmoidata/)
│   ├── tools.yaml
│   ├── linters.yaml
│   ├── formatters.yaml
│   └── ... (all files with `install_via: mise`)
├── Generated Configuration
│   └── dot_config/mise/config.toml.tmpl  # Main mise configuration generator
├── Installation Scripts
│   ├── .chezmoiscripts/mise/run_once_before-01-install-mise.sh.tmpl
│   └── .chezmoiscripts/mise/run_onchange_after_mise-install-packages.sh.tmpl
└── Automation
    └── LaunchAgent files                 # Auto-update scheduling
```

#### ⚙️ **Configuration Data Structure**

Tools are defined in their respective granular data files with an `install_via` key.

**Example from `.chezmoidata/tools.yaml`**:

```yaml
dev_tools:
  - name: age
    install_via: mise
    version: latest
  - name: act
    install_via: mise
    version: latest
  - name: ast-grep
    install_via: mise
    version: latest
  # ... other development utilities
```

The main configuration template then collects all these definitions to build the final `config.toml`.

### 🚀 **Usage Examples**

#### Basic Commands

```bash
# Install a language version
mise install python@3.12
mise install node@20

# Set global versions
mise use -g python@3.12
mise use -g node@20

# Set project-specific versions
mise use python@3.11        # Creates .mise.toml in current dir
mise use node@18

# List installed versions
mise list python
mise list node

# Show current versions
mise current
```

#### Project-Specific Configuration

```bash
# Navigate to project
cd my-python-project

# Set specific versions for this project
mise use python@3.11 node@18

# This creates .mise.toml:
[tools]
python = "3.11"
node = "18"

# Install project dependencies (automatic with hook)
mise install
```

#### Environment Variables

```bash
# Set project-specific environment variables
mise set DATABASE_URL=postgres://localhost/mydb
mise set DEBUG=true

# View current environment
mise env

# Execute command with mise environment
mise exec -- python manage.py runserver
```

### 🔧 **Advanced Features**

#### Task Runner

```toml
# In project .mise.toml
[tasks.test]
run = "pytest tests/"

[tasks.format]
run = ["black .", "isort ."]

[tasks.lint]
run = "flake8 ."
```

```bash
# Run tasks
mise run test
mise run format
mise run lint
```

#### Environment Templates

```toml
# Global template in config.toml
[env]
PROJECT_ROOT = "{{cwd}}"
PYTHON_PATH = "{{exec_path}}/python"
NODE_PATH = "{{exec_path}}/node"
```

#### Python Project Hook

The system automatically detects Python projects and sets up environments:

```bash
# Automatically triggered when entering Python projects
# - Installs requirements.txt dependencies
# - Sets up pre-commit hooks
# - Configures virtual environments
```

### 📦 **Package Management**

#### Python Packages

Global packages are automatically installed via the `cross-platform-python.yaml` configuration:

```yaml
# Scientific Computing
packages:
  - numpy
  - pandas
  - matplotlib
  - jupyter
  - ipython
```

#### Development Tools

```bash
# Install global development tools
mise install age@latest
mise install act@latest
mise install ast-grep@latest
```

### 🔍 **Troubleshooting**

#### Common Issues

**Tools Not Found**

```bash
# Check mise installation
mise doctor

# Verify shell integration
echo $PATH | grep mise

# Reinstall shell integration
mise activate zsh >> ~/.zshrc
```

**Version Conflicts**

```bash
# Check active versions
mise current

# Force refresh
mise reshim

# Clear cache
mise cache clear
```

**Python Package Issues**

```bash
# Check Python environment
mise exec python -- which python
mise exec python -- pip list

# Reinstall packages
chezmoi apply  # Reapplies python configuration
```

### 📊 **Monitoring & Maintenance**

#### Version Tracking

```bash
# Check for updates
mise outdated

# Update all tools
mise upgrade

# Update specific tool
mise upgrade python
```

#### Health Checks

```bash
# Comprehensive system check
mise doctor

# Check specific installation
mise which python
mise which node
```

#### Cleanup

```bash
# Remove unused versions
mise prune

# Clean cache
mise cache clear

# Remove specific version
mise uninstall python@3.10
```

## 🌠 Contributing

Submit issues and enhancement requests to help make this configuration shine brighter than a supernova.

## 💡 Ideas

- Managing aliases across different shells with chezmoi templates and a chezmoidata yaml

![Lunala](https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/792.png)

Made with ❤️ and cosmic energy

![Explore the Cosmos](https://img.shields.io/badge/Explore_the_Cosmos-000000?style=for-the-badge&logo=github&logoColor=white)

## 🛡️ Git hooks & code quality

This repository uses [Lefthook](https://github.com/evilmartians/lefthook) to manage all Git hooks for comprehensive code quality, linting, and security checks.

### 🚀 **Running Hooks**

```bash
# Hooks run automatically on git commit
git commit -m "your changes"

# Run all pre-commit hooks manually
lefthook run pre-commit

# Install hooks after cloning (automatic via mise)
mise run setup-hooks
```

### ⚙️ **Configured Quality Checks**

#### **Code Quality & Formatting**

- **Stylua** - Lua code formatting (auto-fixes staging)
- **Luacheck** - Lua static analysis and linting
- **ShellCheck** - Shell script analysis and best practices
- **Go Lint** - golangci-lint for Go code quality
- **Prettier with Go Template Support** - Formats Chezmoi template files (.tmpl) using prettier-plugin-go-template

#### **Documentation & Writing**

- **Vale** - Prose linting for Markdown files
- **Spell Check** - Sorted spell dictionary maintenance

#### **Security & Compliance**

- **Gitleaks** - Prevents secrets and sensitive data from being committed
- **YAML Validation** - (Optional) Schema validation for YAML files

### 🔧 **Lefthook Configuration**

All hooks run in parallel for fast feedback:

```yaml
pre-commit:
  parallel: true
  commands:
    vale:
      glob: "**/*.md"
      run: vale --config .vale.ini {staged_files}
    shellcheck:
      run: .scripts/hooks/pre-commit-shellcheck.sh {staged_files}
    stylua:
      glob: "**/*.lua"
      run: .scripts/hooks/pre-commit-stylua.sh {staged_files}
      stage_fixed: true # Auto-stage formatting fixes
    gitleaks:
      run: gitleaks protect --staged --no-banner --log-level=error
```

### 📁 **Hook Scripts Location**

Individual hook scripts are organized in `.scripts/hooks/`:

```
.scripts/hooks/
├── pre-commit-shellcheck.sh      # Shell script validation
├── pre-commit-golangci-lint.sh   # Go code quality
├── pre-commit-stylua.sh          # Lua formatting
├── pre-commit-luacheck.sh        # Lua linting
└── pre-commit-sort-spell.sh      # Spell dictionary management
```

### ⚡ **Performance Features**

- **Parallel execution** - All hooks run simultaneously
- **Staged files only** - Only checks files being committed
- **Auto-staging** - Formatting fixes are automatically staged
- **Reduced verbosity** - Clean output focusing on issues
- **Smart file targeting** - Each hook only runs on relevant file types

### 🛠️ **Customization**

#### **Enable/Disable Hooks**

```bash
# Skip all hooks for emergency commits
git commit --no-verify -m "emergency fix"

# Skip specific hook
LEFTHOOK_EXCLUDE=gitleaks git commit -m "your message"

# Run only specific hooks
lefthook run pre-commit --commands vale,shellcheck
```

#### **Add Custom Hooks**

1. Create script in `.scripts/hooks/`
2. Add to `.lefthook.yml`:

```yaml
pre-commit:
  commands:
    your-hook:
      glob: "**/*.ext"
      run: .scripts/hooks/your-hook.sh {staged_files}
      stage_fixed: false # Set to true for formatters
```

### 🚨 **Common Issues & Solutions**

#### **Hook Failures**

```bash
# View detailed output
lefthook run pre-commit --verbose

# Fix formatting issues
stylua .
git add .

# Check specific file
vale docs/README.md
shellcheck script.sh
```

#### **Setup Issues**

```bash
# Reinstall hooks
lefthook install

# Verify hook scripts are executable
chmod +x .scripts/hooks/*.sh

# Check lefthook configuration
lefthook version
```

### 📊 **Quality Gates**

The hooks enforce these quality standards:

- **Zero secrets** - Gitleaks prevents credential leaks
- **Consistent formatting** - Stylua auto-formats Lua code
- **Shell best practices** - ShellCheck enforces POSIX compliance
- **Clear prose** - Vale ensures readable documentation
- **Go code quality** - golangci-lint enforces Go best practices

This comprehensive quality system ensures every commit maintains high standards while providing fast, actionable feedback to developers.

## 🗂️ Chezmoi navigation

Quick navigation to your dotfiles directory with convenient aliases and tmux keybindings:

### Shell aliases

Zsh includes helpful aliases for working with your dotfiles:

```bash
# Change directory to chezmoi source
dotfiles_cd

# Open Neovim at chezmoi directory
dotfiles
```

### Tmux keybindings

Integrated tmux shortcuts for quick dotfiles access:

| Keybinding      | Action                                                        |
| --------------- | ------------------------------------------------------------- |
| `Ctrl+b Ctrl+d` | Create new tmux window at ~/.local/share/chezmoi              |
| `Ctrl+b Ctrl+e` | Create new tmux window at ~/.local/share/chezmoi and run nvim |

These keybindings make it easy to jump into your dotfiles configuration from any tmux session.

### 🤖 **Development Environment for AI**

Comprehensive AI toolchain with multiple providers and seamless integration. All configurations are managed through the new granular data files (`ai/agents.yaml`, `ai/mcp.yaml`, `opencode.yaml`) for a consistent and maintainable setup.

#### 🎯 **Quick Setup Guide**

##### Prerequisites

```bash
# Ensure mise and required tools are installed
mise install

# Set up necessary environment variables (see provider sections below)
export ANTHROPIC_API_KEY="your-key"
export OPENAI_API_KEY="your-key"
export GOOGLE_API_KEY="your-key"
```

##### OpenCode Configuration

The primary AI development environment uses OpenCode with flexible provider switching, configured in `.chezmoidata/opencode.yaml`.

#### 🤖 **Provider-Specific Setup**

Provider details and model configurations are now managed in their respective template files within `.chezmoitemplates/ai/`.

- **GitHub Copilot**: Models available via the Copilot integration.
- **Google Gemini**: Models defined in `provider-google.yaml`.

#### 🛠️ **Development Tools Integration**

##### **Model Context Protocol (MCP) Servers**

MCP servers are defined in `.chezmoidata/ai/mcp.yaml` and installed via Mise.

```bash
# Install MCP servers for enhanced AI capabilities
mise run install-mcp-servers

# Available servers:
mcphub list-servers
```

##### **Neovim AI Integration**

Neovim plugins like Avante, CodeCompanion, and Copilot provide a rich, integrated AI experience.

##### **Command Line Tools**

- **OpenCode**: The primary interface for AI-assisted development.
- **Claude Desktop**: Syncs project context for chat.
- **GitHub Copilot CLI**: Quick suggestions and explanations.

#### ⚙️ **Configuration Management**

Switching providers or models is as simple as editing the relevant YAML file in `.chezmoidata/` and running `chezmoi apply`.

- **`.chezmoidata/opencode.yaml`**: Change the default provider and model for OpenCode.
- **`.chezmoidata/ai/agents.yaml`**: Add or remove AI agents.
- **`.chezmoitemplates/ai/provider-*.yaml`**: Adjust model lists and parameters.

## 🛠️ Shell Productivity Features

Enhanced shell experience with powerful aliases, functions, and integrated workflows for maximum developer productivity.

### 🚀 Development Workflow Automation

#### Project Initialization

```bash
# Quick project setup with templates
dev_init_python <project-name>     # Python project with venv + requirements
dev_init_node <project-name>       # Node.js with package.json + gitignore
dev_init_rust <project-name>       # Cargo workspace with common configs
dev_init_go <project-name>         # Go module with mod file + structure

# Example: Full Python project setup
dev_init_python my-api
cd my-api
mise use python@3.12               # Auto-detected and configured
poetry install                     # Dependencies managed by mise hook
```

#### Smart Directory Navigation

```bash
# Recent project jumping (integrated with zoxide)
z my-proj          # Jump to recently used project directory
zi                 # Interactive directory selection with fzf

# Project workspace management
workspace_switch   # FZF menu for switching between active projects
workspace_list     # Show all tracked workspaces with git status
workspace_clean    # Remove unused/merged project directories

# Quick access to common directories
@config            # -> ~/.config
@dots              # -> ~/.local/share/chezmoi
@logs              # -> ~/.local/log
@bin               # -> ~/.local/bin
```

### 🔧 Git Workflow Enhancement

```bash
# Interactive emoji commits with conventional format
git_emoji_commit "add user authentication system"
# Opens FZF menu: ✨ feat: add user authentication system

# Smart branch management
git_smart_checkout              # FZF branch selector with preview
git_branch_cleanup             # Remove merged branches interactively
git_sync_fork                  # Sync fork with upstream (auto-detects)

# Advanced git operations
git_stash_save_with_message    # Stash with descriptive message
git_commit_fixup               # Quick fixup for previous commit
git_rebase_interactive_auto    # Smart interactive rebase with conflict resolution

# Repository insights
git_file_history <file>        # Visual file change history
git_contributor_stats          # Show contribution statistics
git_find_large_files          # Identify repository bloat
```

### 📊 Development Environment Management

#### Service Management

```bash
# Docker development workflow
docker_dev_up                  # Start development services (auto-detects compose)
docker_dev_down               # Stop and cleanup development environment
docker_dev_logs <service>     # Follow logs with syntax highlighting
docker_dev_shell <service>    # Quick shell access to running container

# Local service management (macOS)
brew_services_start_dev       # Start common development services
brew_services_stop_dev        # Stop development services
brew_services_status          # Colorized status of all services
```

#### Process & Resource Monitoring

```bash
# System monitoring with style
sys_monitor                   # Interactive system monitor (btop + custom widgets)
port_check <port>            # Check what's running on specific port
proc_find <pattern>          # Find processes with fuzzy matching
mem_top                      # Memory usage by process with human-readable output

# Development-specific monitoring
node_processes               # List all Node.js processes with details
python_processes            # List Python processes with venv info
docker_resource_usage       # Container resource consumption
```

### 🔧 Productivity Utilities

#### File Management & Search

```bash
# Enhanced file operations
find_large <size> [path]     # Find files larger than size (e.g., find_large 100M)
find_recent <days> [path]    # Files modified in last N days
find_code <pattern>          # Search code files with syntax highlighting
find_config <pattern>        # Search configuration files across system

# Intelligent copying/backup
backup_project [dest]        # Smart project backup (excludes node_modules, etc.)
sync_dotfiles               # Sync dotfiles to multiple machines
copy_with_structure <file>   # Copy preserving directory structure
```

#### Text Processing & Formatting

```bash
# Developer-friendly text manipulation
json_pretty <file|url>       # Pretty-print JSON with syntax highlighting
yaml_lint <file>            # Validate and format YAML files
markdown_preview <file>      # Live markdown preview in browser
log_colorize <logfile>      # Add syntax highlighting to log files

# Quick data conversion
csv_to_json <file>          # Convert CSV to JSON
json_to_yaml <file>         # Convert JSON to YAML
base64_encode/decode <text> # Quick encoding/decoding
url_encode/decode <text>    # URL encoding utilities
```

### 🌐 Network & Web Development

#### API Development & Testing

```bash
# HTTP testing made easy
http_get <url>              # GET request with formatted output
http_post <url> <data>      # POST with JSON data
http_test_endpoints <file>  # Test multiple endpoints from file
api_bench <url>             # Simple API performance testing

# Local development servers
serve_here [port]           # Serve current directory (default: 8000)
tunnel_expose <port>        # Expose local port via ngrok/cloudflare
cors_proxy <target_url>     # CORS proxy for local development
```

#### Network Diagnostics

```bash
# Connection testing with insights
ping_enhanced <host>        # Ping with geographic and latency insights
trace_visual <host>         # Visual traceroute with hop analysis
port_scan <host> [range]    # Check open ports with service detection
dns_lookup <domain>         # Comprehensive DNS information
ssl_check <domain>          # SSL certificate validation and expiry
```

### 🎮 Terminal Experience Enhancement

#### Interactive Command Building

```bash
# FZF-powered command construction
cmd_build                   # Interactive command builder with history
cmd_favorite                # Save/manage frequently used commands
cmd_share                   # Share command with team (via gist/pastebin)

# Smart command execution
run_with_confirm            # Execute with confirmation for dangerous commands
run_with_timeout <seconds>  # Execute with automatic timeout
run_and_notify              # Execute and send desktop notification when done
```

#### Session Management

```bash
# Multiplexer integration
tmux_dev_session <project>  # Create development session with predefined layout
tmux_attach_or_new         # Smart attach to existing or create new session
tmux_session_save          # Save current session layout
tmux_session_restore       # Restore saved session layout

# Zellij workflow (alternative to tmux)
zellij_dev_layout          # Load development-optimized layout
zellij_project_session     # Project-specific session with git integration
```

### 📱 Platform-Specific Features (macOS)

#### System Integration

```bash
# macOS-specific enhancements
desktop_cleanup            # Organize desktop files into dated folders
screenshot_ocr             # OCR text from screenshot to clipboard
quick_look <file>          # macOS Quick Look from terminal
open_in_finder [path]      # Open path in Finder (default: current dir)
```

#### Clipboard & Sharing

```bash
# Advanced clipboard operations
clip_history               # Show clipboard history with fzf selection
clip_to_qr                # Convert clipboard content to QR code
clip_to_gist              # Create GitHub gist from clipboard
share_file <file>         # Share file via temporary URL

# File sharing & collaboration
airdrop_to <device>       # Send file via AirDrop (if available)
share_screen_region       # Share specific screen region (screenshot + upload)
```

### ⚙️ Configuration & Maintenance

#### Dotfiles Management

```bash
# Chezmoi workflow automation
dots_edit <file>          # Edit dotfile and preview changes
dots_apply_safe          # Apply with backup and validation
dots_status_check        # Check for uncommitted changes
dots_backup_create       # Create timestamped backup

# System maintenance
cleanup_dev_env          # Clean node_modules, __pycache__, .DS_Store, etc.
update_all_tools         # Update mise tools, brew packages, pip packages
health_check_system      # Comprehensive system health validation
```

#### Development Environment Sync

```bash
# Cross-machine synchronization
sync_ssh_keys            # Sync SSH keys across authorized machines
sync_dev_configs         # Sync IDE/editor configurations
export_dev_env           # Export current environment configuration
import_dev_env <config>  # Import environment from another machine
```

### 🔍 Advanced Search & Discovery

#### Code Intelligence

```bash
# Project-wide code analysis
code_complexity [path]    # Analyze code complexity metrics
code_dependencies        # Visualize project dependencies
code_duplication         # Find duplicate code blocks
code_metrics             # Generate comprehensive code metrics

# Documentation & learning
explain_command <cmd>     # AI-powered command explanation
learn_tool <tool>        # Interactive tool learning with examples
docs_search <query>      # Search across man pages, docs, and cheat sheets
```

This enhanced shell environment transforms daily development tasks into streamlined, efficient workflows with intelligent automation and powerful integrations.

## 📋 Tmux workflow reference

Advanced tmux configuration with vim-like navigation:

### Pane management

| Keybinding  | Action                      |
| ----------- | --------------------------- |
| `h/j/k/l`   | Navigate panes in vim style |
| `v` or `\|` | Vertical split              |
| `-` or `s`  | Horizontal split            |
| `z`         | Toggle pane zoom            |
| `X`         | Kill pane                   |

### Window management

| Keybinding | Action         |
| ---------- | -------------- |
| `S`        | Choose session |
| `"`        | Choose window  |
| `^A`       | Last window    |
| `^W`       | List windows   |

### Resize & navigation

| Keybinding | Action            |
| ---------- | ----------------- |
| `,` / `.`  | Resize left/right |
| `-` / `=`  | Resize down/up    |
| `C-S-k`    | Clear screen      |

### Copy mode

| Keybinding | Action           |
| ---------- | ---------------- |
| `v`        | Begin selection  |
| `C-v`      | Rectangle toggle |
| `y`        | Copy selection   |

## 📦 External repository management

Automatic cloning and management of personal and work repositories with conditional loading based on environment settings. Repositories refresh every 168 hours and organize into categories: personal, work-frontend, work-backend, work-services.

## 🎯 Recent Major Update: .chezmoidata Reorganization

The configuration data structure has been completely reorganized into a flat, granular, and language-centric system. This new architecture is the foundation of the **Template Factory System**, where simple, powerful data files in `.chezmoidata/` are used by generators in `.chezmoitemplates/` to create complex, tool-specific configurations.

### ✨ **What Changed**

- **Flat, Granular Data**: The nested directory structure (`packages/`, `development/`, etc.) has been replaced by a flat list of specific YAML files (e.g., `lsp.yaml`, `formatters.yaml`, `tools.yaml`).
- **Single Source of Truth**: Each tool or package is defined only once.
- **Template-Driven**: Configuration files are now simple one-line calls to template generators.
- **Intuitive & Maintainable**: The new structure is easier to navigate, understand, and extend.

### 🚀 **Benefits**

- **Reduced Complexity**: Simplified data access and management.
- **Future-proof**: Easily extensible for new tools, platforms, and languages.
- **Robustness**: Changes are propagated automatically and consistently.
