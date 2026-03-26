# Simplified Installation Output

**Date:** 2026-03-26
**Scope:** All `.chezmoiscripts/` installation scripts

## Goal

Replace verbose, noisy installation output with a consistent minimal pattern
across all scripts: show the section header always, show only new installs as
`✓ package` / `✗ package`, show nothing for already-installed packages.

## Target Output

**When nothing to install:**

```text
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📦 Homebrew Casks (GUI Applications)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✓ All 44 casks up to date
```

**When installs happen:**

```text
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📦 Homebrew Casks (GUI Applications)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ✓ grandperspective
  ✗ some-failed-package
```

**On error:** dump full captured output for debugging.

**Removed from all scripts:**

- Pre-listing of all packages before install
- "Collecting..." / "Installing N packages..." step messages
- "already installed" / "CACHED" lines
- Streaming timestamps from brew bundle
- Inner `━━━` separators inside `install_brew_packages()`
- Summary count blocks at the end

## Consistent Rules

1. Always open with `log_section "emoji Title"`—provides the ━━━ separator
2. Pre-check which packages need installation before running the installer
3. If nothing to install, use
   `log_summary "✓ All N <type> up to date"`—done
4. If installs needed, run installer quietly (suppress stdout/stderr to log
   file) and emit `✓ pkg` or `✗ pkg` per package
5. If installer fails, print captured output to stderr for debugging
6. Scripts that currently use raw `echo` must include
   `{{ template "utilities/logging.sh.tmpl" }}` for consistent formatting

## Per-Script Changes

### brew-casks (`run_onchange_before-02-install-brew-casks.sh.tmpl`)

**Current:** Streams full `brew bundle --verbose` output with timestamps;
lists all 44 packages upfront; shows every CACHED event; has inner separators
and a summary count block.

**New approach:**

1. Build Brewfile from YAML data (same as now)
2. Run `brew bundle check --verbose --file=$brewfile` to identify missing
   casks; parse output for lines matching
   `"The Cask '(.+)' is not installed."`—collect `MISSING_CASKS` array
3. If `MISSING_CASKS` is empty, use
   `log_summary "✓ All $total casks up to date"`—exit 0
4. Run `brew bundle install --quiet --file=$brewfile >> "$LOG_FILE" 2>&1`
5. For each cask in `MISSING_CASKS`: check
   `brew list --cask "$cask" >/dev/null 2>&1` and emit `✓ $cask` or
   `✗ $cask`
6. On non-zero exit from install: also dump `$LOG_FILE` to stderr
7. Remove: `install_brew_packages()` function, inner separators,
   `log_step`, `log_substep` package listing, summary block

### brew-formulae (`run_onchange_before-01-install-brew-formulae.sh.tmpl`)

