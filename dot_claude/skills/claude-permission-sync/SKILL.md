---
name: claude-permission-sync
description: Use when adding, auditing, pruning, or syncing Claude Code permission rules, hooks, or autoMode settings, or when permission rules, hooks, or autoMode edits disappear after a chezmoi apply. Covers the chezmoi-managed settings pipeline, the drift workflow, and which rule patterns are unsafe to allowlist.
---

# Claude Code Permission Sync

`permissions.allow`, `permissions.deny`, `permissions.ask`, `hooks`, and `autoMode` in
`~/.claude/settings.json` are generated from the chezmoi source tree. Editing the live file
directly works only until the next `chezmoi apply`, which overwrites all five.

## The pipeline

| Piece | Path | Role |
|---|---|---|
| Source of truth | `.chezmoidata/claude.yaml` (`claude_permissions.allow` / `.deny` / `.ask`, `claude_settings.hooks` / `.autoMode`) | The only place edits persist |
| Merge script | `dot_claude/modify_settings.json` | chezmoi `modify_` script; rewrites only the managed keys |
| Drift check | One-liner under "Recovering drift" below | Shows every live change the next apply would drop |

**Managed keys:** `permissions.allow`, `permissions.deny`, `permissions.ask`, `hooks`, and
`autoMode`. The permissions lists are merged into the existing `permissions` object. `hooks`
and `autoMode` come from `claude_settings` in the same YAML file and are **replaced
wholesale** on apply, so a hook or autoMode line added only to the live file is lost.

These pass through untouched, so Claude Code stays free to write them at runtime:

- Permission siblings: `defaultMode`, `disableAutoMode`, `disableBypassPermissionsMode`,
  `additionalDirectories`
- Everything else top-level: `theme`, `model`, `modelSettings`, `effortLevel`, `editorMode`,
  `outputStyle`, `enabledPlugins`, `extraKnownMarketplaces`, `mcpServers`, `statusLine`,
  `worktree`, and the notification/toggle keys

The script is a `modify_` script, so chezmoi pipes the current target in via
`.chezmoi.stdin` and takes stdout as the new state. Its filename must **not** end in
`.tmpl`. The `chezmoi:modify-template` directive on line 1 is what makes it a template.
All five source keys (`claude_permissions.allow` / `.deny` / `.ask`, `claude_settings.hooks` /
`.autoMode`) are required: deleting one makes apply fail with `map has no entry`.

## Adding a rule

1. Add it to `claude_permissions.allow` in `.chezmoidata/claude.yaml` (keep sorted).
2. `chezmoi diff ~/.claude/settings.json` to review.
3. `chezmoi apply ~/.claude/settings.json`.

## Changing hooks or autoMode

1. Edit `claude_settings` (`hooks` or `autoMode`) in `.chezmoidata/claude.yaml`. Do not use
   `/hooks` or the `update-config` skill on the live file: the next apply reverts it.
2. `chezmoi diff ~/.claude/settings.json` to review.
3. `chezmoi apply ~/.claude/settings.json`.

## Recovering drift

Claude Code appends newly approved rules straight into the live file, and `chezmoi apply`
drops anything absent from source. To see what would be lost, diff the live file against
what apply would write:

```sh
diff <(jq -S . ~/.claude/settings.json) <(chezmoi cat ~/.claude/settings.json | jq -S .)
```

Empty output means the next apply changes nothing. Lines starting with `<` exist only in the
live file and will be lost on apply. Lines starting with `>` are what apply will write. The
check compares every key, so it covers hooks and autoMode as well as allow, deny, and ask,
and `jq -S` removes key-order noise.

Promote the worthwhile `<` lines into `.chezmoidata/claude.yaml` **by hand**. Do not bulk-import:
auto-recorded rules are mostly single-use exact matches (one-off scratchpad paths, abandoned
test harnesses), which is how the list previously reached 159 entries in one project alone.

## Inclusion standard

Prefix rules do **no flag-level analysis**, so `Bash(foo *)` must be safe for *any* arguments.

**Safe to allowlist:** report-only invocations. Exact no-argument `chezmoi diff/verify/doctor/data/managed`
(plus `chezmoi diff|cat ~/.claude/settings.json`, with no trailing glob),
`mise ls/current/tasks/where`, `gh pr view/list`, `gh run view`, `gh issue list`,
`shellcheck *`, `vale *`, `yamllint *`, `stylua --check *`, `command -v <tool>`.

**Never allowlist:**

| Pattern | Why |
|---|---|
| `npx *`, `mise exec/run`, `docker exec` | Env runners pass arguments through, so `devbox run rm -rf .` matches |
| `git fetch/pull` | `--upload-pack=<cmd>` and `ext::` remotes execute arbitrary commands |
| `gh api *` | A prefix rule cannot express GET-only; matches POST/DELETE and mutations |
| `git *`, `git -c *` | `-c core.pager=<cmd>` makes git run a program you name |
| `npm run *`, `make *` | Runs whatever the repo's scripts define |
| `Bash(* --version)`, `Bash(* --help*)` | The `*` stands in for the *program*, so anything matches |
| `curl *`, `wget *` | Can POST and exfiltrate; prefer `WebFetch(domain:...)` |
| `python3 *`, `zsh -c ' *`, `ruby *` | Arbitrary code execution |
| `env`, `mise env`, `mise hook-env` | Print every secret in the environment |
| `cat *`, `xxd`, `gofmt` | Read past the `Read` deny rules |
| `git grep` | `-O<cmd>` runs a program |
| `zsh -n *` | `-n` then `+n` re-enables execution |
| `go vet *`, `diffstat` | `-vettool=<prog>` runs a program; `-o FILE` writes any file |
| `chezmoi <cmd> *` | `--config` (hooks), `--pager`, and `--source` (templates) execute programs |

Bare read-only commands (`ls`, `cat`, `grep`, `find`, `git status`, `git log`) are
auto-allowed and never prompt, so they need no entry.

A Bash rule is not a security boundary: `Bash(rm *)` in `deny` does not stop `/bin/rm` or
`bash -c 'rm ...'`. Use sandboxing or a `PreToolUse` hook when it must actually hold.

## Hazard: never Bash-edit a settings file

Claude Code rewrites `.claude/settings.local.json` **concurrently during a live session**
with a non-atomic read-modify-write as it records newly approved rules. A shell
`jq ... > tmp && mv tmp file` races it and loses data. This destroyed a 156-entry allow
list on 2026-09-16, unrecoverable because `**/settings.local.json` is gitignored.

Use the Read tool, then Edit or Write. Reads via `jq` are safe; only writes race. A
`jq` error like `cannot calculate {...} * null` means you caught the file mid-write.

## Verification

```sh
chezmoi cat ~/.claude/settings.json | jq '.permissions | keys'        # siblings survived?
chezmoi cat ~/.claude/settings.json | jq '.permissions.allow|length'
chezmoi diff ~/.claude/settings.json
```

To prove no rule was dropped, set-compare rather than reading the diff (the source list is
sorted, so the textual diff looks total even when content is equivalent):

```sh
comm -23 <(jq -r '.permissions.allow[]' ~/.claude/settings.json | sort -u) \
         <(chezmoi cat ~/.claude/settings.json | jq -r '.permissions.allow[]' | sort -u)
# empty output = nothing lost
```
