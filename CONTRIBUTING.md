# Contributing to Dotfiles

Thank you for your interest in contributing! This document outlines the process for contributing to this 
dotfiles repository.

## Getting Started

1. Fork the repository
2. Create a new branch for your feature/fix
3. Make your changes
4. Test your changes
5. Submit a pull request

## Development Setup

1. Install Chezmoi:

```zsh
sh -c "$(curl -fsLS get.chezmoi.io)"
```

1. Clone the repository:

```zsh
chezmoi init --apply your_github_username
```

## Testing

- Run integration tests:

```zsh
go test -v ./tests/...
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