**Current:** Mostly silent in non-verbose mode but still emits `log_step`
noise ("Installing taps," "Collecting brew formulae," "Setting up
autoupdate") and a useless category-count summary block.

**New approach:**

1. Same pre-check pattern as casks using `brew bundle check --verbose`
2. Taps + formulae handled together in a single Brewfile (or sequentially
   with same pattern)
3. Autoupdate setup: keep but emit only on first-time configure (already
   guarded), move to `log_detail` if already configured—currently uses
   `log_debug` which is correct; just remove the `log_step` wrapper
4. Remove: all `log_step` calls, the category-count summary block

### mise (`run_onchange_after_100-mise-install-packages.sh.tmpl`)

**Current:** Raw `echo`, no logging utility. Runs `mise install`
unconditionally. Shows "Verifying critical runtimes" section.

**New approach:**

1. Add `{{ template "utilities/logging.sh.tmpl" }}`
2. `log_section "🔧 Mise Tools"`
3. Run `mise ls --missing 2>/dev/null` to get list of tools needing
   installation
4. If empty, use
   `log_summary "✓ All mise tools up to date"`—exit 0
5. Run `mise install >> "$LOG_FILE" 2>&1`
6. For each tool that was missing: re-check `mise which $tool` and emit
   `✓ $tool` or `✗ $tool`
7. Remove: critical runtimes verification section (move to
   `log_detail` / verbose only)

### cargo (`run_onchange_after_110-cargo-packages.sh.tmpl`)

**Current:** Has `log_section` header and good pre-check logic
(`cargo install --list`). Uses `show_progress` progress bar and counts all
installed (including cached) in final summary.

**New approach:**

1. Keep the `log_section` header and pre-check logic
2. Replace `show_progress` + `log_detail` per-package messages with
   `✓ $pkg` / `✗ $pkg` (only for packages that were missing)
3. Remove `show_progress` / `clear_progress` calls
4. Remove final
   `log_summary "Cargo packages: $installed installed, 0 failed"`—the
   per-package checkmarks are sufficient
5. cargo-binstall prerequisite check stays as `log_detail` (verbose only)

### npm (`run_onchange_after_120-npm-packages.sh.tmpl`)

**Current:** Has `log_section` header and pre-check. Final `log_summary`
shows aggregate count, not per-package result. Fallback individual install
loop already uses `show_progress`.

**New approach:**

1. Keep pre-check loop (`npm list -g $pkg`)
2. On bulk install success: emit `✓ $pkg` for each package in
   `PACKAGES_TO_INSTALL`
3. On bulk install failure: fall back to individual installs with
   `✓ $pkg` / `✗ $pkg`
4. Remove aggregate `log_summary` counts; remove `show_progress`

### pip (`run_onchange_after_130-pip-packages.sh.tmpl`)

**Current:** Raw `echo`, no logging utility, no pre-check before bulk
install. Shows "Installing N pip packages" and all package output.

**New approach:**

1. Add `{{ template "utilities/logging.sh.tmpl" }}`
2. `log_section "🐍 Python pip Packages"`
3. Pre-check: for each package,
   `pip show "$pkg" >/dev/null 2>&1`—split into `MISSING` /
   already-installed
4. If nothing missing, use
   `log_summary "✓ All N pip packages up to date"`—exit 0
5. Bulk install missing packages quietly; emit `✓ $pkg` / `✗ $pkg`
   per package
6. On failure: dump captured output

### go (`run_onchange_after_140-go-packages.sh.tmpl`)

**Current:** Raw `echo`, no logging utility, no pre-check. Runs `go install`
for every package unconditionally.

**New approach:**

1. Add `{{ template "utilities/logging.sh.tmpl" }}`
2. `log_section "🐹 Go Packages"`
3. Pre-check: for each package, extract binary name and check
   `command -v $binary >/dev/null 2>&1` (using
   `$(go env GOPATH)/bin`)—collect `MISSING`
4. If nothing missing, use
   `log_summary "✓ All N go packages up to date"`—exit 0
5. For each missing package:
   `go install "$pkg" >> "$LOG_FILE" 2>&1` and emit `✓ $pkg` / `✗ $pkg`

### gem (`run_onchange_after_150-gem-packages.sh.tmpl`)

**Current:** Raw `echo`, has per-package check (`gem list -i`). Shows
"Installing $package..." for each and "$package already installed."
for cached.

**New approach:**

1. Add `{{ template "utilities/logging.sh.tmpl" }}`
2. `log_section "💎 Ruby Gem Packages"`
3. Keep `gem list -i` pre-check; collect `MISSING`
4. If nothing missing, use
   `log_summary "✓ All N gem packages up to date"`—exit 0
5. For each missing package: install quietly and emit
   `✓ $pkg` / `✗ $pkg`
6. Remove "already installed" echo, "Installing $package..." echo

### bun (`run_onchange_after_160-bun-packages.sh.tmpl`)

**Current:** Raw `echo`, has per-package check (`bun pm ls -g`). Shows
"Installing $package..." and "$package already installed." for cached.

**New approach:**

1. Add `{{ template "utilities/logging.sh.tmpl" }}`
2. `log_section "🍞 Bun Packages"`
3. Keep `bun pm ls -g` pre-check; collect `MISSING`
4. If nothing missing, use
   `log_summary "✓ All N bun packages up to date"`—exit 0
5. For each missing package: install quietly and emit
   `✓ $pkg` / `✗ $pkg`
6. Remove "already installed" echo, "Installing $package..." echo

## Shared Utility: `log_install_result`

To keep per-package reporting DRY, add a helper to
`utilities/logging.sh.tmpl`:

```bash
log_install_result() {
    local status="$1"   # "ok" or "fail"
    local name="$2"
    if [[ "$status" == "ok" ]]; then
        echo "  ✓ $name"
    else
        echo "  ✗ $name"
    fi
}
```

## Error Handling

All scripts already set `set -euo pipefail`. Installer output is redirected
to `$LOG_FILE`. On non-zero exit:

1. Emit `✗ $pkg` for each package in the missing list that is still not
   installed
2. Print `cat "$LOG_FILE"` to stderr for debugging context

## Validation

After each script change:

- `chezmoi apply --dry-run`—confirm template renders cleanly
- `chezmoi apply --force`—run on live system
- Verify output matches target format above
- Verify idempotency: run `chezmoi apply` again and confirm "up to date"
  path is taken
