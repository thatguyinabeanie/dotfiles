# Split Environment Configuration System

The environment variable configuration has been split into logical, manageable files within `MISSION_CONTROL/.chezmoidata/environment/`.

## Directory Structure

```
MISSION_CONTROL/.chezmoidata/environment/
├── xdg.yaml           # XDG directories + app configs + editor + theming
├── path.yaml          # PATH configuration
├── git.yaml           # Git configuration  
├── nodejs.yaml        # Node.js and npm tools
├── compilation.yaml   # Build tools and compilers
├── work.yaml          # Work/corporate environment
├── conditional.yaml   # Conditional variables (docker, ai)
└── shells/
    ├── zsh.yaml       # Zsh-specific config
    ├── nushell.yaml   # Nushell-specific config
    ├── bash.yaml      # Bash-specific config
    └── fish.yaml      # Fish-specific config
```

## Benefits of Split Configuration

### ✅ **Focused Editing**
- **Add Git variables** → Edit only `git.yaml`
- **Add Node.js tools** → Edit only `nodejs.yaml`  
- **Add new app directory** → Edit only `xdg.yaml`
- **Add work environment** → Edit only `work.yaml`

### ✅ **Clear Organization**
- Each file has a single responsibility
- Related variables are grouped together
- Easy to find and modify specific settings

### ✅ **Reduced Conflicts**
- Multiple people can edit different areas simultaneously
- Changes are isolated to specific domains
- Easier to review and understand changes

### ✅ **Maintainability**
- Small, focused files are easier to understand
- Comments and documentation can be more specific
- Testing changes is more targeted

## File Descriptions

### Core Configuration Files

**`xdg.yaml`** - XDG Base Directory + App Configurations
```yaml
# XDG Base Directories
XDG_CONFIG_HOME: "$XDG_HOME/.config"
XDG_DATA_HOME: "$XDG_HOME/.local/share"

# Application Directories
TMUX_CONFIG_DIR: "$XDG_CONFIG_HOME/tmux"
VSCODE_USER_DATA_DIR: "$XDG_CONFIG_HOME/code"
GOPATH: "$XDG_CONFIG_HOME/go"

# Editor & Theming
EDITOR: "nvim"
BAT_THEME: "Catppuccin {{ title .CATPPUCCIN_FLAVOR }}"
```

**`path.yaml`** - PATH Configuration
```yaml
entries:
  - "/usr/local/bin"
  - "/opt/homebrew/bin"
  - "$HOME/.cargo/bin"
  - "$HOME/.local/bin"
```

### Domain-Specific Configuration

**`compilation.yaml`** - Build flags and compilation
```yaml
SDKROOT: "$(xcrun --sdk macosx --show-sdk-path)"
LDFLAGS: "-L/opt/homebrew/opt/openssl@3/lib"
CPPFLAGS: "-I/opt/homebrew/opt/openssl@3/include"
```

**`git.yaml`** - Git configuration
```yaml
GIT_CONFIG_GLOBAL: "$XDG_CONFIG_HOME/git/config"
GIT_CONFIG_SYSTEM: "/etc/gitconfig"
```

**`nodejs.yaml`** - Node.js and FNM
```yaml
FNM_VERSION_FILE_STRATEGY: "local"
FNM_DIR: "{{ .chezmoi.homeDir }}/.local/share/fnm"
FNM_LOGLEVEL: "info"
```

**`work.yaml`** - Work/corporate environment
```yaml
WORK_ENVIRONMENT: "{{ .WORK_ENVIRONMENT | default false }}"
GOOGLE_CLOUD_PROJECT: "{{ .work.google_cloud_project }}"
DOCKER_DEFAULT_PLATFORM: "linux/amd64"
KUBERNETES_NAMESPACE: "{{ .work.k8s_namespace }}"
```

### Shell-Specific Configuration

**`shells/zsh.yaml`**, **`shells/nushell.yaml`**, **`shells/bash.yaml`**, **`shells/fish.yaml`** - Shell-specific variables and settings

### Conditional Configuration

**`conditional.yaml`** - Environment-specific variables
```yaml
docker_credentials:
  condition: "{{ if and (hasKey . \"docker.password\") (hasKey . \"docker.username\") }}"
  variables:
    DOCKERHUB_PASSWORD: "{{ .docker.password }}"
```
    # ... etc
```

## Usage Examples

### Adding a New Development Tool

**Example: Adding Rust environment variables**

1. **Create or edit the relevant file**:
```bash
# Add to apps.yaml or create rust.yaml
RUSTUP_HOME: "$XDG_DATA_HOME/rustup"
CARGO_HOME: "$XDG_DATA_HOME/cargo"
```

2. **Variables automatically appear in both shells** when templates are applied

### Adding IDE Support

1. **Edit `ide.yaml`**:
```yaml
CURSOR_USER_DATA_DIR: "$XDG_CONFIG_HOME/cursor"
ZED_CONFIG_DIR: "$XDG_CONFIG_HOME/zed"
```

2. **Apply changes**:
```bash
chezmoi apply
```

### Adding Conditional Variables

1. **Edit `conditional.yaml`**:
```yaml
rust_development:
  condition: "{{ if .rust.enabled }}"
  variables:
    RUST_BACKTRACE: "1"
    RUSTC_WRAPPER: "sccache"
```

## Migration Strategy

This split structure provides:
- **Immediate benefits** - easier navigation and editing
- **Future flexibility** - can create template automation later
- **Clean organization** - logical grouping of related variables

The simple templates (`dot_zshenv_simple.tmpl` and `env_simple.nu.tmpl`) provide a clean baseline that can be enhanced with this modular structure as needed.