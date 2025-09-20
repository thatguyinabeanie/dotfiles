# Template Best Practices Agent Guide

## Quick Overview

- **Purpose**: This document outlines best practices for creating and maintaining chezmoi templates.
- **Integration**: N/A

## Key Principles

- **Idempotency**: Templates should be runnable multiple times without changing the result.
- **Modularity**: Break down large templates into smaller, reusable components.
- **Data-driven**: Use `.chezmoidata/` to separate data from presentation.
- **Validation**: Use `chezmoi apply --dry-run` to validate changes.

## Common Tasks

### Create a new template

- **Files**: Create a new `.tmpl` file in the appropriate `dot_` directory.
- **Validation**: Run `chezmoi apply --dry-run` to check for syntax errors.
- **Conflicts**: N/A

### Add new data

- **Files**: Add new data to the appropriate `.yaml` file in `.chezmoidata/`.
- **Validation**: Run `chezmoi apply --dry-run` to ensure the data is correctly parsed.
- **Conflicts**: N/A

## Validation Checklist

- [ ] Use `chezmoi apply --dry-run` to validate all template changes.
- [ ] Ensure all new templates are idempotent.

## Troubleshooting

- **Common errors**: Template syntax errors, missing data.
- **Conflict resolution**: N/A
- **Rollback**: Revert changes in git.
