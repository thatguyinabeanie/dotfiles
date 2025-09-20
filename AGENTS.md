# Agents.md

## Project Overview

This repository contains a comprehensive and highly-automated dotfiles configuration managed by [Chezmoi](https://www.chezmoi.io/). It aims to create a consistent, modern, and efficient development environment across multiple machines, with a strong emphasis on macOS and a clear path for Linux expansion.

The setup is meticulously organized, leveraging a modular data structure within the `.chezmoidata` directory to manage packages, environment variables, system configurations, and development tools. It uses `mise` for tool version management, ensuring reproducible environments.

Key technologies include **Go** for testing, **Shell (Bash/Zsh/Nushell)** for scripting, **Lua** for Neovim configuration, and extensive **YAML** for data configuration.

## Agent Documentation

For detailed information about managing this chezmoi dotfiles repository, see the dedicated agent documentation at `.opencode/agent/chezmoi-dotfiles-manager.md`. This includes:

- Build and test commands
- Template development best practices
- Code style guidelines
- Configuration management details
- macOS-specific file handling
- Step-by-step workflows for common tasks

## Quick Start

```bash
# Clone and initialize the repository
git clone <repository-url>
cd <repository-directory>
chezmoi init --apply --force

# Run quality checks
lefthook run pre-commit

# Run tests
cd .tests && go test ./...
```

## Available Tools

### Context7 Integration Tools

- **context7_resolve_library_id**: Resolves a package/product name to a Context7-compatible library ID and returns a list of matching libraries. Must be called before fetching documentation to obtain valid library IDs.
- **context7_get_library_docs**: Fetches up-to-date documentation for a library using a Context7-compatible library ID. Supports topic-focused retrieval and token limits for optimized context.

## Specialized Agent Architecture

This repository leverages a specialized agent architecture where the **chezmoi-dotfiles-manager** acts as an orchestrator coordinating with domain-specific agents for complex multi-step operations.

### Agent Orchestration Patterns

**Orchestrator Agent (chezmoi-dotfiles-manager)**
- High-degree reasoning and task coordination
- Analyzes requests and determines which specialized agents to engage
- Coordinates multi-agent workflows for complex changes
- Maintains state consistency across configuration areas
- Provides unified feedback on multi-step operations

**Specialized Agent Categories**

**Core Infrastructure Agents**
- Configuration Validator: YAML consistency, template syntax, cross-platform compatibility
- Environment Sync: Local vs remote state comparison, drift detection
- Security Auditor: Secret scanning, permission validation, integration security

**Tool-Specific Agents**
- Package Manager: Brew/mise/cargo updates, dependency resolution
- Shell Configuration: Performance optimization, plugin management
- Development Environment: Language setups, LSP configuration

**Application-Specific Agents**
- Terminal Multiplexer: tmux/zellij configuration management
- Editor Configuration: nvim/vscode plugin and setting management
- Git Workflow: Hook management, signing, repository-specific settings

**System Integration Agents**
- macOS Integration: System preferences, Homebrew services, Launch Agents
- Theme Manager: Cross-application theme synchronization
- Backup & Recovery: Configuration snapshots, disaster recovery

### Multi-Agent Workflow Examples

**Development Environment Update**
```
Request → Orchestrator → [Security Auditor → Package Manager → Development Environment → Git Workflow]
```

**Theme Synchronization**
```
Request → Orchestrator → [Configuration Validator → Theme Manager → Terminal Multiplexer → Editor Configuration]
```

**System Migration**
```
Request → Orchestrator → [Backup & Recovery → Environment Sync → Package Manager → System Integration]
```

The orchestrator ensures proper sequencing, dependency handling, and rollback capabilities across all agent interactions.
