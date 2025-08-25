# Agents.md

Essential guidance for coding agents working with this Chezmoi dot files repository.

## Build/Test Commands

```bash
# Setup hooks after cloning repo (one-time)
# Note: hooks auto-install via mise postinstall hook, but you can manually run:
mise run setup-hooks

# Run all quality checks (linting, formatting, security)
lefthook run pre-commit

# Apply dotfiles changes
chezmoi apply && chezmoi diff

# Run all tests
cd .tests && go test ./...

# Run single test file
cd .tests && go test ./unit/config_test.go -v

# Run tests with coverage
cd .tests && go test -coverprofile=coverage.out ./... && go tool cover -html=coverage.out

# Run relevant tests for changed files
.tests/scripts/run_relevant_tests.sh
```

## Code Style Guidelines

- **Go**: Follow golangci-lint rules (govet, errcheck, staticcheck, gosec, revive). Use `github.com/alecthomas/assert/v2` for tests
- **Lua**: Use stylua formatting, follow luacheck rules. Neovim globals (`vim`) are allowed
- **Shell**: Use shellcheck for linting. Follow POSIX compatibility where possible
- **YAML**: Max 120 chars, no document-start markers, newline at EOF required
- **Markdown**: Use Vale for prose linting, follow markdownlint rules
- **Naming**: `dot_` prefix for hidden files, `private_` for encrypted content, `.tmpl` for Chezmoi templates
- **Imports**: Group standard library, third-party, then local imports in Go
- **Error Handling**: Always handle errors explicitly in Go, use proper exit codes in shell scripts

## macOS-Specific Files

When adding cross-platform support, these files/directories are macOS-only and should use `{{- if eq .chezmoi.os "darwin" }}` conditionals:

- **Directories**: `Library/`, `.chezmoidata/packages/` (macOS packages), `.chezmoiscripts/homebrew/`, `dot_config/aerospace/`, `dot_config/karabiner/`
- **Homebrew Dependencies**: Profile/shell configs, tmux, nushell, ghostty configs reference `/opt/homebrew`
- **macOS Apps**: Aerospace (window manager), Karabiner (key remapper), Raycast, Mac App Store apps
- **System Integration**: LaunchAgents, AppleScript commands in aliases, macOS-specific paths

## Cross-Platform Migration Plan

### Phase 1: Package Management Restructure

1. ✅ Moved Homebrew data: `homebrew/` → `packages/macos/`
2. ✅ Updated all Homebrew script paths to use new structure
3. Analyze `packages/macos/brews.yaml` - identify cross-platform packages
4. Create `packages/shared.yaml` - brew→yay package name mappings
5. Create `packages/linux.yaml` - Linux-only AUR packages
6. Update package data to separate platform-specific vs shared packages

### Phase 2: Script Organization

1. Move `.chezmoiscripts/homebrew/` → `.chezmoiscripts/macos/`
2. Create `.chezmoiscripts/linux/` with yay-based installation scripts
3. Add OS conditionals to mise scripts (LaunchAgent parts)
4. Keep cross-platform scripts (mise, rust, machine-setup) with internal conditionals

### Phase 3: Configuration Conditionals

1. Add to `.chezmoiignore`: `dot_config/aerospace/`, `dot_config/karabiner/`
2. Wrap Homebrew paths in shell configs with `{{- if eq .chezmoi.os "darwin" }}`
3. Conditionalize AppleScript commands in aliases
4. Add macOS conditionals to app-specific settings
