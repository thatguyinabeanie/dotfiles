---
name: claude-permission-sync
description: Use when adding, auditing, pruning, or syncing Claude Code permission rules, or when permission rules disappear after a chezmoi apply. Covers the chezmoi-managed permissions pipeline, the drift workflow, and which rule patterns are unsafe to allowlist.
---

# Claude Code Permission Sync

`permissions.allow` and `permissions.deny` in `~/.claude/settings.json` are generated from
the chezmoi source tree. Editing the live file directly works only until the next
`chezmoi apply`, which overwrites both lists.

## The pipeline

| Piece | Path | Role |
|---|---|---|
| Source of truth | `.chezmoidata/claude.yaml` (`claude_permissions.allow` / `.deny`) | The only place edits persist |
| Merge script | `dot_claude/modify_settings.json` | chezmoi `modify_` script; rewrites only these two keys |
| Drift report | `mise run claude-perms-drift` | Lists live rules missing from source |

**Only `allow` and `deny` are managed.** These pass through untouched, so Claude Code stays
free to write them at runtime:

- Permission siblings: `defaultMode`, `disableAutoMode`, `disableBypassPermissionsMode`, `ask`
- Everything else top-level: `theme`, `model`, `modelSettings`, `effortLevel`, `editorMode`,
  `outputStyle`, `enabledPlugins`, `extraKnownMarketplaces`, `hooks`, `mcpServers`,
  `statusLine`, `worktree`, and the notification/toggle keys

The script is a `modify_` script, so chezmoi pipes the current target in via
`.chezmoi.stdin` and takes stdout as the new state. Its filename must **not** end in
`.tmpl`. The `chezmoi:modify-template` directive on line 1 is what makes it a template.

## Adding a rule

1. Add it to `claude_permissions.allow` in `.chezmoidata/claude.yaml` (keep sorted).
2. `chezmoi diff ~/.claude/settings.json` to review.
3. `chezmoi apply`.

## Recovering drift

Claude Code appends newly approved rules straight into the live file, and `chezmoi apply`
drops anything absent from source. To reconcile:

```sh
mise run claude-perms-drift          # rules live but not in source (lost on next apply)
```

Promote the worthwhile ones into `.chezmoidata/claude.yaml` **by hand**. Do not bulk-import:
auto-recorded rules are mostly single-use exact matches (one-off scratchpad paths, abandoned
test harnesses), which is how the list previously reached 159 entries in one project alone.

## Inclusion standard

Prefix rules do **no flag-level analysis**, so `Bash(foo *)` must be safe for *any* arguments.

**Safe to allowlist:** report-only invocations. `chezmoi diff/verify/doctor/data/managed`,
`mise ls/current/tasks/where`, `gh pr view/list`, `gh run view`, `gh issue list`,
`shellcheck *`, `vale *`, `yamllint *`, `stylua --check *`, `gofmt -l *`, `go vet *`,
`zsh -n *`, `fish --no-execute *`, `command -v <tool>`.

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
| `python3 *`, `zsh -c ' *`, `fish -c ' *`, `ruby *` | Arbitrary code execution |

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
