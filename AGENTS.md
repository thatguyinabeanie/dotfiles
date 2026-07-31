# Agent Instructions

Instructions for AI assistants working with this dotfiles repository.

> **Note**: This file is symlinked as `CLAUDE.md` for Claude Code and is available to all AI agents
> (Claude, GitHub Copilot, etc.).

## TL;DR

1. **All packages via `.chezmoidata/*.yaml`** — never install manually
2. **Always dry-run before apply** — `chezmoi apply --dry-run` then `chezmoi apply --force`
3. **Never edit `~/.config/` directly** — edit chezmoi source (`dot_config/`) instead
4. **Use `installer` (array) schema** — `install_via` (string) is legacy
5. **Use profiles for optional packages** — `profiles: [python-dev]` to scope to a workflow

## Accuracy

- **Validate before asserting.** Verify claims against the real source (files, `grep`, tool
  output) before stating them as fact — never present unverified commands, keybindings, or
  behavior as part of the actual setup.
- **Label confidence.** Distinguish "confirmed by reading X" from "likely / default."
- **Flag runtime-only claims.** When something can only be confirmed in the running tool
  (e.g. `:verbose map` in nvim), say so instead of overclaiming from static files.
- **Don't trust raw `grep` counts.** Read the matches — watch for false positives (e.g. Lua
  bracket-indexing `[x]` matching a search for `[s`).

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

- Ask questions **one at a time** unless using a questions TUI tool for multiple related choices.
- Wait for answers before proceeding — don't assume.

## Critical Rules

**NEVER install packages manually** (npm, brew, pip, etc.). All packages MUST be managed through
`.chezmoidata/` YAML files. All packages are declared in YAML files, never installed manually.
Configuration is template-driven and reproducible across machines.

### Package Installation Workflow

1. **Identify package type**: formatters, linters, tools, etc.
2. **Edit appropriate `.chezmoidata/*.yaml` file**
3. **Follow established patterns**: `installer`, `name`, `description`, `profiles`, etc.
4. **Validate with**: `chezmoi apply --dry-run`
5. **Apply changes**: `chezmoi apply`

### Quick Reference: `.chezmoidata/` Files

| File                      | Top-Level Key        | Purpose                                      |
| ------------------------- | -------------------- | -------------------------------------------- |
| `formatters.yaml`         | `formatters`         | Code formatters (prettier, stylua, etc.)     |
| `linters.yaml`            | `linters`            | Linters (eslint, shellcheck, vale, etc.)     |
| `tools.yaml`              | `dev_tools`          | CLI tools and utilities (ripgrep, fd, etc.)  |
| `lsp.yaml`                | `lsp_servers`        | Language server configurations               |
| `mcp.yaml`                | `mcp_servers`        | MCP server definitions                       |
| `applications.yaml`       | `applications`       | macOS GUI apps (casks, Mac App Store)        |
| `taps.yaml`               | `homebrew_taps`      | Homebrew tap repositories                    |
| `services.yaml`           | `services`           | Background services (postgresql, etc.)       |
| `shared.yaml`             | (multiple)           | Shared settings: theme, font, terminal, UI   |
| `personal.yaml`           | (multiple)           | Personal identity and environment settings   |
| `work.yaml`               | (multiple)           | Work-specific overrides                      |
| `onepassword.yaml`        | (multiple)           | 1Password integration settings               |
| `opencode.yaml`           | (multiple)           | OpenCode editor configuration                |
| `agents.yaml`             | `agents`             | AI agent tool configurations                 |
| `aliases.yaml`            | `aliases`            | Shell aliases/abbreviations (Fish & Zsh)     |

### Schema Patterns

Most package YAML files follow this structure:

```yaml
top_level_key:
  - name: package-name
    installer: [mise]              # Installation method(s)
    languages: [python, yaml]      # (formatters/linters) Languages supported
    description: "Optional note"   # Human-readable description
    profiles: [python-dev]         # (optional) Only install when profile is active
    conflicts_with_lsp_formatting: true  # (formatters) Conflict flag
```

