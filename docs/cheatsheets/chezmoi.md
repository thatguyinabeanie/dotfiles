# chezmoi

**Dotfiles manager**—source lives in `~/.local/share/chezmoi/`.

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

## 🔄 Core Workflow

| Command | Action |
|---------|--------|
| `chezmoi apply --dry-run` | Preview changes without applying |
| `chezmoi apply --force` | Apply all changes |
| `chezmoi diff` | Show what would change |
| `chezmoi status` | Show managed file status |
| `chezmoi update` | Pull latest and apply |
| `chezmoi cd` | `cd` into the source directory |

## ✏️ Editing Files

| Command | Action |
|---------|--------|
| `chezmoi edit FILE` | Edit a managed file in the source |
| `chezmoi edit --apply FILE` | Edit and immediately apply |
| `chezmoi add FILE` | Start managing an untracked file |
| `chezmoi re-add FILE` | Re-sync managed file from target |
| `chezmoi forget FILE` | Stop managing a file (keeps target) |
| `chezmoi destroy FILE` | Stop managing and delete target |

## 📊 Inspecting State

| Command | Action |
|---------|--------|
| `chezmoi managed` | List all managed files |
| `chezmoi unmanaged` | List unmanaged files in home |
| `chezmoi cat FILE` | Show generated content for a file |
| `chezmoi execute-template` | Evaluate a template interactively |
| `chezmoi data` | Dump all template data as JSON |
| `chezmoi source-path FILE` | Show source path for a target file |

## 🗂️ Source Directory Conventions

| Prefix / Suffix | Meaning |
|-----------------|---------|
| `dot_` | Maps to `.` (for example, `dot_zshrc` → `~/.zshrc`) |
| `private_` | File is encrypted |
| `.tmpl` | Processed as a Go template |
| `.chezmoitemplates/` | Shared template partials |
| `.chezmoidata/` | YAML data files for templates |
| `.chezmoiexternal.toml` | External file/archive downloads |
| `.chezmoiscripts/` | Run-once / run-always scripts |
| `run_` | Script that runs every apply |
| `run_once_` | Script that runs only once |
| `run_onchange_` | Script that runs when content changes |

## 🔧 Init & Bootstrap

| Command | Action |
|---------|--------|
| `chezmoi init` | Initialize from remote repo |
| `chezmoi init --apply` | Init and apply in one step |
| `chezmoi init https://github.com/USER/dotfiles` | Init from GitHub |
| `chezmoi upgrade` | Upgrade chezmoi binary |

## 🛠️ Troubleshooting

| Command | Action |
|---------|--------|
| `chezmoi apply -v` | Verbose output for debugging |
| `chezmoi apply --dry-run 2>&1` | Check for template errors |
| `chezmoi state delete-bucket --bucket=scriptState` | Re-run a `run_once_` script |

## 📦 `.chezmoidata/` Files

| File | Purpose |
|------|---------|
| `formatters.yaml` | Code formatters |
| `linters.yaml` | Linters |
| `tools.yaml` | CLI tools (`dev_tools` key) |
| `lsp.yaml` | LSP server configurations |
| `applications.yaml` | macOS GUI apps |
| `aliases.yaml` | Shell aliases (Fish + Zsh) |
