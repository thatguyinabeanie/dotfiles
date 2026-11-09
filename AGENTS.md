# Agent Instructions

Instructions for AI assistants working with this dotfiles repository.

> **Note**: This file is symlinked as `CLAUDE.md` for Claude Code and is available to all AI agents
> (Claude, GitHub Copilot, etc.).

## TL;DR

1. **All packages via `.chezmoidata/*.yaml`** — never install manually
2. **Always dry-run before apply** — `chezmoi apply --dry-run` then `chezmoi apply --force`
3. **Never edit `~/.config/` directly** — edit chezmoi source (`dot_config/`) instead
4. **Use `installer` (array) schema** — `install_via` (string) is legacy
5. **Uninstall means `install: false`**: keep the entry; never delete it to uninstall, and never
   run `brew uninstall`, `npm uninstall -g`, `mise uninstall`, etc. by hand

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
3. **Follow established patterns**: `installer`, `name`, `description`, etc.
4. **Validate with**: `chezmoi apply --dry-run`
5. **Apply changes**: `chezmoi apply`

### Package Uninstall Workflow

When I say "uninstall X", set `install: false` on the entry. The next `chezmoi apply` removes
the package through every manager in the entry's `installer` array.

1. **Find every entry**: `grep -rn X .chezmoidata/`. Include `mise_name:`, `mason_name:`, and
   `install_command:` values (go removes the binary named in `install_command`), and check every
   file, because the same tool can appear in more than one.
2. **Add `install: false`** to every matching entry. Keep `installer` as-is: it names the
   managers to remove from.
3. **If X is in no YAML file**, find its manager with read-only checks (`brew list`,
   `brew list --cask`, `mise ls --installed`, `npm ls -g --depth=0`, `pip show`,
   `cargo install --list`, `gem list`, `bun pm ls -g`, and for go, list the bin dir:
   `go env GOBIN`, or `$(go env GOPATH)/bin` when that is empty). Then add an entry in the
   matching file with that `installer` and `install: false`.
4. **To remove from only one manager**: drop that manager from the entry's `installer` array,
   and add a separate entry with the same `name`, `installer: [that-manager]`, and
   `install: false`. That tombstone is intentional, not a duplicate: a tombstone may share a
   `name` with an active entry when their `installer` lists differ. For example, a tool moved
   from brew to mise keeps an active `installer: [mise]` entry and an `installer: [brew]`,
   `install: false` tombstone. Never merge or "dedupe" the two.
5. **Preview and validate**: `chezmoi apply --dry-run` checks templates but does not run
   scripts, so it shows no removals. Render the removal list for each manager in the entries'
   `installer` arrays (`brew`, `brew_cask`, `mise`, `npm`, `mason`, and so on) and show me
   exactly what will be removed:

   ```bash
   chezmoi execute-template '{{ template "queries/removed-packages.tmpl" (dict "PackageManager" "brew" "root" .) }}'
   ```

   Then run `chezmoi apply --dry-run`, and ask me before `chezmoi apply --force`, because it
   deletes software.
6. **Keep the entries** after the removal: other machines need them to remove the package too.
   Delete one only when I ask.

```yaml
- name: wget
  installer: [brew]
  description: "No longer needed"
  install: false
```

Semantics:

- An entry is not removed while another entry keeps the same name active for the same manager
  (this stops apply from uninstalling and reinstalling the same package).
- A package that is already removed is a silent no-op.
- A failed removal during `chezmoi apply` is not retried automatically. The removal helper
  (`uninstall_packages`) returns 0 so it never stops apply, and chezmoi records the script as
  run. To retry, fix the cause, then run `chezmoi state delete-bucket --bucket=entryState`
  and apply again. That re-runs every `run_onchange_` script. To re-run one script only, delete
  its key instead, for example
  `chezmoi state delete --bucket=entryState --key="$HOME/.chezmoiscripts/mise/140-go-packages.sh"`.

Coverage:

- Removed during `chezmoi apply`: brew, brew_cask, mise, cargo, npm, pip, go, gem, bun.
- Mason removes on the next Neovim launch, when mason-tool-installer loads, and retries on every
  launch until the package is gone. `dot_config/nvim/lua/plugins/dev/mason.lua` also filters
  removed packages out of the lists LazyVim installs from, so they stay removed. For a language
  server that LazyVim configures itself (for example `gopls` from the Go extra), it sets
  `mason = false`: LazyVim stops installing the server but still starts it when its binary is on
  `PATH` from another manager.
- Not covered: `mas`, `curl`, `rustup`, Homebrew taps, and services. In Neovim, debug adapters
  that mason-nvim-dap installs automatically when nvim-dap loads (for example `debugpy`) are not
  filtered; no `.chezmoidata` entry uses one today.

