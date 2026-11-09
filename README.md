# Dotfiles

Personal macOS dotfiles managed with [chezmoi](https://www.chezmoi.io/). The shell is zsh, the editor is
Neovim, and the theme is Catppuccin. Every package is declared in `.chezmoidata/*.yaml` and installed by
`chezmoi apply`, never by hand.

## Set up a fresh Mac

Run one command. It installs chezmoi into `~/.local/bin`, clones this repo, and applies it.

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin init --apply thatguyinabeanie
```

`chezmoi init` asks one question: whether this is a work machine. To skip the prompt, set
`WORK_ENVIRONMENT=true` (or `false`) before the command. The answer is saved in the macOS `defaults`
domain `com.chezmoi.config`, so re-running `chezmoi init` later asks nothing.

Apply then runs the `run_once_` and `run_onchange_` scripts in `.chezmoiscripts/`. They set the machine
hostname, install Homebrew formulae and casks, mise, rustup, and Claude Code, then install the
mise, cargo, npm, pip, go, gem, and bun packages.

Work tokens are not part of this repo. Add them by hand to `~/mise.toml` (see "Work secrets" in
`AGENTS.md`).

## Daily commands

Always preview before applying.

```bash
chezmoi apply --dry-run   # alias: czdr
chezmoi diff              # alias: czd
chezmoi apply             # alias: cza
chezmoi edit <file>       # alias: cze
chezmoi cd                # alias: czcd
chezmoi update            # alias: czu, pulls the repo and applies
chezmoi status            # alias: czs
```

Edit the chezmoi source (`dot_config/...`, `.chezmoidata/*.yaml`), not the files in `~/.config/`.
To add or remove a package, edit the matching YAML file in `.chezmoidata/`. To uninstall, set
`install: false` on the entry and keep it.

## Checks

Git hooks are managed by [lefthook](https://lefthook.dev/). Install them once after cloning, and run
all checks on demand.

```bash
lefthook install
lefthook run pre-commit --all-files   # same as: mise run lint
```

The hooks run Vale, markdownlint, markdown link check, shellcheck, stylua, luacheck, yamllint, and
gitleaks. They are defined in `lefthook.yml`.

## Where things are

| Path                   | What it holds                                       |
| ---------------------- | --------------------------------------------------- |
| `.chezmoidata/`        | Package lists, aliases, and shared settings (YAML)  |
| `.chezmoitemplates/`   | Shared template code that reads that data           |
| `.chezmoiscripts/`     | Install scripts that run during `chezmoi apply`     |
| `dot_config/`          | Source for `~/.config/` (nvim, tmux, ghostty, etc.) |
| `docs/cheatsheets/`    | Keybinding and alias quick references               |

`AGENTS.md` has the working rules for this repo (it is also loaded as `CLAUDE.md`). Per-tool notes
live in `dot_config/<tool>/AGENTS.md`, and `docs/ONEPASSWORD_SETUP.md` covers 1Password.
