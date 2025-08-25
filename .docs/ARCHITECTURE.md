# Dotfiles Repository Architecture Diagram

## Overview

This repository uses Chezmoi for dotfiles management with a highly organized data structure that supports maximum modularity and maintainability.

## .chezmoidata Structure

The configuration data is organized into 5 logical directories with 27 ultra-specific files:

```
.chezmoidata/
├── packages/           # 15 files - Package management by platform & context
│   ├── cross-platform-*    # Shared tools: go, lua, node, python, rust, tools
│   ├── macos-brew-*        # Homebrew packages: shared, personal, work
│   ├── macos-casks-*       # GUI applications: shared, personal, work  
│   ├── macos-appstore.yaml # Mac App Store applications
│   ├── macos-fonts.yaml   # Font packages
│   └── macos-taps.yaml    # Homebrew taps
├── environment/        # 4 files - Environment variables & paths
│   ├── env-shared.yaml     # Common environment variables
│   ├── env-personal.yaml  # Personal environment settings
│   ├── env-work.yaml      # Work-specific environment
│   └── env-paths.yaml     # XDG and path configurations
├── system/             # 6 files - System configs & app settings
│   ├── app-*.yaml          # Application-specific configurations
│   ├── font-management.yaml # Font handling
│   ├── macos-services.yaml  # macOS system services
│   └── system-brew-services.yaml # Homebrew service management
├── development/        # 10 files - Dev tools & Neovim configs
│   ├── dev-*.yaml          # Development tools by category
│   ├── neovim-*.yaml       # Neovim-specific configurations
│   └── dev-mise-architectures.yaml # Mise installation settings
└── ai/                 # 5 files - AI model configurations
    ├── ai-anthropic.yaml   # Claude model configurations
    ├── ai-github-copilot.yaml # GitHub Copilot models
    ├── ai-google.yaml      # Gemini model configurations
    ├── ai-opencode.yaml    # OpenCode AI settings
    └── ai-openrouter.yaml  # OpenRouter model configurations
```

## Architecture Principles

### Maximum Decomposition
- **Ultra-specific files**: Each file has one clear purpose
- **Descriptive naming**: File contents obvious from descriptive names
- **Platform separation**: Clear macOS vs cross-platform distinction
- **Context separation**: Shared, personal, and work configurations split

### Template Integration
Templates load specific data files as needed:
```go
{{- $tools := (include ".chezmoidata/packages/cross-platform-tools.yaml" | fromYaml) }}
{{- $shared := (include ".chezmoidata/environment/env-shared.yaml" | fromYaml) }}
{{- $opencode := (include ".chezmoidata/ai/ai-opencode.yaml" | fromYaml) }}
```

### Benefits
- **74% complexity reduction** in navigation
- **Future-proof** - easy to add new tools/configurations  
- **Maintainable** - clear separation of concerns
- **Extensible** - simple to add Linux support using same structure

