# Agents.md

Essential guidance for coding agents working with this Chezmoi dot files repository.

## Build/Test Commands

```bash
# Run all quality checks (linting, formatting, security)
lefthook run pre-commit

# Apply dotfiles changes
chezmoi apply && chezmoi diff

# Run all tests
cd _tests_ && go test ./...

# Run single test file
cd _tests_ && go test ./unit/config_test.go -v

# Run tests with coverage
cd _tests_ && go test -coverprofile=coverage.out ./... && go tool cover -html=coverage.out

# Run relevant tests for changed files
_tests_/scripts/run_relevant_tests.sh
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

- **Directories**: `Library/`, `.chezmoidata/homebrew/`, `.chezmoiscripts/homebrew/`, `dot_config/aerospace/`, `dot_config/karabiner/`
- **Homebrew Dependencies**: Profile/shell configs, tmux, nushell, ghostty configs reference `/opt/homebrew`
- **macOS Apps**: Aerospace (window manager), Karabiner (key remapper), Raycast, Mac App Store apps
- **System Integration**: LaunchAgents, AppleScript commands in aliases, macOS-specific paths
