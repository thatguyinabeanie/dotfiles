# Dotfiles Ecosystem Research (2025-2026)

> **Last updated:** 2026-03-25
> Research conducted March 2026. Star counts and status reflect data at time of research.

## 1. Executive Summary

chezmoi is the dominant dotfile manager in 2025-2026, with 18.7k GitHub stars, active development,
and the strongest feature set for multi-machine templating, encryption, and password manager
integration. This repository's setup—data-driven YAML package management, profile-based
conditional installation, 1Password integration, and `run_onchange_` scripts—aligns with
current best practices and is more sophisticated than the vast majority of public dotfiles repos.
Nix/Home Manager is the only tool representing a fundamentally different paradigm (packages AND
config in one declarative system with atomic rollbacks), but it comes with a steep learning curve,
macOS as a second-class citizen, governance instability, and ~0% native coverage of GUI apps on
macOS. The practical recommendation: stay with chezmoi, address specific pain points (bootstrapping
speed, remote machine support, secret management for headless servers), and revisit Nix if/when
Linux becomes a primary platform.

---

## 2. Tool Landscape

### Established Tools

| Tool | Stars | Language | Status | Verdict |
|------|-------|----------|--------|---------|
| **chezmoi** | 18.7k | Go | Very Active (v2.70.0, Mar 2026) | Best-in-class for multi-machine dotfile management |
| **mackup** | 15.2k | Python | Stalled + Broken | Broken on macOS Sonoma+; users migrating away |
| **Nix Home Manager** | 9k | Nix | Very Active (25.05 stable) | Different paradigm; best for all-in Nix users |
| **dotbot** | 7.8k | Python | Active | Good for team/shared bootstrap repos |
| **yadm** | 6.2k | Bash | Active (Mar 2026) | Best for git-native minimalists |
| **rcm** (thoughtbot) | 3.2k | Shell | Maintenance only (last release Dec 2022) | Stalled; not recommended for new setups |
| **GNU Stow** | N/A (GNU project) | Perl | Active (Dec 2025) | Simplest approach; no templating or encryption |
| **Bare git repo** | N/A | git | N/A | Zero dependencies; files stay in place |
| **Ansible** | N/A | Python | Active | Overkill for dotfiles alone; good for full system provisioning |

### Rust-Based Alternatives

| Tool | Stars | Status | Verdict |
|------|-------|--------|---------|
| **dotter** | 1.9k | Active (Feb 2026) | Handlebars templating; good Windows support |
| **comtrya** | ~550 | Active (Nov 2025) | Ansible-lite for localhost; single binary |
| **Tuckr** | 440 | Active (Mar 2026) | Modern GNU Stow replacement with hooks + encryption |
| **rotz** | 423 | Active (Mar 2026) | Cross-platform bootstrapper; installs packages too |
| **toml-bombadil** | ~400 | Active (2025) | Best for theming/color scheme switching |

### Emerging / New

| Tool | Status | Notable For |
|------|--------|-------------|
| **DotState** | Early (v0.3.1) | Beautiful TUI interface; targets git-averse users |
| **punktf** | Quiet since launch | Cross-platform multi-target; HN reception was skeptical |
| **yolk** | Emerging | Inline templating via comments (files stay valid to their tools) |
| **fleek** | **Deprecated** (Mar 2024) | Was a Nix/Home Manager wrapper; do not use |

### Quick Recommendation by Use Case

| Use Case | Best Tools |
|----------|-------------|
| General-purpose, multi-machine | **chezmoi** |
| Minimalist, no dependencies | **bare git repo** |
| Simple symlinks | **GNU Stow** or **Tuckr** |
| Git-native, minimal magic | **yadm** |
| Full system declarative config | **Nix Home Manager** |
| Full machine bootstrapping | **Ansible** or **comtrya** |
| Theming / color scheme switching | **toml-bombadil** |

---

## 3. Deep Comparisons

### chezmoi vs Nix/Home Manager

