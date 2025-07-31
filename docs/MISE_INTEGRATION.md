# Mise Integration & Dependency Management

Comprehensive guide to the mise-based dependency management system that provides consistent development environments across projects and machines.

## 🎯 What is Mise?

Mise is a modern runtime manager that replaces tools like asdf, nvm, pyenv, rbenv, etc. with a single, fast, and reliable solution for managing:

- **Programming languages** (Python, Node.js, Go, Rust, etc.)
- **Development tools** (CLI utilities, formatters, linters)
- **Environment variables** (project-specific configurations)
- **Tasks** (project automation and scripts)

## 🏗️ Architecture Overview

```text
Dotfiles Mise Integration:
├── Global Configuration
│   ├── config.toml.tmpl           # Main mise configuration
│   ├── languages.yaml             # Language versions
│   └── python.yaml                # Python packages
├── Project Hooks
│   └── python-project-hook.sh     # Auto-environment setup
└── Scripts
    └── setup-cargo.sh             # Rust toolchain setup
```

## ⚙️ Configuration Files

### 1. Main Configuration (`config.toml.tmpl`)

```toml
# Global mise configuration with templating support
[tools]
python = "latest"        # Latest stable Python
node = "lts"            # Latest LTS Node.js
go = "latest"           # Latest Go version

[env]
EDITOR = "nvim"         # Default editor
MISE_EXPERIMENTAL = "1" # Enable experimental features

# Project detection hooks
[hooks]
after_use = ["~/.config/mise/scripts/python-project-hook.sh"]
```

### 2. Language Versions (`languages.yaml`)

```yaml
# Centralized language version management
languages:
  python: "3.12" # Python version
  node: "20" # Node.js LTS
  go: "1.21" # Go version
  rust: "stable" # Rust channel
  lua: "5.4" # Lua version
```

### 3. Python Packages (`python.yaml`)

```yaml
# Global Python packages for data science and development
packages:
  # Scientific Computing
  - numpy
  - pandas
  - matplotlib
  - seaborn
  - plotly

  # Machine Learning
  - scikit-learn
  - scipy
  - statsmodels

  # Development Tools
  - black # Code formatter
  - isort # Import sorter
  - flake8 # Linter
  - pytest # Testing framework

  # Jupyter Ecosystem
  - jupyter
  - ipython
  - ipykernel
```

## 🔧 Automatic Environment Setup

### Python Project Hook

The system automatically detects Python projects and sets up environments:

```bash
#!/bin/bash
# File: python-project-hook.sh

# Detect Python project indicators
if [[ -f "pyproject.toml" || -f "requirements.txt" || -f "setup.py" ]]; then
    echo "🐍 Python project detected"

    # Install project dependencies
    if [[ -f "requirements.txt" ]]; then
        mise exec python -- pip install -r requirements.txt
    fi

    # Install development dependencies
    if [[ -f "requirements-dev.txt" ]]; then
        mise exec python -- pip install -r requirements-dev.txt
    fi

    # Setup pre-commit hooks if configured
    if [[ -f ".pre-commit-config.yaml" ]]; then
        mise exec python -- pre-commit install
    fi
fi
```

### Features

- **Automatic detection** of Python projects
- **Dependency installation** from requirements files
- **Pre-commit hook setup** for code quality
- **Virtual environment management** (isolated per project)

## 🚀 Usage Examples

### Basic Commands

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

### Project-Specific Configuration

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

### Environment Variables

```bash
# Set project-specific environment variables
mise set DATABASE_URL=postgres://localhost/mydb
mise set DEBUG=true

# View current environment
mise env

# Execute command with mise environment
mise exec -- python manage.py runserver
```

## 📦 Package Management

### Python Packages

Global packages are automatically installed via the `python.yaml` configuration:

```yaml
# Add new packages here
packages:
  - your-new-package
  - another-tool
```

Then apply with:

```bash
chezmoi apply
```

### Rust Crates (via Cargo)

```bash
# Cargo setup script installs common tools
./scripts/setup-cargo.sh

# Installs:
# - bat (cat with syntax highlighting)
# - eza (modern ls replacement)
# - fd (find alternative)
# - ripgrep (grep alternative)
# - yazi (terminal file manager)
```

### Node.js Global Packages

```bash
# Install global tools
mise exec npm -- install -g typescript
mise exec npm -- install -g @nestjs/cli
mise exec npm -- install -g prettier
```

## 🔄 Workflow Integration

### Chezmoi Integration

```bash
# Template processing with mise data
{{ if .mise.python_available }}
# Python-specific configuration
{{ end }}

# Version-specific handling
{{ if gt .mise.python_version "3.11" }}
# Use new Python features
{{ end }}
```

### Shell Integration

```bash
# Automatic activation in shell
eval "$(mise activate zsh)"     # For Zsh
eval "$(mise activate nu)"      # For Nushell

# Prompts show current tools
mise ps  # Show active tools and versions
```

### Editor Integration

```lua
-- Neovim integration (automatic)
-- Mise tools are available in Neovim's PATH
-- LSPs automatically use project-specific versions
```

## 🧪 Advanced Features

### Task Runner

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

### Environment Templates

```toml
# Global template in config.toml
[env]
PROJECT_ROOT = "{{cwd}}"
PYTHON_PATH = "{{exec_path}}/python"
NODE_PATH = "{{exec_path}}/node"
```

### Plugin System

```bash
# Add custom tool plugins
mise plugin install terraform https://github.com/asdf-community/asdf-terraform.git

# Use custom tools
mise install terraform@1.6.0
mise use terraform@1.6.0
```

## 🔍 Troubleshooting

### Common Issues

#### Tools Not Found

```bash
# Check mise installation
mise doctor

# Verify shell integration
echo $PATH | grep mise

# Reinstall shell integration
mise activate zsh >> ~/.zshrc
```

#### Version Conflicts

```bash
# Check active versions
mise current

# Force refresh
mise reshim

# Clear cache
mise cache clear
```

#### Python Package Issues

```bash
# Check Python environment
mise exec python -- which python
mise exec python -- pip list

# Reinstall packages
chezmoi apply  # Reapplies python.yaml
```

### Performance Optimization

```toml
# In config.toml
[settings]
experimental = true
paranoid = false          # Skip some safety checks
disable_tools = ["ruby"]  # Skip unused tools
```

## 📊 Monitoring & Maintenance

### Version Tracking

```bash
# Check for updates
mise outdated

# Update all tools
mise upgrade

# Update specific tool
mise upgrade python
```

### Health Checks

```bash
# Comprehensive system check
mise doctor

# Check specific installation
mise which python
mise which node
```

### Cleanup

```bash
# Remove unused versions
mise prune

# Clean cache
mise cache clear

# Remove specific version
mise uninstall python@3.10
```

## 🔮 Integration Examples

### CI/CD Pipeline

```yaml
# GitHub Actions
- name: Setup mise
  uses: jdx/mise-action@v2

- name: Install dependencies
  run: mise install

- name: Run tests
  run: mise exec -- pytest
```

### Docker Integration

```dockerfile
# Install mise in Docker
RUN curl https://mise.run | sh
ENV PATH="/root/.local/bin:$PATH"

# Install project tools
COPY .mise.toml .
RUN mise install
```

### VS Code Integration

```json
{
  "python.defaultInterpreterPath": "mise exec python -- which python",
  "terminal.integrated.env.linux": {
    "PATH": "mise exec -- echo $PATH"
  }
}
```

This mise integration provides a robust, consistent development environment that scales from individual projects to team workflows, ensuring everyone works with the same tool versions and dependencies.