**Profile filtering:** Packages with a `profiles` field are only installed when at least one
matching profile is active. Packages without `profiles` are always installed (backward compatible).
The `"default"` profile is always active and cannot be deactivated. Active profiles are stored
as a comma-separated string in persistent config (`active_profiles` key) and can be overridden
via the `ACTIVE_PROFILES` environment variable.

### Supported Installer Values

The `installer` field is an **array** — multiple values mean "install via all listed methods":

- `[mise]` — Preferred for CLI tools (version-managed)
- `[brew]` — Homebrew formula
- `[brew_cask]` — macOS GUI applications
- `[mason]` — Neovim Mason (LSP servers, formatters, linters)
- `[npm]` or `[bun]` — Node.js packages
- `[pip]` — Python packages
- `[cargo]` — Rust packages (accelerated by `cargo-binstall` when binaries available)
- `[gem]` — Ruby packages
- `[go]` — Go packages
- `[curl]` — Direct downloads
- Multiple: `[mise, mason]` means "install via both"

> **Migration complete:** The legacy `install_via` (string) schema has been fully retired.
> `installer` (array) is now the only supported form across every `.chezmoidata/*.yaml` file
> and `.chezmoitemplates/` template.

### Data Flow into Templates

1. Chezmoi loads all `.chezmoidata/*.yaml` files automatically
2. Template queries in `.chezmoitemplates/queries/` extract package lists by installer
3. Installer scripts (`.chezmoiscripts/`) use these queries to determine what to install

Key query templates:

- `queries/packages.tmpl` - Filters packages by `PackageManager`
- `queries/brew-formulae.tmpl` - Extracts Homebrew formula packages
- `queries/brew-casks.tmpl` - Extracts Homebrew cask packages

### Package Addition Examples

**Add a formatter** (`.chezmoidata/formatters.yaml`):

```yaml
- name: prettier-plugin-toml
  languages: [toml]
  installer: [npm]
  description: "Prettier plugin for TOML files"
```

**Add a development tool** (`.chezmoidata/tools.yaml`):

```yaml
- name: tool-name
  installer: [mise]           # or [brew], [npm], etc.
  description: "Tool description"
```

**Add a linter** (`.chezmoidata/linters.yaml`):

```yaml
- name: linter-name
  languages: [file, extensions]
  installer: [mise]           # or [brew], [npm], [mason], etc.
  description: "Linter description"
```

### Package Troubleshooting

**Manual Installation Cleanup:**

```bash
# Remove manually installed npm packages
npm uninstall -g prettier-plugin-sh prettier-plugin-toml

# Let chezmoi manage installations
chezmoi apply
```

**Version Conflicts:**

- Check for duplicate entries across different YAML files
- Ensure consistent version specifications
- Use `mise list` to check installed versions

**Missing Packages:**

- Verify package name spelling in YAML files
- Check if package exists in specified package manager
- Review installation logs: `chezmoi apply -v`

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

### JSON Template Gotchas

When working with JSON templates (like `opencode.jsonc.tmpl`), be aware of:

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

### Never Edit Files in `~/.config/` Directly

**NEVER modify files in `~/.config/` or other target directories directly.** This breaks the
entire chezmoi workflow and creates conflicts.

**Wrong:**

```bash
vim ~/.config/mise/config.toml          # breaks chezmoi workflow
vim ~/.config/ghostty/config            # breaks chezmoi workflow
mise use -g lefthook@1.12.3             # modifies ~/.config/mise/config.toml directly
```

**Correct:**

```bash
vim dot_config/mise/config.toml.tmpl    # edit source templates
vim dot_config/ghostty/config.tmpl      # edit source templates
vim .chezmoidata/tools.yaml             # update data that feeds into templates
chezmoi apply --dry-run                 # validate first
chezmoi apply --force                   # apply when validation passes
```

**Recovery if you accidentally edit `~/.config/`:**

1. Choose 'diff' when chezmoi detects the conflict
2. Update the source template to include your intended changes
3. Choose 'overwrite' to let chezmoi apply the template
4. Verify the configuration is correct after `chezmoi apply`

### Personal/Work Split

The `.chezmoidata/` directory uses a context-based split:

