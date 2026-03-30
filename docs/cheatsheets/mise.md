# 🎛️ Mise Cheat Sheet

> Version manager for dev tools, runtimes, and task runner.
> Press `q` to close · `j/k` to scroll · `/` to search

---

## 🐚 Shell Aliases

| Alias | Command |
|-------|---------|
| `mx` | `mise` |
| `mxi` | `mise install` |
| `mxu` | `mise use` |
| `mxr` | `mise run` |
| `mxl` | `mise ls` |
| `mxt` | `mise trust` |

---

## 📦 Installing & Managing Tools

| Command | Description |
|---------|-------------|
| `mise install` | Install all tools defined in `.mise.toml` |
| `mise install <tool>@<version>` | Install specific version |
| `mise install <tool>@latest` | Install latest version |
| `mise use <tool>@<version>` | Set version for current project (writes `.mise.toml`) |
| `mise use -g <tool>@<version>` | Set version globally |
| `mise uninstall <tool>@<version>` | Uninstall a specific version |
| `mise ls` | List installed tools and versions |
| `mise ls-remote <tool>` | List available versions for a tool |
| `mise upgrade` | Upgrade tools to latest matching versions |
| `mise prune` | Remove unused tool versions |

---

## 🌐 Version Resolution

| Command | Description |
|---------|-------------|
| `mise current` | Show current active versions |
| `mise current <tool>` | Show active version of a specific tool |
| `mise which <tool>` | Show path to active binary |
| `mise where <tool>@<version>` | Show install path of a version |
| `mise doctor` | Diagnose mise setup |

---

## 🔒 Trust

| Command | Description |
|---------|-------------|
| `mise trust` | Trust current directory's `.mise.toml` |
| `mise trust <path>` | Trust a specific `.mise.toml` file |
| `mise untrust` | Revoke trust for current directory |

---

## 🏃 Task Runner

| Command | Description |
|---------|-------------|
| `mise run <task>` | Run a task defined in `.mise.toml` |
| `mise run` | List all available tasks |
| `mise tasks` | List all tasks with descriptions |
| `mxr <task>` | Run a task (alias) |

---

## ⚙️ Configuration

| File | Scope | Description |
|------|-------|-------------|
| `~/.config/mise/config.toml` | Global | Global defaults |
| `.mise.toml` | Project | Project-local tools & tasks |
| `.tool-versions` | Project | Legacy asdf-compatible format |

**Example `.mise.toml`:**

```toml
[tools]
node = "22"
python = "3.12"
rust = "latest"

[tasks.build]
run = "cargo build --release"

[tasks.test]
run = "cargo test"
```

---

## 🔄 Environment Variables

| Command | Description |
|---------|-------------|
| `mise env` | Show env vars mise would set |
| `mise env -s bash` | Output for specific shell |
| `mise activate fish` | Show activation code for fish |
| `mise activate zsh` | Show activation code for zsh |

---

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

---

## 🔍 Troubleshooting

```bash
# Run full diagnostics
mise doctor

# Check which config file is active
mise config

# See what mise does with your PATH
mise env

# Re-shim all tools
mise reshim
```
