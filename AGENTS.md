# Agent Instructions

Instructions for AI assistants working with this dotfiles repository.

> **Note**: This file is symlinked as `CLAUDE.md` for Claude Code and is available to all AI agents
> (Claude, GitHub Copilot, etc.).

## Your Role

You are an expert dotfiles and system configuration manager specializing in chezmoi,
Neovim (specifically LazyVim), mise, and Homebrew package management. You have deep knowledge of
modern development tooling, plugin ecosystems, and configuration management best practices.

### Primary Responsibilities

1. **Plugin Installation & Management**
2. **Package Management**
3. **Chezmoi Integration**
4. **Best Practices**

When you don't have specific information, you will research and ask clarifying questions.
You MUST NOT commit changes on my behalf unless I explicitly tell you to do so.

## Asking Questions

When you need clarifying information from the user:

1. **Ask questions ONE AT A TIME** - Never ask multiple questions in a single message unless using the questions TUI
2. **Use the questions TUI tool** - When you have multiple related questions, use the `question` tool to present them as an interactive menu
3. **Wait for answers** - Don't proceed with assumptions; wait for user input before continuing
4. **Be specific** - Frame questions clearly with context about why you're asking

### When to Use the Questions TUI

Use the `question` tool for:
- Multiple related configuration choices (e.g., plugin preferences, tool options)
- Gathering several pieces of information at once (e.g., project setup requirements)
- Presenting options with explanations (the tool supports descriptions for each choice)

### When to Ask One Question at a Time

Ask individual questions for:
- Complex decisions that need explanation or discussion
- Follow-up questions based on previous answers
- Questions that might lead to different conversation paths

## Critical Rules

**NEVER install packages manually** (npm, brew, pip, etc.). All packages MUST be managed through `.chezmoidata/` YAML files.

### Package Installation Workflow

1. **Identify package type**: formatters, linters, tools, etc.
2. **Edit appropriate `.chezmoidata/*.yaml` file**
3. **Follow established patterns**: `install_via`, `runtime`, `version`, etc.
4. **Validate with**: `chezmoi apply --dry-run`
5. **Apply changes**: `chezmoi apply`

### Quick Reference

- **Formatters**: `.chezmoidata/formatters.yaml`
- **Linters**: `.chezmoidata/linters.yaml`
- **Tools**: `.chezmoidata/tools.yaml` (includes AI tools and MCP servers)
- **LSP servers**: `.chezmoidata/lsp.yaml`
- **MCP servers**: `.chezmoidata/mcp.yaml`
- **Applications**: `.chezmoidata/applications.yaml` (macOS apps)
- **AI providers**: `.chezmoidata/ai/` (per-provider configs)
- **Homebrew taps**: `.chezmoidata/taps.yaml`
- **GitHub extensions**: `.chezmoidata/github-extensions.yaml`
- **Services**: `.chezmoidata/services.yaml`

**Before installing anything, consult**: [.docs/agent/PACKAGE_MANAGEMENT.md](.docs/agent/PACKAGE_MANAGEMENT.md)

## Build and Test Commands

```bash
# Setup hooks after cloning repo (one-time)
mise run setup-hooks

# Install development dependencies (if working in the dotfiles repo)
mise run install-npm-packages

# Run all quality checks (linting, formatting, security)
lefthook run pre-commit

# Apply dotfiles changes
chezmoi apply --force

# See what changes would be made without applying them
chezmoi diff

# Validate template changes during development (recommended workflow)
chezmoi apply --dry-run   # Test for template syntax errors
chezmoi apply --force     # Apply only if dry-run succeeds
chezmoi init --apply      # Run if chezmoi.toml.tmpl changes
```

## Template Development

### Iterative Development Workflow

1. **Make template changes**
2. **Validate with dry-run**: `chezmoi apply --dry-run`
3. **Fix any template syntax errors**
4. **Apply when validation passes**: `chezmoi apply --force`
5. **Test the actual functionality** (installation scripts, etc.)

This workflow prevents broken templates from being applied to your system and ensures robust
template development.

**Important**: Before committing changes, always run `chezmoi apply --dry-run` as a smoke test.
If the dry run does not run successfully, report the errors, fix them, and run the dry run again.

### DRY Principle in Templates

- **Avoid duplication**: Use shared query templates in `.chezmoitemplates/queries/` to extract
  package lists for different managers
- **Targeted hashing**: Package installer scripts use specific hash triggers
  (e.g., `{{ template "queries/packages.tmpl" (dict "PackageManager" "cargo" "root" .) }}`)
  instead of hashing entire configuration files
- **Iterative validation**: Always run `chezmoi apply --dry-run` during development to catch
  template syntax errors before applying changes

### JSON Template Debugging

When working with JSON templates (like `opencode.jsonc.tmpl`), be aware of common syntax issues:

#### Go Map vs JSON Object Syntax

**Problem**: Templates may output Go map syntax instead of JSON objects

```json
"limit": map[context:128000 output:65536]  // ❌ Go map syntax
```

**Solution**: Access map fields individually to create proper JSON objects

```json
"limit": {
  "context": {{ $model.limit.context }},
  "output": {{ $model.limit.output }}
}  // ✅ Proper JSON
```

#### Data Access Patterns

- Ensure template variables reference the correct data structure
- For nested YAML data, verify the full path to your configuration
- Use `fromJson` and `fromYaml` functions appropriately for data loading

#### Validation Steps for JSON Templates

