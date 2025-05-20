# Dotfiles Repository Architecture Diagram

```mermaid
flowchart TD
  %% High-level groupings
  subgraph Chezmoi_Source_State["Chezmoi Source State (.local/share/chezmoi)"]
    direction TB
    subgraph Dotfiles_Config["dot_config/"]
      subgraph Zsh_Config["zsh/"]
        ZshAliases[aliases.zsh]
        ZshOther[other zsh files]
      end
      subgraph Nushell_Config["nushell/"]
        NuAliases[aliases.nu.tmpl]
        NuOther[other nushell files]
      end
      subgraph Git_Config["git/"]
        GitReadme[README.md]
        GitOther[other git files]
      end
      subgraph Other_Tools["other tools"]
        Kitty[kitty/]
        Tmux[tmux/]
        Starship[starship/]
        Yazi[yazi/]
        %% ...etc
      end
    end
    subgraph Chezmoi_Data[".chezmoidata/"]
      DotShellRegistry[dot_shell_registry.yaml]
      OtherData[other data files]
    end
    subgraph Chezmoi_Scripts[".chezmoiscripts/"]
      RunGenShellConfigs[run_generate_shell_configs.sh]
      OtherScripts[other scripts]
    end
    subgraph Chezmoi_Templates[".chezmoitemplates/"]
      Templates[template files]
    end
  end

  subgraph Automation["Automation & Generation"]
    direction TB
    GenScript[scripts/generate_shell_configs.py]
    PreCommit[pre-commit hook (optional)]
    CI[CI pipeline (optional)]
  end

  subgraph Documentation["Documentation"]
    Readme[README.md]
    CrossShellPlan[CROSS_SHELL_DOTFILES_PLAN.md]
    DirectoryMd[DIRECTORY.md]
    Contributing[CONTRIBUTING.md]
    Security[SECURITY.md]
    Todo[TODO/]
  end

  subgraph Chezmoi_Target_State["Chezmoi Target State (Home Directory)"]
    direction TB
    HomeZshrc[~/.zshrc]
    HomeNushell[~/.config/nushell/aliases.nu]
    HomeGitconfig[~/.gitconfig]
    HomeOther[other dotfiles]
  end

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

  Chezmoi_Data -- Used in --> Chezmoi_Templates
  Chezmoi_Templates -- Used to generate --> Chezmoi_Target_State

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
  GenScript -- (optional) Calls LLM API for function translation --> AI[OpenAI/Local LLM]
```

---

**How to view:**

- Paste this code into a markdown file and use a Mermaid-enabled viewer (VS Code, GitHub, etc.) to render the diagram.
- The diagram shows both high-level groupings (big boxes) and detailed relationships between all major components in your dotfiles repo.