### Quick Reference: `.chezmoidata/` Files

| File                      | Top-Level Key        | Purpose                                      |
| ------------------------- | -------------------- | -------------------------------------------- |
| `formatters.yaml`         | `formatters`         | Code formatters (prettier, stylua, etc.)     |
| `linters.yaml`            | `linters`            | Linters (eslint, shellcheck, vale, etc.)     |
| `tools.yaml`              | `dev_tools`          | CLI tools and utilities (ripgrep, fd, etc.)  |
| `lsp.yaml`                | `language_servers`   | Language server configurations               |
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
| `aliases-*.yaml`          | `aliases`            | Shell aliases, one file per category (Zsh)   |

### Schema Patterns

Most package YAML files follow this structure:

```yaml
top_level_key:
  - name: package-name
    installer: [mise]              # Installation method(s)
    languages: [python, yaml]      # (formatters/linters) Languages supported
    description: "Optional note"   # Human-readable description
    conflicts_with_lsp_formatting: true  # (formatters) Conflict flag
    install: false                 # (optional) remove on next apply; default is to install
```

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
- `queries/removed-packages.tmpl` - Returns the space-separated names of entries marked
  `install: false` for one `PackageManager` (empty when none)

`utilities/uninstall.sh.tmpl` provides `uninstall_packages CHECK_FN REMOVE_FN NAME...`, which the
installer scripts call with the removal list. It skips packages that are not installed, logs to
`$LOG_FILE`, and never aborts the calling script.

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

- Check for duplicate entries across different YAML files. An `install: false` tombstone with a
  different `installer` from an active entry of the same name is intentional: leave it.
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
- **YAML**: See `.yamllint.yml` for style rules.
- **Markdown**: Use Vale for prose linting, follow markdownlint rules.

### Shell Functions

This repo is **zsh only**. Fish was removed; do not reintroduce it.

- Functions live in `dot_config/zsh/functions/`, one topic per file (for example `git-worktree.zsh`, `ports.zsh`). They render to `~/.config/zsh/functions/`.
- Aliases live in `.chezmoidata/aliases-<cat>.yaml`, one file per category. Each renders through `dot_config/zsh/aliases/<cat>.zsh.tmpl` to `~/.config/zsh/aliases/<cat>.zsh`.
- `dot_zshrc.tmpl` sources all `aliases/*.zsh` first, then `functions/*.zsh`, in one loop.
- Do not grow catch-all files. Put a new function in the file for its topic. Create a new topic file when no topic fits.
- Put a new alias in the matching `aliases-<cat>.yaml`. For a new category, add a new data file and a new stub template.
- Prefix private helpers with `_`, for example `_gwt_ensure_gitignore`.

## File Naming Conventions

- `dot_`: Prefix for hidden files managed by chezmoi (e.g., `dot_zshrc` → `~/.zshrc`)
- `private_`: Prefix for files encrypted by chezmoi
- `.tmpl`: Suffix for chezmoi templates that will be processed

## Configuration Management

Configuration data is highly modularized within the `.chezmoidata` directory, separated by platform
(macOS, cross-platform) and context (shared, personal, work).

The work/personal answer persists in the macOS `defaults` domain `com.chezmoi.config`
(precedence: env `WORK_ENVIRONMENT`, then defaults, then `promptBoolOnce`) in `.chezmoi.toml.tmpl`.
All other values are literal defaults with env overrides.

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

### Work Secrets Live in `~/mise.toml`

Work tokens are **not** managed by chezmoi and **not** stored in this repo. They live in
`~/mise.toml`, an untracked home-directory mise config, plus nested per-project `mise.toml`
files that mise layers on top when you `cd` into a project.

- Currently defined there: `NPM_AUTH_TOKEN`, `CIVIS_API_KEY`, `JIRA_API_KEY_TOKEN`
- `~/.config/mise/config.toml` **is** chezmoi-managed (`dot_config/mise/config.toml.tmpl`) and
  holds tool versions, not secrets. Do not confuse the two.
- Never read, print, or commit the values. Referring to a variable by name is fine.
- Adding a secret means editing `~/mise.toml` by hand. There is no chezmoi template for it,
  deliberately.

civisrc's own `setup/install.sh` wants to generate a plaintext `~/.civis_profile` for the same
purpose. We do not use it. If a civisrc tool reports a missing token, add it to `~/mise.toml`
rather than running civisrc's installer.

### civisrc Integration

