# Contributing to dotfiles

Thank you for your interest in contributing. This document outlines the process for contributing.

## Getting started

1. Fork the repository.
2. Create a new branch for your feature/fix.
3. Make your changes.
4. Test your changes.
5. Submit a pull request.

## Development setup

- Install Chezmoi:

  ```bash
  sh -c "$(curl -fsLS get.chezmoi.io)"
  ```

- Clone the repository:

  ```bash
  chezmoi init --apply your_github_username
  ```

## Repository structure

The repository uses a flat directory structure:

- All dotfiles are stored at the repository root.
- Configuration files are in `dot_config/`.
- Tests are in `.tests/`.

## Testing

- Run tests with:

  ```bash
  cd .tests && go test -v ./...
  ```

- Test installation on a fresh system
- Verify all GitHub Actions pass

## Pull request process

1. Update documentation if needed
2. Add tests for new features
3. Ensure all tests pass
4. Update the README.md if needed
5. Reference any related issues

## Code style

- Follow the style guides for each language.
- Use the provided linters and formatters.

## Submitting changes

- Ensure all tests and linters pass before submitting a PR.
- Add clear, descriptive commit messages.
- Reference related issues in your PR description.

## Git hooks & code quality

This repository uses [Lefthook](https://github.com/evilmartians/lefthook) to manage all Git hooks for code quality, linting, and security.
All previous pre-commit hooks are now managed by Lefthook.

### Running hooks

- Hooks run automatically on `git commit`.
- To run all pre-commit hooks manually:

  ```bash
  lefthook run pre-commit
  ```

- To run a specific hook:

  ```bash
  lefthook run pre-commit --only <hook-name>
  ```

### Configuration

- The configuration is in `lefthook.yml` at the repository root.
- Custom scripts are in `dot_config/lefthook/`.

### Adding/modifying hooks

- Edit `lefthook.yml` to add or change hooks.
- Place new scripts in the precommit directory and make them executable.