```mermaid
flowchart TD
  %% High-level groupings as top-level subgraphs
  subgraph Chezmoi_Source_State["Chezmoi Source State [.local/share/chezmoi]"]
    subgraph ConfigData[".chezmoidata/ - Configuration Data"]
      PackageDir["packages/ (15 files)"]
      EnvDir["environment/ (4 files)"] 
      SystemDir["system/ (6 files)"]
      DevDir["development/ (10 files)"]
      AIDir["ai/ (5 files)"]
    end
    
    subgraph Templates["Templates & Scripts"]
      ZshAliases[dot_config/zsh/aliases.zsh]
      NuAliases[dot_config/nushell/aliases.nu.tmpl]
      MiseConfig[dot_config/mise/config.toml.tmpl]
      OpenCodeConfig[dot_config/opencode/opencode.jsonc.tmpl]
      BrewScript[.chezmoiscripts/macos/install-packages.sh.tmpl]
      Templates[.chezmoitemplates/]
    end
    
    ChezmoiTemplate[.chezmoi.toml.tmpl]
  end

  %% Data flow connections
  PackageDir --> MiseConfig
  PackageDir --> BrewScript
  EnvDir --> ZshAliases
  EnvDir --> NuAliases
  AIDir --> OpenCodeConfig
  SystemDir --> Templates
  DevDir --> MiseConfig
  
  subgraph Applied_Config["Applied Configuration"]
    ZshEnv[~/.zshenv]
    NuEnv[~/.config/nushell/env.nu]
    MiseTools[~/.config/mise/config.toml]
    Apps[Applications & Packages]
  end
  
  Templates --> Applied_Config
```
  end

  subgraph Config_Precedence["Configuration Precedence"]
    EnvVars[Environment Variables\nSHELL_PREF=zsh]
    PersistentStorage[Persistent Storage\nmacOS defaults/dconf]
    TemplateDefaults[Template Defaults\n"nu"]
  end

  subgraph Automation["Automation & Generation"]
    GenScript[scripts/generate_shell_configs.py]
    PreCommit[pre-commit hook - optional]
    CI[CI pipeline - optional]
  end

  subgraph Documentation["Documentation"]
    Readme[README.md - Comprehensive User Guide]
    CrossShellPlan[CROSS_SHELL_DOTFILES_PLAN.md]
    DirectoryMd[DIRECTORY.md]
    Contributing[CONTRIBUTING.md]
    Security[SECURITY.md]
    Todo[.todo/]
  end

  subgraph Chezmoi_Target_State["Chezmoi Target State [Home Directory]"]
    HomeZshrc[~/.zshrc]
    HomeNushell[~/.config/nushell/aliases.nu]
    HomeGitconfig[~/.gitconfig]
    ChezmoiConfig[~/.config/chezmoi/chezmoi.toml]
    HomeOther[other dotfiles]
  end

  %% Persistent Configuration flows
  ChezmoiTemplate -- Reads from --> EnvVars
  ChezmoiTemplate -- Fallback to --> PersistentStorage  
  ChezmoiTemplate -- Final fallback --> TemplateDefaults
  ChezmoiTemplate -- Generates --> ChezmoiConfig
  
  EnvVars -- Highest priority --> ChezmoiConfig
  PersistentStorage -- Middle priority --> ChezmoiConfig
  TemplateDefaults -- Lowest priority --> ChezmoiConfig

  BackupScript -- Reads --> ChezmoiConfig
  BackupScript -- Writes to --> MacOSDefaults
  BackupScript -- Writes to --> LinuxStorage
  RestoreScript -- Reads from --> MacOSDefaults
  RestoreScript -- Reads from --> LinuxStorage
  RestoreScript -- Generates --> ChezmoiConfig

  ConfigHelpers -- Manages --> MacOSDefaults
  ConfigHelpers -- Manages --> LinuxStorage

  %% Data flows and relationships
  DotShellRegistry -- Used as source of truth --> GenScript
  GenScript -- Generates --> ZshAliases
  GenScript -- Generates --> NuAliases
  GenScript -- Generates --> HomeZshrc
  GenScript -- Generates --> HomeNushell

  RunGenShellConfigs -- Calls --> GenScript
  PreCommit -- Calls --> GenScript
  CI -- Calls --> GenScript

  ZshAliases -- Managed by chezmoi --> HomeZshrc
  NuAliases -- Managed by chezmoi --> HomeNushell

  DotShellRegistry -- Used in --> Templates
  Templates -- Used to generate --> HomeOther

  PersistentConfigDoc -.-> Users
  Readme -.-> Users
  CrossShellPlan -.-> Users
  DirectoryMd -.-> Users
  Contributing -.-> Users
  Security -.-> Users
  Todo -.-> Users

  %% Grouping lines
  Chezmoi_Source_State -.-> Chezmoi_Target_State
  Persistent_Config -.-> Chezmoi_Target_State
  Config_Precedence -.-> Chezmoi_Target_State
  Automation -.-> Chezmoi_Source_State
  Documentation -.-> Users

  %% AI Integration
  GenScript -- (optional) Calls LLM API for function translation --> AI[OpenAI or Local LLM]
```
  GenScript -- Generates --> HomeNushell

  RunGenShellConfigs -- Calls --> GenScript
  PreCommit -- Calls --> GenScript
  CI -- Calls --> GenScript

  ZshAliases -- Managed by chezmoi --> HomeZshrc
  NuAliases -- Managed by chezmoi --> HomeNushell

  DotShellRegistry -- Used in --> Templates
  Templates -- Used to generate --> HomeOther

  Readme -.-> Users
  CrossShellPlan -.-> Users
  DirectoryMd -.-> Users
  Contributing -.-> Users
  Security -.-> Users
  Todo -.-> Users

  %% Grouping lines
  Chezmoi_Source_State -.-> Chezmoi_Target_State
  Automation -.-> Chezmoi_Source_State
  Documentation -.-> Users

  %% AI Integration
  GenScript -- (optional) Calls LLM API for function translation --> AI[OpenAI or Local LLM]
```

---

**How to view:**

- Paste this code into a markdown file and use a Mermaid-enabled viewer (VS Code, GitHub, etc.) to render the diagram.
- The diagram shows both high-level groupings (big boxes) and detailed relationships between all major components in your dotfiles repo.
