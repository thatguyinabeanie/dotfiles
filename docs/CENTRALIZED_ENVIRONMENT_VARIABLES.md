# Centralized Environment Variable System for Shell Configurations

This system provides a unified approach to managing environment variables across multiple shell environments (Zsh, Nushell, etc.).

## System Components

### 1. Data Structure (`environment-variables.yaml`)
- **Location**: `.chezmoidata/environment-variables.yaml`
- **Purpose**: Single source of truth for all environment variable definitions
- **Features**:
  - Shell-agnostic variable definitions
  - Conditional variable support
  - Path management with deduplication
  - Template integration

### 2. Shell-Specific Templates
- **Zsh**: `.chezmoitemplates/environment/zsh-env.tmpl`
- **Nushell**: `.chezmoitemplates/environment/nushell-env.tmpl`
- **Purpose**: Generate shell-specific syntax from unified data

### 3. Generated Configuration Files
- **Zsh**: `dot_zshenv_centralized.tmpl` 
- **Nushell**: `dot_config/nushell/env_centralized.nu.tmpl`

## Benefits

### ✅ Consistency
- All shells use identical environment variable values
- No more drift between shell configurations
- Standardized XDG directory usage

### ✅ Maintainability  
- Single file to edit for environment changes
- Automated shell-specific syntax generation
- Reduced duplication and errors

### ✅ Features Fixed
- **PATH deduplication**: Nushell automatically deduplicates, Zsh gets proper ordering
- **Path consistency**: All shells use XDG-compliant paths
- **Variable naming**: Standardized across shells (e.g., `TMUX_CONF` paths)
- **Conditional logic**: Work environment variables properly scoped

## Usage

### Adding New Environment Variables

1. **Edit the data structure**:
```yaml
# .chezmoidata/environment-variables.yaml
environment_variables:
  new_category:
    my_var: "my_value"
    templated_var: "{{ .some.template.value }}"
```

2. **Update templates** (if needed):
```bash
# zsh-env.tmpl
export MY_VAR="{{ $env.new_category.my_var }}"

# nushell-env.tmpl  
$env.MY_VAR = "{{ $env.new_category.my_var }}"
```

3. **Apply changes**:
```bash
chezmoi apply
```

### Migration Path

To migrate from current system:

1. **Test the new system**:
   - Use `dot_zshenv_centralized.tmpl` and `env_centralized.nu.tmpl` 
   - Compare output with current configs
   - Verify all variables are properly set

2. **Replace existing files**:
   ```bash
   mv dot_zshenv.tmpl dot_zshenv.tmpl.backup
   mv dot_zshenv_centralized.tmpl dot_zshenv.tmpl
   
   mv dot_config/nushell/env.nu.tmpl dot_config/nushell/env.nu.tmpl.backup  
   mv dot_config/nushell/env_centralized.nu.tmpl dot_config/nushell/env.nu.tmpl
   ```

3. **Apply and test**:
   ```bash
   chezmoi apply
   # Test shell functionality
   ```

## Advanced Features

### Conditional Variables
```yaml
conditional:
  work_environment:
    condition: "{{ if and (hasKey . \"WORK_ENVIRONMENT\") (eq .WORK_ENVIRONMENT true) }}"
    variables:
      work_var: "work_value"
```

### Shell-Specific Mappings
```yaml
shell_mappings:
  variable_name:
    zsh: "ZSH_NAME"
    nushell: "NU_NAME"
```

### Dynamic PATH Management
```yaml
path_entries:
  - "/usr/local/bin"      # High priority
  - "${HOME}/.local/bin"  # Variable expansion

conditional_path:
  tool_name:
    condition: "{{ .tool.enabled }}"
    path: "${HOME}/.tool/bin"
```

This centralized system eliminates the environment variable inconsistencies identified in the analysis while providing a foundation for consistent multi-shell configuration management.