| Dimension | chezmoi | Home Manager |
|-----------|---------|-------------|
| **Scope** | Dotfiles only | Dotfiles + packages + services + environment |
| **Language** | Go templates + TOML data | Nix expression language |
| **macOS support** | First-class | Good, but Linux is primary focus |
| **Package management** | Delegates to brew/mise/etc. | Built-in via nixpkgs (113k+ packages) |
| **Secrets** | Age, GPG, 1Password, Bitwarden, etc. | sops-nix or agenix (more complex setup) |
| **Per-machine config** | TOML data file + templates | Host-specific modules + `mkIf` conditionals |
| **Learning curve** | Low-Medium (Go templates, TOML) | High (Nix language, 1-3 months to comfort) |
| **Rollbacks** | Git history only | Built-in generational rollbacks |
| **Portability** | Works anywhere (single static binary) | Requires Nix installed on target |
| **GUI apps (macOS)** | Manages via brew casks | Must delegate to Homebrew via nix-darwin |
| **Escape hatch** | Delete repo, done | Multi-step uninstall with sudo |
| **Generated configs** | Template-rendered, stored in git | Nix-generated, immutable symlinks |

### chezmoi vs yadm

| Dimension | chezmoi | yadm |
|-----------|---------|------|
| **Approach** | Source directory with naming conventions | Bare git repo wrapping `$HOME` |
| **Learning curve** | Medium (must learn `dot_` naming, Go templates) | Low (just git commands) |
| **Templating** | Built-in Go templates (powerful) | Requires external j2cli/envtpl (historically unmaintained) |
| **Per-machine config** | TOML variables + template conditionals | Alternate files via naming convention (`##os.Darwin`) |
| **Encryption** | age, GPG, 1Password, Bitwarden | git-crypt, GPG |
| **File locations** | Files live in `~/.local/share/chezmoi` | Files live in `$HOME` (no renaming) |
| **Scripting** | `run_once_`, `run_onchange_` scripts | Bootstrap script |

### chezmoi vs GNU Stow

| Dimension | chezmoi | GNU Stow |
|-----------|---------|----------|
| **Mechanism** | Copy/template files | Symlinks |
| **Templating** | Full Go template engine | None |
| **Encryption** | Multiple options | None |
| **Dependencies** | Single Go binary | Perl |
| **Complexity** | Medium | Minimal |
| **macOS compatibility** | Full | Some apps don't follow symlinks (macOS Sonoma+) |

### chezmoi vs Bare Git Repo

| Dimension | chezmoi | Bare git repo |
|-----------|---------|--------------|
| **Dependencies** | chezmoi binary | git only |
| **File locations** | Source dir with `dot_` naming | Files stay in `$HOME` |
| **Templating** | Full Go template engine | None |
| **Encryption** | Multiple options | None (manual exclusion) |
| **Risk of accidental `git add`** | Low (separate source dir) | High (working tree is `$HOME`) |
| **Tooling integration** | Full (diff, apply, archive) | Standard git (verbose alias needed) |

---

## 4. Nix Evaluation

### What is Nix?

- **Nix**: A purely functional package manager. Each package is built as a pure function of its
  inputs, stored in an isolated path (`/nix/store/abc123-package-version`). Multiple versions
  coexist without conflict.
- **NixOS**: A Linux distribution built entirely on Nix. The entire OS is declared in config
  files. Linux-only.
