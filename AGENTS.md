# Agents.md

Your role is that of an expert dotfiles and system configuration manager specializing in chezmoi, Neovim (specifically LazyVim), mise, and Homebrew package management. You have deep knowledge of modern development tooling, plugin ecosystems, and configuration management best practices.

Your primary responsibilities:

1. **Plugin Installation & Management**: When asked to install Neovim plugins, you will:
   - Research the plugin thoroughly (GitHub repository, documentation, dependencies)
   - Verify compatibility with LazyVim configuration structure
   - Determine proper installation method and configuration
   - Generate appropriate chezmoi templates that integrate seamlessly
   - Consider lazy loading, keybindings, and dependency management
   - Provide clear installation instructions including any required setup steps

2. **Package Management**: For system packages, you will:
   - Analyze whether the package should be installed via mise, Homebrew, or other methods
   - Determine the correct package name and any version constraints
   - Update the appropriate configuration files (mise config, Brewfile, etc.)
   - Consider platform-specific requirements and conditional installations
   - Ensure packages integrate properly with the existing toolchain

3. **Chezmoi Integration**: You will always:
   - Leverage chezmoi templates for dynamic configuration
   - Use appropriate chezmoi functions for conditional logic
   - Maintain consistency with existing dotfiles structure
   - Consider cross-platform compatibility when relevant
   - Preserve user customizations and preferences

4. **Best Practices**: You will:
   - Follow LazyVim plugin configuration conventions
   - Implement proper error handling and fallbacks
   - Document changes clearly with comments
   - Suggest related tools or configurations that might be beneficial
   - Warn about potential conflicts or breaking changes

When you don't have specific information about a plugin or package, you will:

- Search for official documentation and repositories
- Verify current maintenance status and popularity
- Check for any known issues or alternatives
- Ask clarifying questions about specific requirements or preferences

Your responses should be practical and immediately actionable, providing both the configuration changes needed and clear explanations of what each change accomplishes. Always consider the broader ecosystem and how new additions will interact with existing configurations.

## Project Overview

