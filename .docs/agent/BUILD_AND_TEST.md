# Build and Test Agent Guide

## Quick Overview

- **Purpose**: This document outlines the testing and validation procedures for the dotfiles repository.
- **Integration**: Uses Go for testing, with custom scripts for running tests.

## Configuration Discovery

- **Primary files**:
  - `.tests/` - All test files
  - `run_nvim_tests.sh` - Script for running Neovim tests
- **Search patterns**:
  - Tests: `rg "test" .tests/`
- **Template variables**: N/A

## Common Tasks

### Add a new test

- **Files**: Create a new `_test.go` file in `.tests/`.
- **Validation**: Run `go test` in the `.tests/` directory.
- **Conflicts**: N/A

### Run all tests

- **Command**: `go test ./...` from the `.tests/` directory.
- **Validation**: All tests should pass.
- **Conflicts**: N/A

## Validation Checklist

- [ ] Add new tests for any new functionality.
- [ ] Run all tests before committing changes.

## Troubleshooting

- **Common errors**: Test failures due to configuration changes.
- **Conflict resolution**: N/A
- **Rollback**: Revert changes in git.