[`civisrc`](https://github.com/civisanalytics/civisrc) is Civis's internal AWS/Okta/Kubernetes
shell toolkit. It is cloned to `~/source/civisrc` and wired in **natively**, never via its own
`make install`.

Why: `make install` appends `source ~/.civisrc` into `~/.zshrc`, which chezmoi owns and
overwrites on the next apply. Its `dot_civisrc` also re-runs `brew shellenv`, `direnv hook`,
and a blind `compinit` that would defeat the deferred cached `compinit` in `dot_zshrc.tmpl`.

| Piece | How it is wired |
| ----- | --------------- |
| Clone | `.chezmoiexternal.toml.tmpl` (root), `type = "git-repo"` with `pull.args = ["--ff-only"]` |
| `src/*.sh`, `bin/`, env vars | `dot_zshrc.tmpl` SECTION 2, gated on `WORK_ENVIRONMENT` + directory exists |
| zsh completions | `dot_zshrc.tmpl` SECTION 3, added to `fpath` |
| Brew dependencies | `.chezmoidata/tools.yaml` |

Notes for future changes:

- The clone uses chezmoi's native `git-repo` external, not a script. `--ff-only` means a
  refresh can never rewrite or merge over local commits in `~/source/civisrc`; it just fails
  if the branch has diverged. Note this makes chezmoi manage `~/source` as a directory, which
  leaves its other unmanaged repos alone.
- civisrc's README declares `bin/` as "Bash 4+". As of 2026-09-21 no script actually uses
  bash-4-only syntax, so they run on macOS's 3.2, but `bash` is declared in `tools.yaml` to
  match upstream's Brewfile and stay ahead of that changing.
- civisrc replaced `civis-kubectl-configs`. The old repo may still be on disk but is no longer
  sourced. They define 8 of the same names, so never source both.
- When upstream changes `dot_civisrc`, re-check it against our cherry-picked subset rather
  than adopting it wholesale.

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
- [ ] No duplicate entries in `.chezmoidata/*.yaml` files (an `install: false` tombstone that
      shares a name with an active entry but has a different `installer` is not a duplicate)
- [ ] Platform-specific code uses appropriate conditionals

## Common Pitfalls

1. **Template syntax errors**: always run `chezmoi apply --dry-run` before
   `chezmoi apply --force`.
2. **Platform-specific code**: use `{{- if eq .chezmoi.os "darwin" }}` for macOS-only
   features.
3. **Duplicate package entries**: check existing entries before adding new packages. An
   `install: false` tombstone next to an active entry is intentional (see Package Uninstall
   Workflow, step 4).
4. **Missing validation**: don't skip the dry-run step during template development.
5. **Direct package installation**: never run `brew install`, `npm install -g`, etc.
   Use `.chezmoidata/*.yaml` files.
6. **Parse checks are not runtime checks**: `zsh -n` only validates syntax. Logic that
   parses cleanly can still abort at runtime. Always invoke a changed function, don't
   just parse it.
7. **`git rev-parse --show-toplevel` inside a worktree**: returns the LINKED worktree's
   root, not the main checkout. Use `git worktree list --porcelain | head -1` when you
   need the main checkout. Prefer it over `--git-common-dir`, whose dirname is wrong
   inside a submodule.
8. **`git check-ignore` exit codes**: it exits 0 when ANY pattern matches, including a
   negation (`!`) pattern, so the exit code alone does not tell you whether a file is
   ignored. Use `git status` or `git add --dry-run` instead.
9. **Sweeping commits**: this repo often has several unrelated work streams in the
   working tree at once. Stage explicit paths; `git add -A` collects other people's
   in-progress work.
10. **Deleting a YAML entry does not uninstall anything**: it only stops future installs. To
    uninstall, set `install: false` on the entry (see Package Uninstall Workflow).

## Documentation Index

| Documentation | Location | Covers |
|---|---|---|
| Root (this file) | `AGENTS.md` | Package management, chezmoi, templates |
| Neovim/LazyVim | `dot_config/nvim/AGENTS.md` | Plugins, keymaps, LSP, 50+ keybindings |
| Tmux | `dot_config/tmux/AGENTS.md` | Session management, plugins, keybindings |
| Zellij | `dot_config/zellij/AGENTS.md` | Tmux-compatible multiplexer, keybindings |
| WezTerm | `dot_config/wezterm/AGENTS.md` | Terminal emulator, Zellij integration, theming |
| Ghostty | `dot_config/ghostty/AGENTS.md` | Terminal emulator, tmux integration |
| Aerospace | `dot_config/aerospace/AGENTS.md` | macOS tiling window manager |
| 1Password | `docs/ONEPASSWORD_SETUP.md` | 1Password service account setup |