1. Run `chezmoi apply --dry-run` to check template syntax
2. Validate generated JSON with `python3 -m json.tool` or similar
3. Test the actual application consuming the JSON configuration

## Code Style Guidelines

- **Go**: Follow golangci-lint rules (govet, errcheck, staticcheck, gosec, revive).
  Use `github.com/alecthomas/assert/v2` for tests. Imports are grouped (standard, third-party, local).
- **Lua**: Use stylua formatting, follow luacheck rules. Neovim globals (`vim`) are allowed
- **Shell**: Use shellcheck for linting. Follow POSIX compatibility where possible
- **YAML**: Max 120 chars, no document-start markers (`---`), newline at EOF required.
- **Markdown**: Use Vale for prose linting, follow markdownlint rules.

## File Naming Conventions

- `dot_`: Prefix for hidden files managed by chezmoi (e.g., `dot_zshrc` → `~/.zshrc`)
- `private_`: Prefix for files encrypted by chezmoi
- `.tmpl`: Suffix for chezmoi templates that will be processed

## Configuration Management

Configuration data is highly modularized within the `.chezmoidata` directory, separated by platform
(macOS, cross-platform) and context (shared, personal, work).

A persistent configuration system is in place to store and restore settings across system reinstalls.
Use the `chezmoi-backup-config` and `chezmoi-restore-config` scripts to manage this.

**Never edit generated files directly** - always edit source templates or `.chezmoidata/*.yaml` files.

## macOS-Specific Files

When adding cross-platform support, these files/directories are macOS-only and should use
`{{- if eq .chezmoi.os "darwin" }}` conditionals:

- **Directories**: `Library/`, `.chezmoiscripts/macos/`, `dot_config/aerospace/`, `dot_config/karabiner/`
- **Homebrew Dependencies**: Profile/shell configs, tmux, zsh, ghostty configs reference `/opt/homebrew`
- **macOS Apps**: Aerospace (window manager), Karabiner (key remapper), Raycast, Mac App Store apps
- **System Integration**: LaunchAgents, AppleScript commands in aliases, macOS-specific paths

## Context7 Integration Tools

- **resolve-library-id**: Resolves a package/product name to a Context7-compatible library ID
  and returns a list of matching libraries. Must be called before fetching documentation to obtain
  valid library IDs.
- **query-docs**: Fetches up-to-date documentation for a library using a Context7-compatible
  library ID. Supports topic-focused retrieval and token limits for optimized context.

## Success Criteria

Before marking any task complete, verify:

- [ ] `chezmoi apply --dry-run` succeeds without errors
- [ ] `lefthook run pre-commit` passes all checks (if applicable)
- [ ] Changes validated on actual system (not just dry-run)
- [ ] No duplicate entries in `.chezmoidata/*.yaml` files
- [ ] Platform-specific code uses appropriate conditionals

## Common Pitfalls

1. **Never edit generated files directly** - Always edit source templates or `.chezmoidata/*.yaml` files
2. **Template syntax errors** - Always run `chezmoi apply --dry-run` before `chezmoi apply --force`
3. **Platform-specific code** - Use `{{- if eq .chezmoi.os "darwin" }}` for macOS-only features
4. **Duplicate package entries** - Check existing entries before adding new packages
5. **Missing validation** - Don't skip dry-run validation step during template development
6. **Direct package installation** - Never run `brew install`, `npm install -g`, etc.
   Use `.chezmoidata/*.yaml` files

## Additional Documentation

For detailed information on specific areas of the repository, consult these supplementary documents
in the `.docs/agent/` directory:

### Project & Development Workflow

- **[.docs/agent/PROJECT_OVERVIEW.md](.docs/agent/PROJECT_OVERVIEW.md)**: A comprehensive overview
  of the dotfiles repository, its goals, and key technologies.
- **[.docs/agent/PACKAGE_MANAGEMENT.md](.docs/agent/PACKAGE_MANAGEMENT.md)**: Complete guide to
  package management workflow, installation methods, and troubleshooting.

### Tool-Specific Guides

- **[.docs/agent/GHOSTTY_AGENT.md](.docs/agent/GHOSTTY_AGENT.md)**: A guide to the Ghostty
  terminal emulator configuration.
- **[.docs/agent/WEZTERM_AGENT.md](.docs/agent/WEZTERM_AGENT.md)**: A guide to the WezTerm
  terminal emulator configuration.
- **[.docs/agent/ZELLIJ_AGENT.md](.docs/agent/ZELLIJ_AGENT.md)**: A guide to the Zellij
  terminal multiplexer configuration.

### Chezmoi Data

- **[.docs/agent/CHEZMOIDATA_GUIDE.md](.docs/agent/CHEZMOIDATA_GUIDE.md)**: Schema, data flow,
  and workflow for `.chezmoidata/` YAML files.

### Nested Agent Docs (auto-discovered)

These directories contain their own `AGENTS.md` (with `CLAUDE.md` symlink) for auto-discovery:

- **`dot_config/nvim/AGENTS.md`** - Neovim (LazyVim) configuration
- **`dot_config/tmux/AGENTS.md`** - Tmux configuration
- **`dot_config/aerospace/AGENTS.md`** - Aerospace window manager

### Workflow Guides

- **[.docs/agent/CONTEXT7_WORKFLOW.md](.docs/agent/CONTEXT7_WORKFLOW.md)**: How to use Context7
  for up-to-date library documentation lookups.
