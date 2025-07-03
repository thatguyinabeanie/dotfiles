# AGENTS.md

Agent guidelines for working with this Chezmoi-managed dotfiles repository.

## Build/Test Commands

```bash
# Run all tests
cd _tests_ && go test -v ./...

# Run single test file
cd _tests_ && go test -v ./unit/config_test.go

# Run specific test function
cd _tests_ && go test -v -run TestChezmoiConfig ./unit/

# Run tests for changed files only
cd _tests_ && ./scripts/run_relevant_tests.sh

# Lint and format
lefthook run pre-commit                    # Run all pre-commit hooks
cd _tests_ && golangci-lint run            # Go linting
markdownlint-cli2 --config .markdownlint.yaml "**/*.md"  # Markdown linting

# Chezmoi operations
chezmoi diff                               # Preview changes
chezmoi apply                              # Apply dotfiles
```

## Code Style Guidelines

- **Go**: Use `github.com/alecthomas/assert/v2` for tests, follow standard Go conventions
- **Test structure**: Use subtests with `t.Run()` for organization
- **Naming**: Use clear, descriptive names; Go functions start with `test` prefix in lowercase
- **Imports**: Group standard library, third-party, and local imports with blank lines
- **Error handling**: Always check and handle errors appropriately
- **Comments**: Only add when necessary for complex logic
- **Coverage**: Maintain 80% test coverage threshold