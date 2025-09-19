## Template Development Best Practices

### DRY Principle in Templates

- **Avoid duplication**: Use shared query templates in `.chezmoitemplates/queries/` to extract package lists for different managers
- **Targeted hashing**: Package installer scripts use specific hash triggers (e.g., `{{ template "queries/cargo-packages.tmpl" . }}`) instead of hashing entire configuration files
- **Iterative validation**: Always run `chezmoi apply --dry-run` during development to catch template syntax errors before applying changes

### Iterative Development Workflow

1. **Make template changes**
2. **Validate with dry-run**: `chezmoi apply --dry-run`
3. **Fix any template syntax errors**
4. **Apply when validation passes**: `chezmoi apply --force`
5. **Test the actual functionality** (installation scripts, etc.)

This workflow prevents broken templates from being applied to your system and ensures robust template development.

**Important**: Before committing changes, always run `chezmoi apply --dry-run` as a smoke test. If the dry run does not run successfully, report the errors, fix them, and run the dry run again.
