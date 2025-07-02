# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository managed by [Chezmoi](https://www.chezmoi.io/).
The repository contains configuration files for various development tools and environments, organized under the `MISSION_CONTROL` directory which serves as the Chezmoi source state.

## Essential Commands

### Testing

```bash
# Run all tests
cd _tests_ && go test -v ./...

# Run tests with coverage
cd _tests_ && go test -v -race -coverprofile=coverage.txt -covermode=atomic ./...

# Run tests for changed files only
cd _tests_ && ./scripts/run_relevant_tests.sh

# Test specific Neovim configuration
cd _tests_ && ./scripts/test_nvim_startup.sh
```

### Linting and Code Quality

```bash
# Run all pre-commit hooks manually
lefthook run pre-commit

# Run specific linters
markdownlint-cli2 --config .markdownlint.yaml "**/*.md"
cd _tests_ && golangci-lint run
yamllint -c .yamllint.yml .
shellcheck MISSION_CONTROL/dot_config/lefthook/*.sh

# Run security scan
gitleaks protect --staged --no-banner
```

### Chezmoi Management

```bash
# Apply dotfiles changes
chezmoi apply

# See what would change without applying
chezmoi diff

# Edit a managed file
chezmoi edit ~/.config/nvim/init.lua

# Add a new file to management
chezmoi add ~/.config/newapp/config.toml

# Update from the repository
chezmoi update

```

### AI/LLM Tooling

```bash
# Install AI tooling dependencies
mise run install-python-mcp  # Install MCP servers
mise run install-npm-globals # Install global npm packages

# Test MCP server connectivity
mcphub list-servers
mcphub test-server filesystem

# AI development workflow
# Use <leader>cc in Neovim to open CodeCompanion chat
# Use <leader>aa in Neovim for Avante AI assistant
# Use <C-g> for GitHub Copilot suggestions
```

## Architecture Overview

### Directory Structure

The repository uses Chezmoi's naming conventions:

- `MISSION_CONTROL/` - Root directory (set by `.chezmoiroot`)
- `dot_` prefix creates hidden files (e.g., `dot_config` → `.config`)
- `private_` prefix for encrypted/sensitive files
- `.tmpl` extension for templated files
- `empty_` prefix ensures directory creation

### Template System

Configuration templates use Go template syntax and access variables from `.chezmoi.toml.tmpl`:

- `WORK_ENVIRONMENT` - Boolean for work-specific configurations
- `SHELL` - Preferred shell (nu/zsh)
- `CATPPUCCIN_FLAVOR` - Theme variant (mocha/macchiato/frappe/latte)
- Application-specific settings (terminal opacity, fonts, window sizes)

### External Repository Management

The `.chezmoiexternal.toml.tmpl` file manages external Git repositories:

- Personal and work repositories are conditionally cloned
- Repositories refresh every 168 hours by default
- Organized into categories: personal, work-frontend, work-backend, work-services

### AI/LLM Integration Architecture

Comprehensive AI toolchain integrated throughout the configuration:

- **MCP (Model Context Protocol)**: Server configuration in `dot_config/mcphub/servers.json`
- **LLM Plugins**: Modular plugin system in `dot_config/nvim/lua/plugins/llm/`
- **Claude AI**: Dedicated configuration in `dot_claude/` with permissions and memories
- **Multiple Providers**: Avante (Claude), CodeCompanion, GitHub Copilot, Claude Code integration
- **Local Development**: Custom plugins for `claude-code.nvim` and `todo-mcp.nvim`

### Test Infrastructure

Located in `_tests_/` directory:

- Go-based test suite using virtual filesystem
- Unit tests for configuration validation
- Integration tests for complex setups
- Automated test execution on pre-commit
- Test sharding and caching for performance

### Git Hooks (Lefthook)

Pre-commit hooks run automatically and include:

- Markdown linting and formatting
- Shell script validation
- Go tests and linting
- YAML validation
- Security scanning with Gitleaks

## Development Workflow

1. **Making Changes**: Edit files in `MISSION_CONTROL/` directory
2. **Testing Locally**: Use `chezmoi diff` to preview changes before applying
3. **Running Tests**: Execute relevant tests based on changed files
4. **Committing**: Lefthook runs all quality checks automatically
5. **CI/CD**: GitHub Actions run comprehensive tests on pull requests

## Key Configuration Areas

### Shell Configurations

- **Nushell**: Primary shell with custom commands and completions in `dot_config/nushell/`
- **Zsh**: Alternative shell configuration in `dot_config/zsh/`
- Shared aliases managed through templates

### Editor Setup

- **Neovim**: Modular Lua configuration in `dot_config/nvim/`
- LazyVim-based setup with custom plugins
- Language-specific configurations

### Terminal Tools

- **Tmux**: Terminal multiplexer with Catppuccin theme
- **Ghostty/Kitty**: Terminal emulator configurations
- **Starship**: Cross-shell prompt customization

### Development Tools

- **Git**: Custom configuration and hooks
- **Mise**: Tool version management with custom tasks for AI tooling
- **Obsidian**: Knowledge management with vault configurations

### AI Development Environment

- **Neovim LLM Suite**: Comprehensive AI integration with Avante, CodeCompanion, Copilot
- **MCP Servers**: Filesystem, git, memory, fetch, and neovim context providers
- **Claude Code**: Native integration with permissions for bash commands and web domains
- **Multiple IDEs**: Cursor and VS Code Insiders configurations managed via templates

## Important Notes

- The repository uses a space/cosmic theme throughout (note the ASCII art and naming conventions)
- Catppuccin theming is applied consistently across all tools
- Work environment configurations are kept separate and require `WORK_ENVIRONMENT=true`
- Sensitive files (SSH keys, etc.) are encrypted with Chezmoi's encryption features
- Test coverage threshold is set to 80% for Go tests
- AI tooling requires MCP server installation via `mise run install-python-mcp`
- Claude Code has specific bash command and web domain permissions configured
- Multiple AI providers are available with consistent keybindings across Neovim
