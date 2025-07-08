# AGENTS.md

Essential guidance for coding agents working with this Chezmoi dotfiles repository.

## Essential Commands

```bash
# Run all tests
cd _tests_ && go test -v ./...

# Run single test file  
cd _tests_ && go test -v ./unit/config_test.go

# Run tests for changed files only
cd _tests_ && ./scripts/run_relevant_tests.sh

# Run all quality checks
lefthook run pre-commit

# Apply dotfiles changes
chezmoi apply && chezmoi diff
```

## Code Style Guidelines

- **Go**: Use standard Go conventions, snake_case for test functions, table-driven tests
- **Imports**: Group stdlib, third-party, local packages with blank lines between groups
- **Tests**: Place in `_tests_/` directory, use `github.com/alecthomas/assert/v2` for assertions
- **Naming**: `dot_` prefix for hidden files, `private_` for encrypted, `.tmpl` for templates
- **Error Handling**: Always check errors, use descriptive error messages
- **Coverage**: Maintain 80% test coverage threshold (enforced by CI)