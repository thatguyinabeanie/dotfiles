# Package Management Agent Guide

## Quick Overview

- **Purpose**: This document explains the complete package management workflow for the dotfiles repository.
- **Integration**: Uses chezmoi templates with `.chezmoidata/` YAML files to manage all packages across different package managers.

## Key Principles

- **Declarative management**: All packages are declared in YAML files, never installed manually.
- **Centralized configuration**: Package definitions live in `.chezmoidata/` directory.
- **Template-driven**: Packages are installed via chezmoi scripts and templates.
- **Reproducible**: Same packages installed consistently across machines.

## Package Categories & Files

### Core Files
- **`.chezmoidata/tools.yaml`**: Development tools (node, python, go, etc.)
- **`.chezmoidata/formatters.yaml`**: Code formatters (prettier, black, rustfmt, etc.)
- **`.chezmoidata/linters.yaml`**: Code linters (eslint, ruff, etc.)
- **`.chezmoidata/ai/agents.yaml`**: AI tools and agents

### Supported Installation Methods
```yaml
install_via: bun          # Node.js packages (preferred)
install_via: npm          # Node.js packages (legacy)
install_via: brew         # Homebrew packages  
install_via: mise         # Mise-managed tools
install_via: pip          # Python packages
install_via: cargo        # Rust packages
install_via: gem          # Ruby packages
install_via: go           # Go packages
install_via: brew_cask    # macOS applications
install_via: curl         # Direct downloads
```

## Common Tasks

### Add Prettier Plugin (Example: prettier-plugin-sh)

**❌ WRONG WAY:**
```bash
npm install -g prettier-plugin-sh  # DON'T DO THIS
```

**✅ CORRECT WAY:**
1. **Edit**: `.chezmoidata/formatters.yaml`
2. **Add entry**:
```yaml
- name: prettier-plugin-sh
  languages: [sh, bash, zsh]
  install_via: bun
  runtime: node
  version: latest
  description: "Prettier plugin for shell scripts"
  mason_ensure_installed: false
  prettier_plugin: true
```
3. **Validate**: `chezmoi apply --dry-run`
4. **Apply**: `chezmoi apply`

### Add Development Tool

**Files**: Edit `.chezmoidata/tools.yaml`
**Pattern**:
```yaml
- name: tool-name
  install_via: mise|brew|bun
  runtime: native|node|python
  version: latest|specific-version
  description: "Tool description"
  category: build|system|git|etc
```

### Add Formatter

**Files**: Edit `.chezmoidata/formatters.yaml`
**Pattern**:
```yaml
- name: formatter-name
  languages: [file, extensions]
  install_via: bun|mise|brew
  runtime: node|native|python
  version: latest
  description: "Formatter description"
  mason_ensure_installed: true|false
```

### Add Linter

**Files**: Edit `.chezmoidata/linters.yaml`
**Pattern**:
```yaml
- name: linter-name
  languages: [file, extensions]
  install_via: bun|mise|brew
  runtime: node|native|python
  version: latest
  description: "Linter description"
  mason_ensure_installed: true|false
```

## Installation Methods Detail

### Bun Packages (Preferred for Node.js)
```yaml
install_via: bun
runtime: node
# Installed globally via: bun install -g <name>
```

### NPM Packages (Legacy)
```yaml
install_via: npm
runtime: node
# Installed globally via: npm install -g <name>
```

### Mise Tools
```yaml
install_via: mise
runtime: native
# Installed via: mise use -g <name>@<version>
```

### Homebrew
```yaml
install_via: brew
runtime: native
# Installed via: brew install <name>
```

### Custom Commands
```yaml
install_via: cargo
runtime: rust
install_command: "cargo install --git <repo> <name>"
```

## Validation Checklist

- [ ] Edit source YAML files in `.chezmoidata/`, never install manually
- [ ] Follow established patterns for `install_via`, `runtime`, `version`
- [ ] Add meaningful `description` and appropriate `category`
- [ ] Run `chezmoi apply --dry-run` to validate syntax
- [ ] Test actual installation after `chezmoi apply`

## Troubleshooting

### Manual Installation Cleanup
```bash
# Remove manually installed npm packages
npm uninstall -g prettier-plugin-sh prettier-plugin-toml

# Let chezmoi manage installations
chezmoi apply
```

### Version Conflicts
- Check for duplicate entries across different YAML files
- Ensure consistent version specifications
- Use `mise list` to check installed versions

### Missing Packages
- Verify package name spelling in YAML files
- Check if package exists in specified package manager
- Review installation logs: `chezmoi apply -v`

## Advanced Patterns

### Conditional Installation
```yaml
- name: macos-only-tool
  install_via: brew
  condition: "{{ eq .chezmoi.os 'darwin' }}"
```

### Multiple Install Methods
```yaml
- name: tool-name
  install_via: brew
  alternatives:
    - install_via: mise
    - install_via: cargo
```

### Plugin Dependencies
```yaml
- name: prettier-plugin-sh
  install_via: npm
  runtime: node
  requires: [prettier]  # Ensure prettier is installed first
```

## Common Package Types by Category

### Code Formatters
- **Prettier ecosystem**: prettier, prettier-plugin-*, @prettier/*
- **Language-specific**: black (Python), rustfmt (Rust), gofmt (Go)
- **Shell**: shfmt
- **Data formats**: taplo (TOML), yamlfmt (YAML)

### Development Tools
- **Version managers**: mise, fnm, pyenv
- **Build tools**: webpack, vite, rollup
- **Language runtimes**: node, python, go, rust

### System Utilities
- **File management**: eza, fd, ripgrep, bat
- **System monitoring**: btop, bottom, glances
- **Terminal tools**: tmux, starship, fzf

## Real-World Examples

### Adding a New Prettier Plugin
```yaml
# .chezmoidata/formatters.yaml
- name: prettier-plugin-toml
  languages: [toml]
  install_via: bun
  runtime: node
  version: latest
  description: "Prettier plugin for TOML files"
  mason_ensure_installed: false
  prettier_plugin: true
```

### Adding a Language Server
```yaml
# .chezmoidata/tools.yaml  
- name: typescript-language-server
  install_via: bun
  runtime: node
  version: latest
  description: "TypeScript language server"
  category: lsp
```

### Adding a Rust Tool
```yaml
# .chezmoidata/tools.yaml
- name: ripgrep
  install_via: cargo
  runtime: rust
  version: latest
  description: "Fast grep alternative"
  category: file_management
```