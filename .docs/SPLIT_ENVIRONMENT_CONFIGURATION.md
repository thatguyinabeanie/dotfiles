# Split Environment Configuration System

The environment variable configuration uses a personal/work split approach within the `.chezmoidata/` directory structure.

## Directory Structure

```text
.chezmoidata/
├── personal.yaml        # Personal development environment
├── work.yaml           # Work/corporate environment  
├── shared.yaml         # Shared configuration across contexts
├── applications.yaml   # Application-specific configurations
├── tools.yaml          # Development tools and utilities
├── lsp.yaml           # Language Server Protocol configurations
├── services.yaml      # macOS system services configuration
└── ai/                # AI provider configurations
    ├── agents.yaml
    └── github-copilot.yaml
```

## Configuration Philosophy

### ✅ **Context-Based Split**

- **Personal development** → `personal.yaml`
- **Work environment** → `work.yaml`  
- **Shared settings** → `shared.yaml`
- **App-specific config** → `applications.yaml`

### ✅ **Tool-Focused Organization**

- Development tools and utilities in `tools.yaml`
- LSP server configurations in `lsp.yaml`
- System services in `services.yaml`
- AI configurations in `ai/` subdirectory

### ✅ **Template Integration**

- All YAML files provide data for Chezmoi templates
- Environment variables generated in shell profiles
- Conditional logic based on work/personal context
- Cross-platform compatibility with macOS/Linux detection

## Core Configuration Files

### Personal vs Work Split

**`personal.yaml`** - Personal development environment
```yaml
# Personal development settings
DEVELOPMENT_MODE: true
PERSONAL_PROJECTS_DIR: "{{ .chezmoi.homeDir }}/Code/personal"
GITHUB_USERNAME: "personal-username"
```

**`work.yaml`** - Work/corporate environment  
```yaml
# Work environment settings
WORK_ENVIRONMENT: true
WORK_PROJECTS_DIR: "{{ .chezmoi.homeDir }}/Code/work"
CORPORATE_PROXY: "http://proxy.company.com:8080"
```

**`shared.yaml`** - Cross-context configuration
```yaml
# XDG Base Directories
XDG_CONFIG_HOME: "{{ .chezmoi.homeDir }}/.config"
XDG_DATA_HOME: "{{ .chezmoi.homeDir }}/.local/share"

# Editor configuration
EDITOR: "nvim"
VISUAL: "nvim"
```

### Tool-Specific Configuration

**`applications.yaml`** - Application configurations
```yaml
# Browser settings
DEFAULT_BROWSER: "{{ .applications.browser }}"

# Terminal applications
TERMINAL: "{{ .applications.terminal }}"
TMUX_CONFIG: "{{ .chezmoi.homeDir }}/.config/tmux"
```

**`tools.yaml`** - Development tools
```yaml
# Version managers
FNM_DIR: "{{ .chezmoi.homeDir }}/.local/share/fnm"
MISE_CONFIG_DIR: "{{ .chezmoi.homeDir }}/.config/mise"

# Build tools  
CARGO_HOME: "{{ .chezmoi.homeDir }}/.cargo"
GOPATH: "{{ .chezmoi.homeDir }}/go"
```

**`lsp.yaml`** - Language Server Protocol
```yaml
# LSP server configurations for Neovim/editors
formatters:
  lua: ["stylua"]
  go: ["gofumpt", "goimports"]
  
linters:  
  lua: ["luacheck"]
  go: ["golangci-lint"]
```

## Template Usage

### Environment Generation

Environment variables are generated in shell templates:

**`dot_zshenv.tmpl`** - Zsh environment
```bash
{{ if .WORK_ENVIRONMENT -}}
# Work environment active
export WORK_MODE=true
{{ else -}}
# Personal environment active  
export PERSONAL_MODE=true
{{ end -}}

# Shared settings
export EDITOR="{{ .EDITOR }}"
export XDG_CONFIG_HOME="{{ .XDG_CONFIG_HOME }}"
```

**`env.nu.tmpl`** - Nushell environment
```nushell
{{ if .WORK_ENVIRONMENT -}}
$env.WORK_MODE = true
{{ else -}}
$env.PERSONAL_MODE = true  
{{ end -}}

$env.EDITOR = "{{ .EDITOR }}"
```

### Conditional Configuration

**Work Detection Logic**:
```yaml
# In personal.yaml or work.yaml
WORK_ENVIRONMENT: {{ .work.enabled | default false }}
```

**Platform Detection**:
```yaml
{{ if eq .chezmoi.os "darwin" -}}
# macOS-specific configuration
HOMEBREW_PREFIX: "/opt/homebrew"
{{ else if eq .chezmoi.os "linux" -}}
# Linux-specific configuration  
HOMEBREW_PREFIX: "/home/linuxbrew/.linuxbrew"
{{ end -}}
```

## Actual Implementation Details

### Current Structure Benefits

1. **Simple organization**: Flat YAML structure in `.chezmoidata/`
2. **Clear separation**: Personal/work split with shared common config
3. **Tool-focused**: Dedicated files for specific tool categories
4. **Template-driven**: All configuration flows through Chezmoi templates

### Key Differences from Previous Design

- **No nested environment directory**: Uses flat `.chezmoidata/` structure
- **No shell-specific YAML files**: Shell differences handled in templates
- **No complex loading system**: Simple template-based generation
- **No environment modules**: Direct YAML data to template flow

## Usage Examples

### Adding New Development Tool

**Edit `tools.yaml`**:
```yaml
# Add Rust configuration
RUSTUP_HOME: "{{ .chezmoi.homeDir }}/.local/share/rustup"
CARGO_HOME: "{{ .chezmoi.homeDir }}/.cargo"
RUST_BACKTRACE: "1"
```

**Apply changes**:
```bash
chezmoi apply
```

### Adding Work-Specific Setting

**Edit `work.yaml`**:
```yaml
# Add corporate tool
CORPORATE_VPN: "{{ .work.vpn_endpoint }}"
KUBERNETES_NAMESPACE: "{{ .work.k8s_namespace }}"
```

### Adding Cross-Platform Path

**Edit `shared.yaml`**:
```yaml
{{ if eq .chezmoi.os "darwin" -}}
HOMEBREW_BIN: "/opt/homebrew/bin"
{{ else -}}
HOMEBREW_BIN: "/home/linuxbrew/.linuxbrew/bin"  
{{ end -}}
```

## Integration with Other Systems

### LSP Integration
- `lsp.yaml` provides configuration for Neovim LSP servers
- Formatters and linters defined per language
- Mason tool management integration

### Services Integration  
- `services.yaml` manages macOS LaunchAgents
- Automatic service restart on configuration changes
- Integration with Homebrew services

### AI Integration
- `ai/` directory contains AI provider configurations
- GitHub Copilot settings and API keys
- Agent configurations for different AI tools

## Migration and Maintenance

### Current Benefits
- **Simpler than documented**: Actual implementation is more straightforward
- **Effective organization**: Personal/work split works well in practice
- **Easy to maintain**: Flat structure is easier to navigate and modify
- **Template flexibility**: Chezmoi templates provide needed conditional logic

### Future Enhancements
- Could add shell-specific sections within existing files
- Could expand AI configurations as new tools are added
- Could add more sophisticated work environment detection
- Could implement configuration validation

This split configuration approach provides an effective balance between organization and simplicity, making it easy to maintain environment configurations across different contexts and platforms.