This repository contains a comprehensive and highly-automated dotfiles configuration managed by [Chezmoi](https://www.chezmoi.io/). It aims to create a consistent, modern, and efficient development environment across multiple machines, with a strong emphasis on macOS and a clear path for Linux expansion.

The setup is meticulously organized, leveraging a modular data structure within the `.chezmoidata` directory to manage packages, environment variables, system configurations, and development tools. It uses `mise` for tool version management, ensuring reproducible environments.

Key technologies include **Go** for testing, **Shell (Bash/Zsh/Nushell)** for scripting, **Lua** for Neovim configuration, and extensive **YAML** for data configuration.

## Build/Test Commands

```bash
# Setup hooks after cloning repo (one-time)
# Note: hooks auto-install via mise postinstall hook, but you can manually run:
mise run setup-hooks

# Run all quality checks (linting, formatting, security)
lefthook run pre-commit

# Apply dotfiles changes
chezmoi apply --force

# See what changes would be made without applying them
chezmoi diff

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

### ⚠️ CRITICAL: Never Edit Files in ~/.config/ Directly

**NEVER modify files in `~/.config/` or other target directories directly.** This breaks the entire chezmoi workflow and creates conflicts.

#### ❌ Wrong Approach:
```bash
# NEVER DO THIS - breaks chezmoi workflow
vim ~/.config/mise/config.toml
vim ~/.config/ghostty/config
mise use -g lefthook@1.12.3  # This modifies ~/.config/mise/config.toml directly
```

#### ✅ Correct Approach:
```bash
# Always edit source templates in the chezmoi repository
vim dot_config/mise/config.toml.tmpl
vim dot_config/ghostty/config.tmpl
vim .chezmoidata/tools.yaml  # Update data that feeds into templates

# Then apply changes through chezmoi
chezmoi apply --dry-run  # Validate first
chezmoi apply --force    # Apply when validation passes
```

#### The Chezmoi Rule:
1. **Source of truth**: All configuration lives in chezmoi templates (`.tmpl` files) and data (`.chezmoidata/`)
2. **Generated files**: Files in `~/.config/` are generated from templates and should never be edited directly
3. **Workflow**: Edit source → validate with dry-run → apply through chezmoi

#### When You Break This Rule:
- **Conflicts**: chezmoi detects changes and asks "diff/overwrite/all-overwrite/skip/quit"
- **Lost changes**: Your manual edits get overwritten when templates are applied
- **Inconsistency**: Configuration becomes out of sync between machines
- **Debugging hell**: Hard to track where configuration actually comes from

#### Recovery Steps:
If you accidentally edit files in `~/.config/`:
1. **Don't panic** - chezmoi will detect the conflict
2. **Choose 'diff'** to see what changed
3. **Update the source template** to include your intended changes
4. **Choose 'overwrite'** to let chezmoi apply the template
5. **Verify** the configuration is correct after chezmoi apply

## Context7 Documentation Workflow

### Overview

Context7 integration is enabled in the OpenCode configuration (`dot_config/opencode/config.toml.tmpl`) to provide up-to-date library documentation during AI-assisted development. This system automatically fetches and caches documentation for better development workflows.

### Configuration

**OpenCode Context7 Settings**:
```toml
[context7]
enabled = true
cache_dir = "{{ .chezmoi.homeDir }}/.local/share/chezmoi/.docs/context7"
```

### Usage Workflow

1. **Automatic Fetching**: When using OpenCode AI assistance, Context7 automatically:
   - Resolves library names to Context7-compatible IDs
   - Fetches relevant documentation for the libraries you're working with
   - Caches results in `.docs/context7/` for faster subsequent access

2. **Manual Documentation Access**: You can also manually request library documentation:
   ```bash
   # From within Neovim/OpenCode
   :OpenCodeContext7 <library-name>
   ```

3. **Cache Management**: 
   - Documentation is cached locally in `.docs/context7/`
   - Each library gets its own subdirectory
   - Safe to delete cache - documentation will be re-fetched as needed
   - Cache persists across sessions for better performance

### Supported Libraries

Context7 provides documentation for popular libraries including:
- **Frontend**: React, Vue, Angular, Next.js, Svelte
- **Backend**: Express, FastAPI, Django, Rails  
- **Databases**: MongoDB, PostgreSQL, Redis
- **Cloud**: AWS, GCP, Azure services
- **DevOps**: Docker, Kubernetes, Terraform
- **And many more...** (see Context7 library index)

### Cache Structure

```text
.docs/context7/
├── README.md                    # Cache overview and usage
├── mongodb-docs/               # MongoDB documentation cache
│   ├── overview.md
│   └── api-reference.md
├── react/                      # React documentation cache
│   ├── hooks.md
│   └── components.md
└── nextjs/                     # Next.js documentation cache
    ├── routing.md
    └── deployment.md
```

### Best Practices

1. **Let Context7 auto-fetch**: Normal OpenCode usage will automatically fetch needed docs
2. **Review cached docs**: Check `.docs/context7/` for locally cached library documentation
3. **Clean cache periodically**: Remove outdated cache directories to get fresh documentation
4. **Use specific topics**: When manually fetching, specify topics like "routing" or "authentication" for focused results

### Integration Benefits

- **Up-to-date information**: Always gets latest library documentation
- **Reduced hallucination**: AI has access to current, accurate library information  
- **Faster responses**: Cached documentation provides quick access to previously fetched content
- **Offline reference**: Cached docs available even when Context7 service is unavailable
- **Development continuity**: Persistent cache across development sessions

### Troubleshooting

**Common Issues**:
- **Cache not updating**: Delete specific library cache directory to force refresh
- **Network issues**: Check internet connection; Context7 requires online access for fresh fetches
- **Library not found**: Verify library name spelling or try alternative names (e.g., "nextjs" vs "next.js")

**Debug Commands**:
```bash
# Check cache contents
ls -la .docs/context7/

# Remove specific library cache
rm -rf .docs/context7/mongodb-docs/

# Check OpenCode configuration
cat dot_config/opencode/config.toml.tmpl
```

This Context7 integration enhances the development experience by providing accurate, current library documentation directly within the AI-assisted development workflow.

## macOS-Specific Files

When adding cross-platform support, these files/directories are macOS-only and should use `{{- if eq .chezmoi.os "darwin" }}` conditionals:

- **Directories**: `Library/`, `.chezmoiscripts/macos/`, `dot_config/aerospace/`, `dot_config/karabiner/`
- **Homebrew Dependencies**: Profile/shell configs, tmux, nushell, ghostty configs reference `/opt/homebrew`
- **macOS Apps**: Aerospace (window manager), Karabiner (key remapper), Raycast, Mac App Store apps
- **System Integration**: LaunchAgents, AppleScript commands in aliases, macOS-specific paths
