# mise

**Version manager and task runner**—manage dev tool versions per project.

## 🐚 Shell Aliases

| Alias | Command |
|-------|---------|
| `mx` | `mise` |
| `mxi` | `mise install` |
| `mxu` | `mise use` |
| `mxr` | `mise run` |
| `mxl` | `mise ls` |
| `mxt` | `mise trust` |

## 📦 Installing & Managing Tools

| Command | Action |
|---------|--------|
| `mise install` | Install all tools defined in `.mise.toml` |
| `mise install TOOL@VERSION` | Install a specific version |
| `mise install TOOL@latest` | Install latest version |
| `mise use TOOL@VERSION` | Set version for current project |
| `mise use -g TOOL@VERSION` | Set version globally |
| `mise uninstall TOOL@VERSION` | Uninstall a specific version |
| `mise ls` | List installed tools and versions |
| `mise ls-remote TOOL` | List available versions for a tool |
| `mise upgrade` | Upgrade tools to latest matching versions |
| `mise prune` | Remove unused tool versions |

## 🌐 Version Resolution

| Command | Action |
|---------|--------|
| `mise current` | Show current active versions |
| `mise current TOOL` | Show active version of a specific tool |
| `mise which TOOL` | Show path to active binary |
| `mise where TOOL@VERSION` | Show install path of a version |
| `mise doctor` | Diagnose mise setup |

## 🔒 Trust

| Command | Action |
|---------|--------|
| `mise trust` | Trust current directory's `.mise.toml` |
| `mise trust PATH` | Trust a specific `.mise.toml` file |
| `mise untrust` | Revoke trust for current directory |

## 🏃 Task Runner

| Command | Action |
|---------|--------|
| `mise run TASK` | Run a task defined in `.mise.toml` |
| `mise run` | List all available tasks |
| `mise tasks` | List all tasks with descriptions |

## 🔄 Environment

| Command | Action |
|---------|--------|
| `mise env` | Show env vars mise would set |
| `mise env -s bash` | Output for a specific shell |
| `mise config` | Check which config file is active |
| `mise reshim` | Re-shim all tools |

## 🗂️ Common Tool Names

| Tool | Example |
|------|---------|
| `node` | `mise use node@22` |
| `python` | `mise use python@3.12` |
| `ruby` | `mise use ruby@3.3` |
| `go` | `mise use go@latest` |
| `rust` | `mise use rust@latest` |
| `java` | `mise use java@21` |
| `terraform` | `mise use terraform@1.7` |
| `kubectl` | `mise use kubectl@latest` |
