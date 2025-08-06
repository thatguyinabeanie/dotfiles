# Shell-Specific Environment Configuration System

The environment configuration has been enhanced with shell-specific YAML files that handle the unique requirements and syntax of different shells.

## Directory Structure

```text
MISSION_CONTROL/.chezmoidata/environment/
├── # Shared environment variables
├── xdg.yaml           # XDG Base Directory variables
├── chezmoi.yaml       # Chezmoi-specific variables
├── git.yaml           # Git configuration
├── path.yaml          # PATH configuration
├── compilation.yaml   # Compilation flags
├── editor.yaml        # Editor settings
├── go.yaml            # Go environment
├── apps.yaml          # Application config directories
├── theming.yaml       # Theme and display settings
├── ide.yaml           # IDE environment variables
├── nodejs.yaml        # Node.js/FNM configuration
├── completion.yaml    # Completion system settings
├── conditional.yaml   # Conditional variables
│
├── # Shell-specific configurations
├── zsh.yaml           # Zsh-specific settings and syntax
├── nushell.yaml       # Nushell-specific settings and syntax
├── bash.yaml          # Bash-specific settings and syntax
└── fish.yaml          # Fish-specific settings and syntax
```

## Shell-Specific Features

### 🐚 **Zsh Configuration** (`zsh.yaml`)

```yaml
shell_name: "zsh"
shell_path: "/opt/homebrew/bin/zsh"

syntax:
  variable_prefix: "export "
  variable_assignment: "="
  command_substitution: "$(...)"
  path_separator: ":"

path_config:
  method: "sequential_export" # PATH="new:$PATH"
  deduplication: false
```

### 🦀 **Nushell Configuration** (`nushell.yaml`)

```yaml
shell_name: "nushell"
shell_path: "/opt/homebrew/bin/nu"

variable_overrides:
  NUSHELL_CONFIG_DIR: "NU_CONFIG_DIR" # Rename variables

exclusive_variables:
  "config.buffer_editor": "nvim" # Nushell-only variables

syntax:
  variable_prefix: "$env."
  variable_assignment: " = "
  command_substitution: "(...)"
  command_substitution_trim: " | str trim"

path_config:
  method: "array_prepend" # Array-based PATH
  deduplication: true # Auto-deduplication

path_transformations:
  # Smart path handling for nushell
  XDG_CONFIG_HOME: '$env.XDG_HOME | path join ".config"'
  GOPATH: '$env.XDG_CONFIG_HOME | path join "go"'
```

### 🐟 **Fish Configuration** (`fish.yaml`)

```yaml
shell_name: "fish"
shell_path: "/opt/homebrew/bin/fish"

syntax:
  variable_prefix: "set -gx "
  variable_assignment: " "
  path_separator: " " # Space-separated paths

path_config:
  method: "fish_path" # set -gx PATH /new/path $PATH
```

### 💥 **Bash Configuration** (`bash.yaml`)

```yaml
shell_name: "bash"
shell_path: "/opt/homebrew/bin/bash"

syntax:
  variable_prefix: "export "
  variable_assignment: "="
  command_substitution: "$(...)"
```

## Benefits of Shell-Specific Configuration

### ✅ **Proper Syntax Handling**

- **Zsh**: `export VAR="value"`
- **Nushell**: `$env.VAR = "value"`
- **Fish**: `set -gx VAR "value"`
- **Bash**: `export VAR="value"`

### ✅ **Shell-Specific Features**

- **Variable Renaming**: `NUSHELL_CONFIG_DIR` → `NU_CONFIG_DIR` in Nushell
- **Exclusive Variables**: `config.buffer_editor` only in Nushell
- **Path Handling**: Array-based in Nushell, string-based in others
- **Command Substitution**: Different syntax per shell

### ✅ **Smart Path Transformations**

- **Nushell**: `$env.HOME | path join ".config"`
- **Others**: `"$HOME/.config"`

### ✅ **Automatic Shell Detection**

- Templates auto-detect target shell from filename
- No manual shell specification needed

## Generic Template System

The `generic-env.tmpl` template uses shell-specific configuration to generate proper syntax:

```go
{{- if eq $shell "nushell" }}
$env.{{ $key }} = $env.XDG_HOME | path join "{{ $value }}"
{{- else }}
export {{ $key }}="{{ $value }}"
{{- end }}
```

## Usage

### Adding Support for a New Shell

1. **Create shell config file**: `environment/newshell.yaml`
2. **Define syntax patterns**: Variable prefixes, assignment operators
3. **Specify path handling**: How the shell manages PATH
4. **Add exclusive variables**: Shell-only environment variables
5. **Create template**: `dot_newshellrc.tmpl` using generic template

### Adding Environment Variables

1. **Edit shared files**: Add variables to appropriate domain file
2. **Automatic generation**: Variables appear in all supported shells
3. **Shell-specific handling**: Syntax automatically adapted per shell

### Customizing Per Shell

1. **Variable overrides**: Rename variables for specific shells
2. **Exclusive variables**: Add shell-only environment variables
3. **Path transformations**: Custom path handling for complex shells

## Example Output Comparison

**Same variable definition generates different syntax:**

**Zsh**:

```bash
export GOPATH="$XDG_CONFIG_HOME/go"
```

**Nushell**:

```nu
$env.GOPATH = $env.XDG_CONFIG_HOME | path join "go"
```

**Fish**:

```fish
set -gx GOPATH "$XDG_CONFIG_HOME/go"
```

This system provides **maximum flexibility** while maintaining **single-source configuration** - edit once in the shared files, get proper syntax for all shells automatically.
