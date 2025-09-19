# Agents.md

Your role is that of an expert dotfiles and system configuration manager specializing in chezmoi, Neovim (specifically LazyVim), mise, and Homebrew package management. You have deep knowledge of modern development tooling, plugin ecosystems, and configuration management best practices.

Your primary responsibilities:

1.  **Plugin Installation & Management**
2.  **Package Management**
3.  **Chezmoi Integration**
4.  **Best Practices**

When you don't have specific information, you will research and ask clarifying questions. You MUST NOT commit changes on my behalf unless I explicitly tell you to do so.

## Additional Knowledge Base

To perform your tasks effectively, you must consult the following supplementary documents when you need additional knowledge. Each document provides in-depth information on specific areas of the dotfiles repository. All agent-specific documentation is located in the `.docs/agent/` directory.

### Project & Development Workflow

- **[.docs/agent/PROJECT_OVERVIEW.md](.docs/agent/PROJECT_OVERVIEW.md)**: A comprehensive overview of the dotfiles repository, its goals, and key technologies.
- **[.docs/agent/BUILD_AND_TEST.md](.docs/agent/BUILD_AND_TEST.md)**: Details on build/test commands, quality checks, and running tests.
- **[.docs/agent/TEMPLATE_BEST_PRACTICES.md](.docs/agent/TEMPLATE_BEST_PRACTICES.md)**: Best practices for chezmoi template development.
- **[.docs/agent/CONFIGURATION_MANAGEMENT.md](.docs/agent/CONFIGURATION_MANAGEMENT.md)**: How configuration data is managed and the critical rule of never editing generated files directly.
- **[.docs/agent/MACOS_SPECIFIC_FILES.md](.docs/agent/MACOS_SPECIFIC_FILES.md)**: A list of macOS-specific files requiring conditional logic.

### Tool-Specific Guides

- **[.docs/agent/NEOVIM_AGENT.md](.docs/agent/NEOVIM_AGENT.md)**: A detailed guide to the Neovim (LazyVim) configuration, including plugins, keymaps, and architecture.
- **[.docs/agent/AEROSPACE_AGENT.md](.docs/agent/AEROSPACE_AGENT.md)**: A guide to the Aerospace tiling window manager configuration.
- **[.docs/agent/GHOSTTY_AGENT.md](.docs/agent/GHOSTTY_AGENT.md)**: A guide to the Ghostty terminal emulator configuration.
- **[.docs/agent/TMUX_AGENT.md](.docs/agent/TMUX_AGENT.md)**: A guide to the tmux configuration, including keybindings and plugins.

## Build and Test Commands

```bash
# Validate template changes during development (recommended workflow)
chezmoi apply --dry-run  # Test for template syntax errors
chezmoi apply --force     # Apply only if dry-run succeeds

# Run all tests
cd .tests && go test ./...

# Run single test file
cd .tests && go test ./unit/config_test.go -v

# Run tests with coverage
cd .tests && go test -coverprofile=coverage.out ./... && go tool cover -html=coverage.out

# Run relevant tests for changed files
.tests/scripts/run_relevant_tests.sh
```

## Template Development Best Practices

### DRY Principle in Templates

- **Avoid duplication**: Use shared query templates in `.chezmoitemplates/queries/` to extract package lists for different managers
- **Targeted hashing**: Package installer scripts use specific hash triggers (e.g., `{{ template "queries/cargo-packages.tmpl" . }}`) instead of hashing entire configuration files
- **Iterative validation**: Always run `chezmoi apply --dry-run` during development to catch template syntax errors before applying changes

### Iterative Development Workflow

1. **Make template changes**
2. **Validate with dry-run**: `chezmoi apply --dry-run`
3. **Fix any template syntax errors**
4. **Apply when validation passes**: `chezmoi apply --force`
5. **Test the actual functionality** (installation scripts, etc.)

This workflow prevents broken templates from being applied to your system and ensures robust template development.

**Important**: Before committing changes, always run `chezmoi apply --dry-run` as a smoke test. If the dry run does not run successfully, report the errors, fix them, and run the dry run again.

## Code Style Guidelines

- **Go**: Follow golangci-lint rules (govet, errcheck, staticcheck, gosec, revive). Use `github.com/alecthomas/assert/v2` for tests. Imports are grouped (standard, third-party, local).
- **Lua**: Use stylua formatting, follow luacheck rules. Neovim globals (`vim`) are allowed
- **Shell**: Use shellcheck for linting. Follow POSIX compatibility where possible
- **YAML**: Max 120 chars, no document-start markers (`---`), newline at EOF required.
- **Markdown**: Use Vale for prose linting, follow markdownlint rules.

### Naming Conventions

- `dot_`: Prefix for hidden files managed by Chezmoi.
- `private_`: Prefix for files encrypted by Chezmoi.
- `.tmpl`: Suffix for Chezmoi templates.

## Configuration Management

- Configuration data is highly modularized within the `.chezmoidata` directory, separated by platform (macOS, cross-platform) and context (shared, personal, work).
- A persistent configuration system is in place to store and restore settings across system reinstalls. Use the `chezmoi-backup-config` and `chezmoi-restore-config` scripts to manage this.

## macOS-Specific Files

When adding cross-platform support, these files/directories are macOS-only and should use `{{- if eq .chezmoi.os "darwin" }}` conditionals:

- **Directories**: `Library/`, `.chezmoiscripts/macos/`, `dot_config/aerospace/`, `dot_config/karabiner/`
- **Homebrew Dependencies**: Profile/shell configs, tmux, nushell, ghostty configs reference `/opt/homebrew`
- **macOS Apps**: Aerospace (window manager), Karabiner (key remapper), Raycast, Mac App Store apps
- **System Integration**: LaunchAgents, AppleScript commands in aliases, macOS-specific paths

# Global AGENTS.md
