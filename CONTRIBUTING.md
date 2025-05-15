# Contributing to Dotfiles

Thank you for your interest in contributing! This document outlines the process for contributing.

## Getting Started

1. Fork the repository.
2. Create a new branch for your feature/fix.
3. Make your changes.
4. Test your changes.
5. Submit a pull request.

## Development Setup

- Install Chezmoi:

  ```bash
  sh -c "$(curl -fsLS get.chezmoi.io)"
  ```

- Clone the repository:

  ```bash
  chezmoi init --apply your_github_username
  ```

## Repository Structure

The repository uses a ROOT-based structure:

- `.chezmoiroot` points to `MISSION_CONTROL/` directory.
- All dotfiles are stored under `MISSION_CONTROL/`.
- Configuration files are in `MISSION_CONTROL/dot_config/`.
- Tests are in `__tests__/`.

## Testing

- Run tests with:

  ```bash
  cd __tests__ && go test -v ./...
  ```

- Test installation on a fresh system
- Verify all GitHub Actions pass

## Pull Request Process

1. Update documentation if needed
2. Add tests for new features
3. Ensure all tests pass
4. Update the README.md if needed
5. Reference any related issues

## Code Style

- Follow the style guides for each language.
- Use the provided linters and formatters.

## Submitting Changes

- Ensure all tests and linters pass before submitting a PR.
- Add clear, descriptive commit messages.
- Reference related issues in your PR description.

## Git Hooks & Code Quality

This repository uses [Lefthook](https://github.com/evilmartians/lefthook) to manage all Git hooks for code quality, linting, and security.
All previous pre-commit hooks are now managed by Lefthook.

### Running Hooks

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
- Custom scripts are in `MISSION_CONTROL/.chezmoiscripts/precommit/`.

### Adding/Modifying Hooks

- Edit `lefthook.yml` to add or change hooks.
- Place new scripts in the precommit directory and make them executable.
