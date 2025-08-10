# Dotfiles Repository Architecture Diagram

```mermaid
flowchart TD
  %% High-level groupings as top-level subgraphs
  subgraph Chezmoi_Source_State["Chezmoi Source State [.local/share/chezmoi]"]
    ZshAliases[dot_config/zsh/aliases.zsh]
    ZshOther[dot_config/zsh/other zsh files]
    NuAliases[dot_config/nushell/aliases.nu.tmpl]
    NuOther[dot_config/nushell/other nushell files]
    GitReadme[dot_config/git/README.md]
    GitOther[dot_config/git/other git files]
    Kitty[dot_config/kitty/]
    Tmux[dot_config/tmux/]
    Starship[dot_config/starship/]
    Yazi[dot_config/yazi/]
    DotShellRegistry[.chezmoidata/dot_shell_registry.yaml]
    OtherData[.chezmoidata/other data files]
    RunGenShellConfigs[.chezmoiscripts/run_generate_shell_configs.sh]
    OtherScripts[.chezmoiscripts/other scripts]
    Templates[.chezmoitemplates/template files]
    ChezmoiTemplate[.chezmoi.toml.tmpl]
  end

  subgraph Persistent_Config["Persistent Configuration System"]
    ConfigHelpers[.scripts/utilities/config-persistence-helpers.sh]
    BackupScript[.scripts/utilities/chezmoi-backup-config]
    RestoreScript[.scripts/utilities/chezmoi-restore-config]
    MacOSDefaults[macOS defaults\ncom.chezmoi.config]
    LinuxStorage[Linux dconf/gsettings\nXDG config]
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
    Readme[README.md]
    CrossShellPlan[CROSS_SHELL_DOTFILES_PLAN.md]
    DirectoryMd[DIRECTORY.md]
    Contributing[CONTRIBUTING.md]
    Security[SECURITY.md]
    PersistentConfigDoc[PERSISTENT_CONFIGURATION.md]
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
