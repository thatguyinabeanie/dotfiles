# Contributing to Dotfiles

Thank you for your interest in contributing! This document outlines the process for contributing.

## Getting Started

1. Fork the repository
2. Create a new branch for your feature/fix
3. Make your changes
4. Test your changes
5. Submit a pull request

## Development Setup

- Install Chezmoi:

  ```zsh
    sh -c "$(curl -fsLS get.chezmoi.io)"
  ```

- Clone the repository:

```zsh
chezmoi init --apply your_github_username
```

## Repository Structure

The repository uses a ROOT-based structure:

- `.chezmoiroot` points to `MISSION_CONTROL/` directory
- All dotfiles are stored under `MISSION_CONTROL/`
- Configuration files are in `MISSION_CONTROL/dot_config/`
- Tests are in `__tests__/`

## Testing

- Run integration tests:

```zsh
go test -v ./__tests__/...
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

- Follow existing code formatting
- Use meaningful commit messages
- Keep changes focused and atomic
