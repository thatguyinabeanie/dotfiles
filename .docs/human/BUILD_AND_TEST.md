## Build and Test Commands

This document provides a comprehensive guide to the build and test commands used in this repository.

### Setup

- `mise run setup-hooks`: Sets up git hooks after cloning the repository.
  Note: hooks auto-install via mise postinstall hook, but you can manually run this command.

### Quality Checks

- `lefthook run pre-commit`: Runs all quality checks, including linting, formatting, and security checks.

### Applying Changes

- `chezmoi apply --force`: Applies dotfiles changes.
- `chezmoi diff`: Shows what changes would be made without applying them.
- `chezmoi apply --dry-run`: Tests for template syntax errors.
  This is the recommended workflow for validating template changes during development.
- `chezmoi apply --force`: Applies changes only if `chezmoi apply --dry-run` succeeds.
