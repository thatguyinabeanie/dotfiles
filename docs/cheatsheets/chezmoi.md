# 🏠 Chezmoi Cheat Sheet

> Dotfiles manager — source lives in `~/.local/share/chezmoi/`
> Press `q` to close · `j/k` to scroll · `/` to search

---

## 🐚 Shell Aliases

| Alias | Command |
|-------|---------|
| `cz` | `chezmoi` |
| `cza` | `chezmoi apply` |
| `czaf` | `chezmoi apply --force` |
| `czd` | `chezmoi diff` |
| `cze` | `chezmoi edit` |
| `czcd` | `chezmoi cd` |
| `czu` | `chezmoi update` |
| `czs` | `chezmoi status` |
| `czdr` | `chezmoi apply --dry-run` |

---

## 🔄 Core Workflow

| Command | Description |
|---------|-------------|
| `chezmoi apply --dry-run` | **Preview** changes without applying |
| `chezmoi apply --force` | Apply all changes |
| `chezmoi diff` | Show what would change |
| `chezmoi status` | Show managed file status |
| `chezmoi update` | Pull latest + apply |
| `chezmoi cd` | `cd` into the source directory |

> **Rule:** Always `--dry-run` before `--force`.

---

## ✏️ Editing Files

| Command | Description |
|---------|-------------|
| `chezmoi edit <file>` | Edit a managed file in the source |
| `chezmoi edit ~/.zshrc` | Edit zshrc source |
| `chezmoi edit --apply <file>` | Edit and immediately apply |
| `chezmoi add <file>` | Start managing an untracked file |
| `chezmoi re-add <file>` | Re-sync managed file from target |
| `chezmoi forget <file>` | Stop managing a file (keeps target) |
| `chezmoi destroy <file>` | Stop managing and delete target |

---

## 📊 Inspecting State

| Command | Description |
|---------|-------------|
| `chezmoi status` | Show changed / new / removed files |
| `chezmoi diff` | Full diff of pending changes |
| `chezmoi managed` | List all managed files |
| `chezmoi unmanaged` | List unmanaged files in home |
| `chezmoi cat <file>` | Show generated content for a file |
| `chezmoi execute-template` | Evaluate a template interactively |
| `chezmoi data` | Dump all template data as JSON |

---

## 🗂️ Source Directory Conventions

| Prefix / Suffix | Meaning |
|-----------------|---------|
| `dot_` | Maps to `.` (e.g., `dot_zshrc` → `~/.zshrc`) |
| `private_` | File is encrypted |
| `.tmpl` | Processed as a Go template |
| `.chezmoitemplates/` | Shared template partials |
| `.chezmoidata/` | YAML data files for templates |
| `.chezmoiexternal.toml` | External file/archive downloads |
| `.chezmoiscripts/` | Run-once / run-always scripts |
| `run_` | Script that runs every apply |
| `run_once_` | Script that runs only once |
| `run_onchange_` | Script that runs when content changes |

---

## 📦 Package Management (This Repo)

> **Never** run `brew install`, `npm install -g`, etc. manually.
> All packages are declared in `.chezmoidata/*.yaml`.

| File | Purpose |
|------|---------|
| `formatters.yaml` | Code formatters |
| `linters.yaml` | Linters |
| `tools.yaml` | CLI tools (`dev_tools` key) |
| `lsp.yaml` | LSP server configurations |
| `applications.yaml` | macOS GUI apps |
| `aliases.yaml` | Shell aliases (Fish + Zsh) |

**Add a tool:**

```yaml
# .chezmoidata/tools.yaml
dev_tools:
  - name: my-tool
    installer: [mise]
    description: "Does something useful"
```

Then: `chezmoi apply --dry-run` → `chezmoi apply --force`

---

## 🧪 Templates

```bash
# Test template rendering
chezmoi execute-template < dot_zshrc.tmpl

# Dump all data available in templates
chezmoi data

# Preview generated content for a specific file
chezmoi cat ~/.zshrc
```

**Common template variables:**

```
{{ .chezmoi.os }}          # "darwin" or "linux"
{{ .chezmoi.hostname }}    # machine hostname
{{ .nvim.colorscheme }}    # from shared.yaml
{{ .CATPPUCCIN_FLAVOR }}   # from shared.yaml
```

---

## 🔧 Init & Bootstrap

| Command | Description |
|---------|-------------|
| `chezmoi init` | Initialize from remote repo |
| `chezmoi init --apply` | Init + apply in one step |
| `chezmoi init https://github.com/user/dotfiles` | Init from GitHub |
| `chezmoi upgrade` | Upgrade chezmoi binary |

---

## 🛠️ Troubleshooting

```bash
# Verbose output for debugging
chezmoi apply -v

# See exact source state
chezmoi source-path ~/.zshrc

# Re-run a run_once_ script (delete its hash)
chezmoi state delete-bucket --bucket=scriptState

# Check for template errors
chezmoi apply --dry-run 2>&1
```
