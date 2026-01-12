# Build and Test Agent Guide

## Quick Overview

- **Purpose**: This document outlines the testing and validation procedures for the dotfiles repository.
- **Integration**: Uses Go for testing, with custom scripts for running tests.

## Validation Checklist

- [ ] Run `chezmoi apply --dry-run` to validate template syntax
- [ ] Run `lefthook run pre-commit` to check code quality
- [ ] Test changes on actual system before committing

## Troubleshooting

- **Common errors**: Test failures due to configuration changes.
- **Conflict resolution**: N/A
- **Rollback**: Revert changes in git.