- **nix-darwin**: The macOS equivalent of NixOS configuration. Declares system-level settings,
  packages, services. Limited by macOS SIP (can't write to `/usr`, `/System`, `/bin`).
- **Home Manager**: A community project for managing user-level configuration via Nix. Handles
  dotfiles, user packages, environment variables, user services. Works standalone or as a module
  within NixOS/nix-darwin.
- **Flakes**: The modern approach to Nix configuration. A `flake.nix` + `flake.lock` pins exact
  dependency versions. Still officially "experimental" but used by the vast majority of the
  community.
- **Determinate Systems**: A commercial company that ships a Nix fork ("Determinate Nix") with
  stable flakes, parallel evaluation, and other improvements. Their installer (7M+ installs) now
  defaults to their fork exclusively. Community reception is divided.

### Package Coverage Against This Setup

**CLI tools (~90 packages via brew + mise): ~90-95% coverage in nixpkgs**

Most standard tools are available: btop, glances, procs, tree, dust, navi, sd, tealdeer, ncdu,
gdu, jaq, tig, awscli, glow, pandoc, lua, tmux, starship, fzf, zoxide, neovim, ripgrep, bat, fd,
eza, lazygit, k9s, kubectl, helm, terraform, delta, gh, atuin, fish, zsh, imagemagick, bottom,
fastfetch, yazi, jq, yq, hyperfine, zellij, helix, mdbook, dive, postgresql, node, python, ruby,
go, zig, elixir, erlang, julia, gradle, maven, deno, pnpm, uv, pipx, cmake, make, resvg.

**Likely missing or requiring special handling:**

- `okta-aws-cli`—enterprise tool, probably not in nixpkgs
- `acli` (Atlassian CLI)—from custom Homebrew tap, almost certainly not in nixpkgs
- `rust nightly`—requires fenix or oxalica overlay, not just `pkgs.rustc`
- `java zulu-8`—specific JDK distribution needs custom packaging
- `lazyjournal`—newer tool, may not be packaged yet
- `sesh`, `television`, `carapace`—niche tools, availability uncertain
- `pokeget`—niche Rust crate, unlikely in nixpkgs

**GUI apps (brew casks): ~0% native coverage**

Almost none of the GUI apps (aerospace, claude, cursor, ghostty, karabiner-elements, kitty,
raycast, slack, firefox, obsidian, 1password, blender, figma, discord, ableton, bambu-studio,
orcaslicer, etc.) are available as native Nix packages on macOS.

The standard workaround: nix-darwin declaratively manages Homebrew cask installations. You get
declarative config but Homebrew still does the actual installation. Most real-world macOS setups
use Nix for CLI tools and Homebrew (managed by nix-darwin) for GUI apps.

### Practical Considerations

**Learning curve**: Genuinely steep. The Nix language is functional, lazy, and unlike most
languages. Multiple CLI interfaces (old `nix-*` vs new `nix` command), multiple config styles
(channels vs flakes), fragmented documentation. Realistic timeline: basic usage in 1-2 weeks,
comfortable with flakes/modules in 1-3 months, writing derivations in 3-6+ months.

**Disk space**: `/nix/store` grows 20-50 GB for a typical developer setup, 60-100+ GB without
regular garbage collection. Manageable with `nix-collect-garbage -d` and `nix-store --optimise`,
but a real consideration for 256-512 GB MacBook drives.

**Binary caches**: Most nixpkgs packages are pre-built via `cache.nixos.org`. Build times only
matter for custom overlays or very recent commits. For typical use, installs are fast downloads.

**Rollbacks**: Every `darwin-rebuild switch` or `home-manager switch` creates a generation. You can
list, roll back, or switch to any generation. Nothing in the chezmoi/Homebrew world matches this.

### Governance Concerns

The Nix community went through a governance crisis in 2024:

- Anduril (defense contractor) sponsorship controversy at NixCon
- Eelco Dolstra (Nix creator) resigned from the NixOS Foundation board amid conflict-of-interest
  accusations (simultaneously employed by Determinate Systems)
- A Constitutional Assembly was launched; first Nix Steering Committee elected
- October 2025: Vote of no confidence proposed (failed, but indicates ongoing tension)
- Determinate Systems controversy: their installer now only installs their proprietary fork,
  raising "embrace, extend, extinguish" concerns

nixpkgs contribution activity remains strong (59,430 commits in 25.11 release from 2,742
contributors), and NixOS 25.11 shipped successfully. The project continues to function but the
governance situation adds uncertainty. Notable: **Lix**, a community fork of Nix, emerged from
the governance crisis as an alternative to both upstream Nix and Determinate Nix, representing a
third option for users concerned about project direction.

### Migration Stories

**chezmoi to Nix**: Most narratives follow: happy with chezmoi but frustrated managing packages
separately -> discover Nix's unified approach -> spend weeks/months learning -> eventually get a
working setup -> note macOS is second-class.

**Nix back to chezmoi**: A notable and growing body of "switching back" stories:

- htdocs.dev migration: moved to "the more imperative but organisable world of Homebrew and
  Chezmoi," valuing "a robust, widely used, and more conventional macOS setup"
- Common themes: complexity not worth it for macOS-only environments, chezmoi's portability
  undervalued, Home Manager generated configs felt "not theirs," dotfiles in Nix expressions
  aren't usable outside Nix

**Hybrid approach**: Many experienced users run both—Home Manager for Nix-native config,
chezmoi for cross-platform dotfiles that need to work on non-Nix machines.

### Verdict

Nix/Home Manager is a serious alternative for users who are all-in on the Nix ecosystem (NixOS on
servers, nix-darwin on Mac, everything declared in Nix). For macOS-primary users with a working
chezmoi setup who also need to support remote Linux servers and ephemeral machines, the migration
cost is high and the benefits are limited by macOS's second-class status in the Nix world.

---

## 5. Bootstrapping Patterns

### chezmoi One-Liner (Current Best Practice)

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply $GITHUB_USERNAME
```

This clones the repo, runs templates for the current machine's context, and applies everything.
With well-organized `run_once_before_` scripts, this bootstraps an entire dev environment from zero.

### Script Execution Order

1. `run_once_before_` scripts (alphabetical)—run once per content version, before file updates
2. `run_onchange_before_` scripts—run when content changes, before file updates
3. File, directory, and symlink updates
4. `run_once_after_` / `run_onchange_after_` scripts—after file updates

The `run_onchange_` variant with template hashing (hashing `.chezmoidata/*.yaml` content) means
install scripts only re-run when the package list changes—not on every `chezmoi apply`. This
repository already uses this pattern.

### Cloud-init / VPS Bootstrap

For cloud instances (AWS EC2, DigitalOcean, Hetzner), cloud-init user-data can bootstrap chezmoi
at first boot:

```yaml
#cloud-config
packages:
  - git
  - curl

runcmd:
  - sh -c "$(curl -fsLS get.chezmoi.io)" -- -b /usr/local/bin init --apply https://github.com/user/dotfiles.git
```

### GitHub Codespaces

GitHub Codespaces has native dotfiles support. Key requirements:

- Install script must be fully non-interactive
- Detect `$CODESPACES` env var in templates to skip GUI apps and heavy installs:

  ```text
  {{ if env "CODESPACES" }}
  # skip Mac-specific tools, GUI apps, heavy installs
  {{ end }}
  ```

- Set `sourceDir` in `chezmoi.toml.tmpl` (Codespaces clones to non-standard path)

### Dev Containers

Dev containers and dotfiles serve different scopes:

- **Dev container** = project-level environment (language runtimes, project tools)
- **Dotfiles** = user-level preferences (shell, editor, aliases, git config)

Dotfiles complement dev containers rather than replacing them. A good dotfiles setup makes any dev
container feel like home.

### Remote Server Provisioning

**`chezmoi archive` for remote servers:**

```bash
chezmoi archive | ssh user@server -- tar -xf -
```

Generates dotfiles for a config profile and pushes via SSH. Limitation: `chezmoi archive` generates
for the local machine's template context; a dedicated server config can work around this.

**`chezmoi ssh` command**: On the roadmap
([GitHub issue #3676](https://github.com/twpayne/chezmoi/issues/3676))—would SSH into a machine
and temporarily apply dotfiles for that session. Not yet shipped as of early 2026.

### Nix Flake Bootstrapping (for comparison)

```bash
nix run nix-darwin -- switch --flake github:user/dotfiles#my-macbook
```

Single command to reproduce the entire environment. More reproducible than chezmoi + brew, but
requires Nix on the target machine first.

### Ansible + chezmoi Hybrid

Ansible handles system-level provisioning (users, SSH config, firewall, services), chezmoi
handles user dotfiles and personal tool configuration. A dedicated Ansible role
(`wayofdev/ansible-role-dotfiles`) exists for this pattern.

---

## 6. Secret Management

### Tier 1: 1Password CLI (Zero-Disk-Exposure)

The most popular approach for power users with a 1Password subscription. Secrets are fetched at
`chezmoi apply` time via Go template functions—never written to disk unencrypted.

**Template functions:**

| Function | Description |
|----------|-------------|
| `onepasswordRead "op://vault/item/field"` | Simple field read via op URL |
| `onepassword "$UUID"` | Full item as parsed JSON |
| `onepasswordDetailsFields "$UUID"` | Fields keyed by label |
| `onepasswordItemFields "$UUID"` | Additional item fields |
| `onepasswordDocument "$UUID"` | Retrieve full document |

**Operational modes:**

- **Account Mode** (default)—uses desktop app or biometric auth. With Touch ID, no prompts.
- **Service Account Mode**—for restricted servers; requires `OP_SERVICE_ACCOUNT_TOKEN`. Single
  account only.
- **Connect Mode**—self-hosted 1Password Connect server; requires `OP_CONNECT_HOST` +
  `OP_CONNECT_TOKEN`.

### Tier 2: age Encryption (Local-First, Offline-Capable)

Modern successor to GPG—simple, audited, no key expiry complexity.

```bash
# Generate key (once)
age-keygen -o ~/.config/chezmoi/key.txt

# Configure chezmoi.toml
# [encryption]
#   tool = "age"
# [age]
#   identity = "~/.config/chezmoi/key.txt"
#   recipient = "age1xxxxxx..."

# Encrypt a file
chezmoi add --encrypt ~/.ssh/id_ed25519
```

age supports encryption to SSH public keys (`-R ~/.ssh/id_ed25519.pub`)—useful for
bootstrapping since you only need SSH access to decrypt the age key.

### Tier 3: SOPS (Structured Secret Files)

Best when you need to encrypt specific fields within YAML/JSON while keeping structure visible in
git history:

```yaml
api_key: ENC[AES256_GCM,...]  # encrypted
database_host: localhost        # visible
```

More common in team/infrastructure contexts than purely personal dotfiles.

### Other Tools

| Tool | Best For | Notes |
|------|----------|-------|
| **git-crypt** | Transparent whole-file encryption in git | GPG-only; key rotation is painful |
| **Bitwarden CLI** | Open-source 1Password alternative | Session token friction (`bw unlock` required) |
| **gopass** | Pass-compatible CLI with team support | Well-integrated with chezmoi |
| **HashiCorp Vault** | Enterprise shared secrets, dynamic credentials | Overkill for personal use |
| **Pass / passage** | Unix philosophy password store | passage uses age instead of GPG |
| **direnv + system keyring** | Per-directory env injection | No cross-machine sync |

### Cached Secrets Pattern

For reducing auth friction on headless machines: pre-fetch secrets once and cache to
`.chezmoidata/secrets.yaml` (gitignored):

```bash
# fetch-secrets.sh (run manually when secrets change)
op read "op://vault/item/field" > /tmp/sec
echo "github_token: $(cat /tmp/sec)" > ~/.local/share/chezmoi/.chezmoidata/secrets.yaml
rm /tmp/sec
```

Templates reference `{{ .github_token }}` normally. Zero auth friction on `chezmoi apply`, with a
deliberate refresh step when secrets rotate.

### Security Non-Negotiables

- Never commit plaintext secrets—use pre-commit hooks (gitleaks, truffleHog, git-secrets)
- `.chezmoiignore` key files: `.ssh/id_*`, `.gnupg/`, `key.txt`
- Separate vaults by sensitivity (dev vs production)
- For SSH keys: store in 1Password (has SSH agent support), or encrypt with age

---

## 7. Notable Repos and Patterns

### Reference Repositories

| Repo | Stars | Notable For |
|------|-------|-------------|
| [mathiasbynens/dotfiles](https://github.com/mathiasbynens/dotfiles) | ~31k | macOS defaults script; the gold standard reference |
| [thoughtbot/dotfiles](https://github.com/thoughtbot/dotfiles) | ~8k | rcm-based; well-organized for teams |
| [holman/dotfiles](https://github.com/holman/dotfiles) | ~7k+ | Topical organization pattern; auto-sourcing zsh |
| [twpayne/dotfiles](https://github.com/twpayne/dotfiles) |—| chezmoi author's own dotfiles; reference implementation |

### Architecturally Interesting (2024-2025)

- [basnijholt/dotfiles](https://github.com/basnijholt/dotfiles)—Combines NixOS, nix-darwin,
  Homebrew, dotbot, dotbins across macOS and Linux. Comprehensive multi-tool setup with detailed
  blog post.
- [martinemde/dotfiles](https://github.com/martinemde/dotfiles)—AI-first dotfiles with chezmoi.
  Early example of AI tooling baked into dotfiles architecture.
- [fufexan/dotfiles](https://github.com/fufexan/dotfiles)—NixOS + Home Manager, highly modular.
- [sebastienrousseau/dotfiles](https://github.com/sebastienrousseau/dotfiles)—chezmoi +
  enterprise security focus; macOS + Linux.

### Patterns Worth Studying

**Topical organization** (Zach Holman pattern): Each "topic" (`git/`, `zsh/`, `homebrew/`) is a
directory. Files are auto-loaded by convention rather than explicit inclusion. Scales well.

**dotbins** (basnijholt/dotbins): Manages binary tools in `~/bin` from multiple package managers,
providing cross-platform binary management independent of the OS package manager.

**Config monorepo** (Nix community): A single repo contains home-manager config, nix-darwin/NixOS
system config, Terraform/cloud infrastructure, and Kubernetes configs—treating all personal
infrastructure as code.

**XDG Base Directory compliance**: A clear 2025 trend. Tools like xdg-ninja audit your home
directory for non-compliant dotfiles. Standard directories:

```text
~/.config/       ($XDG_CONFIG_HOME) — configuration files
~/.cache/        ($XDG_CACHE_HOME)  — regeneratable cache
~/.local/share/  ($XDG_DATA_HOME)   — application data
~/.local/state/  ($XDG_STATE_HOME)  — logs, history
```

**AI-assisted dotfile management**: Treating `CLAUDE.md`, `AGENTS.md`, and MCP configs as
first-class dotfile citizens. This repository already does this. Emerging tools like Dotfiles Coach
mine shell history for automation opportunities.

---

## 8. Emerging Trends (2025-2026)

### AI-Integrated Dotfile Management

- **Dotfiles Coach**: CLI tool that mines shell history for repeated patterns and uses AI to
  suggest aliases, functions, and improvements. Includes privacy filters before sending to API.
- **AI agent configs as dotfiles**: `CLAUDE.md`, `AGENTS.md`, MCP server configs, Cursor rules—all
  managed alongside traditional dotfiles. This is a growing practice.
- **Agentic DevOps**: GitHub Copilot Agent Mode can handle infrastructure config tasks, suggest
  terminal commands, and self-heal errors.

### Dev Containers as Complementary Layer

The "Development Environment as Code" (DEaaC) paradigm is mainstream:

- **Dev container** = project scope (language runtimes, tools)
- **Dotfiles** = user scope (shell, editor, aliases)

GitHub Codespaces, JetBrains Remote Development, and VS Code Remote all support this. Dotfiles
complement dev containers—they don't replace them.

### Nix Momentum

Growing significantly, especially among r/unixporn and NixOS devotees. nix-darwin has matured,
Home Manager has stable flakes support. However, there's a visible counter-trend of experienced
users migrating away from Nix back to chezmoi + Homebrew, citing maintenance burden. The
community consensus: Nix and chezmoi serve different niches and can coexist.

### Team/Enterprise Dotfiles

Emerging patterns:

- **Base + override model**: Shared org-level dotfiles repo that individuals fork and layer
  personal preferences on top of.
- **Profile system** (which this repository already has) is the right model for this.
- Some companies maintain internal dotfiles templates via scaffolding tools.

### Rust-Based Alternatives (Emerging)

The Rust ecosystem is producing interesting tools (Tuckr, rotz, dotter, comtrya) but none have
reached chezmoi's maturity or community size. Worth watching Tuckr specifically as a modern
GNU Stow replacement.

### Community Sentiment Shifts

- Multiple "Migrating from Nix/Home Manager to chezmoi + Homebrew" posts
- mackup users migrating away due to macOS Sonoma breakage
- Bare git repo approach maintains a loyal minimalist following
- "Setting up dotfiles for AI-assisted development" is an emerging blog genre

---

## 9. Opportunities for This Setup

Concrete improvements identified during research, cataloged for future consideration:

### Low Effort, High Value

- **`chezmoi archive` for remote servers**—Push dotfiles to any SSH-accessible machine without
  installing chezmoi on it
- **`$CODESPACES` guard**—Add conditional in templates to skip heavy installs in container
  environments
- **Pre-commit secret leak detection**—Already in place via lefthook + gitleaks; verify
  configuration is current

### Medium Effort, High Value

- **age encryption layer**—For sensitive files not managed by 1Password (useful for headless
  servers where 1Password isn't available)
- **Cached secrets pattern**—Pre-fetch 1Password secrets to a gitignored YAML file for
  friction-free `chezmoi apply` on headless machines
- **cloud-init template**—A cloud-config YAML template for bootstrapping VPS instances

### Medium Effort, Medium Value

- **xdg-ninja audit**—Run xdg-ninja to identify non-XDG-compliant configs and clean up the
  home directory
- **Dev container dotfiles integration**—Add `install.sh` and `$CODESPACES` detection for
  GitHub Codespaces / dev container support

---

## 10. Sources

### Tool Landscape

- [chezmoi GitHub](https://github.com/twpayne/chezmoi)
- [chezmoi comparison table](https://www.chezmoi.io/comparison-table/)
- [chezmoi release history](https://www.chezmoi.io/reference/release-history/)
- [Why use chezmoi?](https://www.chezmoi.io/why-use-chezmoi/)
- [yadm official site](https://yadm.io/)
- [GNU Stow explanation](https://rickcogley.github.io/dotfiles/explanations/gnu-stow.html)
- [Exploring Dotfile Tools - GBergatto](https://gbergatto.github.io/posts/tools-managing-dotfiles/)
- [Dotfile Tools Comparison - BigGo](https://biggo.com/news/202412191324_dotfile-management-tools-comparison)
- [rcm - thoughtbot GitHub](https://github.com/thoughtbot/rcm)
- [mackup GitHub](https://github.com/lra/mackup)
- [dotter GitHub](https://github.com/SuperCuber/dotter)
- [rotz GitHub](https://github.com/volllly/rotz)
- [toml-bombadil](https://oknozor.github.io/toml-bombadil/)
- [comtrya GitHub](https://github.com/comtrya)
- [Tuckr GitHub](https://github.com/RaphGL/Tuckr)
- [DotState](https://dotstate.serkan.dev)
- [Atlassian bare git tutorial](https://www.atlassian.com/git/tutorials/dotfiles)
- [awesome-dotfiles](https://github.com/webpro/awesome-dotfiles)
- [dotfiles.github.io](https://dotfiles.github.io/)

### Nix Ecosystem

- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [home-manager GitHub](https://github.com/nix-community/home-manager)
- [Managing dotfiles on macOS with Nix - Davis Haupt](https://davi.sh/blog/2024/02/nix-home-manager/)
- [Set up Nix on macOS using flakes](https://noghartt.dev/blog/set-up-nix-on-macos-using-flakes-nix-darwin-and-home-manager/)
- [Introduction to Flakes - NixOS & Flakes Book](https://nixos-and-flakes.thiscute.world/nixos-with-flakes/introduction-to-flakes)
- [Determinate Nix documentation](https://docs.determinate.systems/determinate-nix/)
- [Migrating From Nix and Home Manager to Homebrew and Chezmoi](https://htdocs.dev/posts/migrating-from-nix-and-home-manager-to-homebrew-and-chezmoi/)
- [Why We're Moving on From Nix - Railway](https://blog.railway.com/p/introducing-railpack)
- [Nix - Death by a Thousand Cuts (2025)](https://www.dgt.is/blog/2025-01-10-nix-death-by-a-thousand-cuts/)
- [Is Nix/NixOS dying? - NixOS Discourse](https://discourse.nixos.org/t/is-nix-nixos-dying/72316)
- [Nix governance crisis - LWN](https://lwn.net/Articles/970824/)
- [Homebrew vs Nix - Better Stack](https://betterstack.com/community/guides/linux/homebrew-vs-nix/)
- [Zero to Nix](https://zero-to-nix.com/)
- [Declarative macOS with nix-darwin](https://carlosvaz.com/posts/declarative-macos-management-with-nix-darwin-and-home-manager/)
- [Nix-Darwin - Dreams of Code](https://dreamsofcode.io/blog/nix-darwin-my-favorite-package-manager-for-macos)

### Bootstrapping and Secrets

- [chezmoi Install Script](https://www.chezmoi.io/install/)
- [chezmoi Scripts Guide](https://www.chezmoi.io/user-guide/use-scripts-to-perform-actions/)
- [chezmoi Declarative Package Install](https://www.chezmoi.io/user-guide/advanced/install-packages-declaratively/)
- [chezmoi Containers and VMs](https://www.chezmoi.io/user-guide/machines/containers-and-vms/)
- [chezmoi 1Password Integration](https://www.chezmoi.io/user-guide/password-managers/1password/)
- [chezmoi age Encryption](https://www.chezmoi.io/user-guide/encryption/age/)
- [Dotfiles Secrets in Chezmoi - Mike Kasberg (Jan 2026)](https://www.mikekasberg.com/blog/2026/01/31/dotfiles-secrets-in-chezmoi.html)
- [SOPS - getsops.io](https://getsops.io/)
- [sops-nix GitHub](https://github.com/Mic92/sops-nix)
- [agenix GitHub](https://github.com/ryantm/agenix)
- [Secret Management Best Practices - dotfiles.io](https://dotfiles.io/en/guides/secret-management/)
- [Sync Claude Code with chezmoi and age](https://www.arun.blog/sync-claude-code-with-chezmoi-and-age/)
- [ansible-role-dotfiles GitHub](https://github.com/wayofdev/ansible-role-dotfiles)

### Community and Trends

- [Personalizing GitHub Codespaces](https://docs.github.com/en/codespaces/setting-your-user-preferences/personalizing-github-codespaces-for-your-account)
- [My 2025 Dotfiles - NixOS Discourse](https://discourse.nixos.org/t/my-2025-dotfiles-home-manager-nix-darwin-nixos-terraform-kubernetes-on-vms/73690)
- [Open-sourcing my dotfiles - Bas Nijholt](https://www.nijho.lt/post/dotfiles/)
- [Dotfiles Coach CLI - DEV Community](https://dev.to/olaproeis/dotfiles-coach-your-shell-history-is-full-of-automation-gold-you-just-dont-know-it-yet-4g52)
- [XDG Base Directory - ArchWiki](https://wiki.archlinux.org/title/XDG_Base_Directory)
- [Switching from Mackup to Stow - Josh Medeski](https://www.joshmedeski.com/posts/moving-from-mackup-to-stow/)
- [Dotfiles for AI-Assisted Development - Substack](https://engineersmeetai.substack.com/p/a-practical-guide-to-ai-dotfiles)
