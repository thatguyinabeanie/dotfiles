---
name: require-shell-function-counterpart
enabled: true
event: file
action: warn
conditions:
  - field: file_path
    operator: regex_match
    pattern: dot_config/(zsh/aliases\.zsh\.tmpl|fish/functions/[^/]+\.fish)
---

🔁 **Shell function edit: the counterpart file needs the same change.**

Shell functions in this repo must exist in **both** shells, at parity. You just edited
one side of a pair:

| Shell | File |
| ----- | ---- |
| zsh   | `dot_config/zsh/aliases.zsh.tmpl` |
| fish  | `dot_config/fish/functions/<name>.fish` |

**Before finishing, confirm:**

- The counterpart file has the equivalent change.
- User-facing messages and emoji are **byte-identical** between the two.
- Behavior matches for every input, including error and edge cases. zsh and fish differ
  most on argument parsing, quoting, list expansion, empty variables, and exit-status
  propagation, so those are where divergence hides.

**Verify parity mechanically rather than by eye:**

```sh
# compare the message strings of both implementations
diff <(grep -oE 'echo "[^"]*"' dot_config/zsh/aliases.zsh.tmpl | sort -u) \
     <(grep -oE 'echo "[^"]*"' dot_config/fish/functions/<name>.fish | sort -u)
```

Also parse-check both: `zsh -n` on the rendered file, `fish --no-execute` on the fish file.

**Exceptions that are fine:**

- A one-sided edit that is genuinely shell-specific, such as working around a fish-only
  syntax issue, where the observable behavior stays identical.
- Simple one-line aliases, which belong in `.chezmoidata/aliases.yaml` instead. That
  already generates both shells from one definition.

Do not resolve this by refactoring the pair into a shared POSIX `sh` core with thin
per-shell `cd` wrappers. That was considered and deliberately rejected; the duplication
is intentional. See the "Shell Functions" section of `AGENTS.md`.