- **`personal.yaml`** - Personal development environment settings
- **`work.yaml`** - Work/corporate environment overrides
- **`shared.yaml`** - Cross-context configuration (XDG dirs, editor, theme, UI)

All YAML files provide data for chezmoi templates. Environment variables are generated in shell
profiles. Conditional logic is handled based on work/personal context and macOS/Linux detection.

### OpenCode Configuration

- **`opencode.jsonc`** (root-level) - Direct OpenCode config for LSP servers, formatters, core settings
- **`.chezmoidata/opencode.yaml`** - YAML data for templated OpenCode configurations
- Root `opencode.jsonc` is used directly by OpenCode and doesn't require `chezmoi apply`

## macOS-Specific Files

When adding cross-platform support, these files/directories are macOS-only and should use
`{{- if eq .chezmoi.os "darwin" }}` conditionals:

- **Directories**: `Library/`, `.chezmoiscripts/macos/`, `dot_config/aerospace/`, `dot_config/karabiner/`
- **Homebrew Dependencies**: Profile/shell configs, tmux, zsh, ghostty configs reference `/opt/homebrew`
- **macOS Apps**: Aerospace (window manager), Karabiner (key remapper), Raycast, Mac App Store apps
- **System Integration**: LaunchAgents, AppleScript commands in aliases, macOS-specific paths

## Success Criteria

Before marking any task complete, verify:

- [ ] `chezmoi apply --dry-run` succeeds without errors
- [ ] `lefthook run pre-commit` passes all checks (if applicable)
- [ ] Changes validated on actual system (not just dry-run)
- [ ] No duplicate entries in `.chezmoidata/*.yaml` files
- [ ] Platform-specific code uses appropriate conditionals

## Common Pitfalls

1. **Template syntax errors** - Always run `chezmoi apply --dry-run` before `chezmoi apply --force`
2. **Platform-specific code** - Use `{{- if eq .chezmoi.os "darwin" }}` for macOS-only features
3. **Duplicate package entries** - Check existing entries before adding new packages
4. **Missing validation** - Don't skip dry-run validation step during template development
5. **Direct package installation** - Never run `brew install`, `npm install -g`, etc.
   Use `.chezmoidata/*.yaml` files

## Custom Skills (Slash Commands)

Project-level skills are available as slash commands:

| Command | Purpose |
|---------|---------|
| `/project:chezmoi-package` | Guided workflow to add a package to the correct YAML file |
| `/project:chezmoi-profile` | Manage profile-based package installation (list, enable, disable) |
| `/project:chezmoi-validate` | Run validation checks (dry-run, duplicates, stale schemas, pre-commit) |

## Automation Hooks

Hookify rules prevent common mistakes:

| Hook | Event | Action |
|------|-------|--------|
| `prevent-manual-install` | bash | Blocks `brew install`, `npm install -g`, etc. |
| `prevent-config-edits` | file | Blocks direct edits to `~/.config/` |
| `package-profile-reminder` | file | Warns about `profiles:` field when adding packages |

Hook files are in `.claude/hookify.*.local.md`.

## Documentation Index

| Documentation | Location | Covers |
|---|---|---|
| Root (this file) | `AGENTS.md` | Package management, chezmoi, profiles, templates |
| Neovim/LazyVim | `dot_config/nvim/AGENTS.md` | Plugins, keymaps, LSP, 50+ keybindings |
| Tmux | `dot_config/tmux/AGENTS.md` | Session management, plugins, keybindings |
| Zellij | `dot_config/zellij/AGENTS.md` | Tmux-compatible multiplexer, keybindings |
| WezTerm | `dot_config/wezterm/AGENTS.md` | Terminal emulator, Zellij integration, theming |
| Ghostty | `dot_config/ghostty/AGENTS.md` | Terminal emulator, tmux integration |
| Aerospace | `dot_config/aerospace/AGENTS.md` | macOS tiling window manager |
| 1Password | `docs/ONEPASSWORD_SETUP.md` | 1Password service account setup |
| Profiles Design | `docs/plans/2026-03-24-profile-based-packages-design.md` | Profile system design record |
