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
