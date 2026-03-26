# Simplified Installation Output Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace verbose, streaming installation output across all `.chezmoiscripts/` installer scripts with a consistent minimal pattern: ━━━ section header always, `✓ pkg` / `✗ pkg` for new installs only, nothing for already-installed packages.

**Architecture:** Add a shared `log_install_result` helper to the logging utility, then update each script to (1) pre-check what needs installing, (2) exit early with "up to date" if nothing, (3) run installer quietly, (4) emit per-package ✓/✗ result. Scripts lacking the logging utility get it added.

**Tech Stack:** Bash, chezmoi templates (Go template syntax), `brew bundle`, `mise`, `cargo`, `npm`, `pip`, `go install`, `gem`, `bun`

---

## File Map

| File | Change |
|---|---|
| `.chezmoitemplates/utilities/logging.sh.tmpl` | Add `log_install_result` helper |
| `.chezmoiscripts/macos/run_onchange_before-02-install-brew-casks.sh.tmpl` | Full rewrite: pre-check + quiet install |
| `.chezmoiscripts/macos/run_onchange_before-01-install-brew-formulae.sh.tmpl` | Simplify: same pre-check pattern, remove step/summary noise |
| `.chezmoiscripts/mise/run_onchange_after_100-mise-install-packages.sh.tmpl` | Add logging, `mise ls --missing` pre-check |
| `.chezmoiscripts/mise/run_onchange_after_110-cargo-packages.sh.tmpl` | Replace `show_progress` with ✓/✗, remove summary |
| `.chezmoiscripts/mise/run_onchange_after_120-npm-packages.sh.tmpl` | Emit per-package ✓/✗, remove aggregate summary |
| `.chezmoiscripts/mise/run_onchange_after_130-pip-packages.sh.tmpl` | Add logging, add `pip show` pre-check |
| `.chezmoiscripts/mise/run_onchange_after_140-go-packages.sh.tmpl` | Add logging, add binary pre-check |
| `.chezmoiscripts/mise/run_onchange_after_150-gem-packages.sh.tmpl` | Add logging, remove "already installed" lines |
| `.chezmoiscripts/mise/run_onchange_after_160-bun-packages.sh.tmpl` | Add logging, remove "already installed" lines |

---

## Task 1: Add `log_install_result` to shared logging utility

**Files:**
- Modify: `.chezmoitemplates/utilities/logging.sh.tmpl`

- [ ] **Step 1: Read the current logging utility**

  Open `.chezmoitemplates/utilities/logging.sh.tmpl` and locate the end of the exported functions block (the `export -f` lines at the bottom).

- [ ] **Step 2: Add the helper function and export**

  Add before the final `export -f` lines:

  ```bash
  # Emit ✓ or ✗ for a single package install result
  log_install_result() {
      local status="$1"   # "ok" or "fail"
      local name="$2"
      if [[ "$status" == "ok" ]]; then
          echo "  ✓ $name"
      else
          echo "  ✗ $name"
      fi
      log_to_file "${status}: $name"
  }
  ```

  Also add `export -f log_install_result` to the export block at the bottom.

- [ ] **Step 3: Validate template syntax**

  ```bash
  chezmoi apply --dry-run
  ```

  Expected: no template errors, dry-run completes.

- [ ] **Step 4: Commit**

  ```bash
  git add .chezmoitemplates/utilities/logging.sh.tmpl
  git commit -m "feat: add log_install_result helper to logging utility"
  ```

---

## Task 2: Rewrite brew-casks script

**Files:**
- Modify: `.chezmoiscripts/macos/run_onchange_before-02-install-brew-casks.sh.tmpl`

- [ ] **Step 1: Replace the script with the simplified version**

  Replace the entire file content with:

  ```bash
  #!/bin/bash

  # Homebrew Casks (GUI Applications) Installation Script
  # run_onchange: {{ template "queries/brew-casks.tmpl" . }}

  {{ template "utilities/error-handling.sh" }}
  {{ template "utilities/logging.sh.tmpl" }}
  {{ template "utilities/env-helpers.sh.tmpl" }}

  {{ if eq .chezmoi.os "darwin" -}}

  log_section "📦 Homebrew Casks (GUI Applications)"

  {{- template "brew/ensure-brew.sh.tmpl" }}

  # Build Brewfile
  brewfile=$(mktemp)
  trap 'rm -f "$brewfile"' EXIT

  # Development tools that install via brew_cask
  {{- range .dev_tools }}
    {{- if has "brew_cask" .installer }}
  echo "cask \"{{ .name }}\"" >> "$brewfile"
    {{- end }}
  {{- end }}

  # AI agents that install via brew_cask
  {{- range .agents }}
    {{- if has "brew_cask" .installer }}
  echo "cask \"{{ .name }}\"" >> "$brewfile"
    {{- end }}
  {{- end }}

  # General applications that install via brew_cask
  {{- if .applications.shared }}
    {{- range .applications.shared }}
      {{- if has "brew_cask" .installer }}
  echo "cask \"{{ .name }}\"" >> "$brewfile"
      {{- end }}
    {{- end }}
  {{- end }}

  if is_personal_environment; then
    {{- if .applications.personal }}
      {{- range .applications.personal }}
        {{- if has "brew_cask" .installer }}
  echo "cask \"{{ .name }}\"" >> "$brewfile"
        {{- end }}
      {{- end }}
    {{- end }}
  fi

  if is_work_environment; then
    {{- if .applications.work }}
      {{- range .applications.work }}
        {{- if has "brew_cask" .installer }}
  echo "cask \"{{ .name }}\"" >> "$brewfile"
        {{- end }}
      {{- end }}
    {{- end }}
  fi

  total=$(grep -c "^cask" "$brewfile" 2>/dev/null || echo "0")

  # Pre-check: identify missing casks
  MISSING_CASKS=()
  check_output=$(brew bundle check --verbose --file="$brewfile" 2>&1 || true)
  while IFS= read -r line; do
      if [[ "$line" == *"is not installed"* ]]; then
          cask_name=$(echo "$line" | sed "s/.*'\([^']*\)'.*/\1/")
          [[ -n "$cask_name" ]] && MISSING_CASKS+=("$cask_name")
      fi
  done <<< "$check_output"

  if [[ ${#MISSING_CASKS[@]} -eq 0 ]]; then
      log_summary "✓ All $total casks up to date"
  else
      brew bundle install --quiet --file="$brewfile" >> "$LOG_FILE" 2>&1
      install_exit=$?

      for cask in "${MISSING_CASKS[@]}"; do
          if brew list --cask "$cask" >/dev/null 2>&1; then
              log_install_result "ok" "$cask"
          else
              log_install_result "fail" "$cask"
          fi
      done

      if [[ $install_exit -ne 0 ]]; then
          log_error "Some casks failed to install. See $LOG_FILE for details."
          cat "$LOG_FILE" >&2
      fi
  fi
  ```

- [ ] **Step 2: Validate template syntax**

  ```bash
  chezmoi apply --dry-run
  ```

  Expected: no template errors.

- [ ] **Step 3: Apply and verify output**

  ```bash
  chezmoi apply --force
  ```

  Expected output (all installed):
  ```
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  📦 Homebrew Casks (GUI Applications)
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ✓ All 44 casks up to date
  ```

  No timestamps, no CACHED lines, no package list, no summary block.

- [ ] **Step 4: Commit**

  ```bash
  git add .chezmoiscripts/macos/run_onchange_before-02-install-brew-casks.sh.tmpl
  git commit -m "refactor: simplify brew-casks output to pre-check + quiet install"
  ```

---

## Task 3: Simplify brew-formulae script

**Files:**
- Modify: `.chezmoiscripts/macos/run_onchange_before-01-install-brew-formulae.sh.tmpl`

- [ ] **Step 1: Replace the `install_brew_packages` function**

  The function currently either streams (verbose) or shows aggregate counts. Replace it with the pre-check + quiet install pattern:

  ```bash
  # Install brew packages using pre-check + quiet install pattern
  # Args: $1 = label (e.g. "taps", "formulae"), $2 = brewfile path, $3 = entry_type (tap|brew)
  install_brew_packages() {
      local label="$1"
      local brewfile="$2"
      local entry_type="${3:-brew}"

      local total
      total=$(grep -c "^${entry_type}" "$brewfile" 2>/dev/null || echo "0")

      # Pre-check
      local MISSING=()
      local check_output
      check_output=$(brew bundle check --verbose --file="$brewfile" 2>&1 || true)
      while IFS= read -r line; do
          if [[ "$line" == *"is not installed"* ]] || [[ "$line" == *"is not tapped"* ]]; then
              local name
              name=$(echo "$line" | sed "s/.*'\([^']*\)'.*/\1/")
              [[ -n "$name" ]] && MISSING+=("$name")
          fi
      done <<< "$check_output"

      if [[ ${#MISSING[@]} -eq 0 ]]; then
          log_summary "✓ All $total $label up to date"
          return 0
      fi

      brew bundle install --quiet --file="$brewfile" >> "$LOG_FILE" 2>&1
      local exit_code=$?

      for name in "${MISSING[@]}"; do
          if brew list "$name" >/dev/null 2>&1 || brew tap | grep -q "^$name$"; then
              log_install_result "ok" "$name"
          else
              log_install_result "fail" "$name"
          fi
      done

      if [[ $exit_code -ne 0 ]]; then
          log_error "Some $label failed to install. See $LOG_FILE for details."
      fi
  }
  ```

- [ ] **Step 2: Update the taps section**

  Replace:
  ```bash
  # Install taps first
  log_step "Installing Homebrew taps"
  TAPS=""
  # Add taps from taps.yaml
  {{- range .homebrew_taps }}
  TAPS="${TAPS}tap \"{{ .name }}\"\n"
  {{- end }}
  install_brew_packages "taps" "$TAPS"
  ```

  With:
  ```bash
  # Install taps first
  taps_file=$(mktemp)
  brews_file=$(mktemp)
  trap 'rm -f "$taps_file" "$brews_file"' EXIT
  {{- range .homebrew_taps }}
  echo "tap \"{{ .name }}\"" >> "$taps_file"
  {{- end }}
  install_brew_packages "taps" "$taps_file" "tap"
  ```

- [ ] **Step 3: Update the formulae section**

  Replace:
  ```bash
  # Collect all brew formulae from different sources
  log_step "Collecting brew formulae from all sources"
  BREWS=""
  # ... range loops writing to BREWS ...
  install_brew_packages "brews" "$BREWS"
  ```

  With:
  ```bash
  brews_file=$(mktemp)  # already declared above — skip this line, just populate it
  # Language servers that install via brew
  {{- range .language_servers }}
    {{- if has "brew" .installer }}
  echo "brew \"{{ .name }}\"" >> "$brews_file"
    {{- end }}
  {{- end }}
  # Formatters that install via brew
  {{- range .formatters }}
    {{- if has "brew" .installer }}
  echo "brew \"{{ .name }}\"" >> "$brews_file"
    {{- end }}
  {{- end }}
  # Linters that install via brew
  {{- range .linters }}
    {{- if has "brew" .installer }}
  echo "brew \"{{ .name }}\"" >> "$brews_file"
    {{- end }}
  {{- end }}
  # Development tools that install via brew
  {{- range .dev_tools }}
    {{- if has "brew" .installer }}
  echo "brew \"{{ .name }}\"" >> "$brews_file"
    {{- end }}
  {{- end }}
  # AI agents that install via brew
  {{- range .agents }}
    {{- if has "brew" .installer }}
  echo "brew \"{{ .name }}\"" >> "$brews_file"
    {{- end }}
  {{- end }}
  install_brew_packages "formulae" "$brews_file" "brew"
  ```

- [ ] **Step 4: Remove the summary block and clean up autoupdate step**

  Remove the entire summary block:
  ```bash
  # Summary
  log_header "Homebrew Formulae Installation Summary"
  log_detail "Installed packages by category:"
  log_substep "Language servers: ..."
  log_substep "Formatters: ..."
  log_substep "Linters: ..."
  log_substep "Development tools: ..."
  log_success "Homebrew formulae installation completed"
  ```

  Simplify the autoupdate section — remove the `log_step "Setting up..."` wrapper, keep only the conditional logic (which already uses `log_success`/`log_warning`/`log_debug`).

- [ ] **Step 5: Validate and apply**

  ```bash
  chezmoi apply --dry-run && chezmoi apply --force
  ```

  Expected:
  ```
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  🍺 Homebrew Formulae (CLI Tools)
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ✓ All N taps up to date
  ✓ All N formulae up to date
  ```

- [ ] **Step 6: Commit**

  ```bash
  git add .chezmoiscripts/macos/run_onchange_before-01-install-brew-formulae.sh.tmpl
  git commit -m "refactor: simplify brew-formulae output to pre-check + quiet install"
  ```

---

## Task 4: Update mise script

**Files:**
- Modify: `.chezmoiscripts/mise/run_onchange_after_100-mise-install-packages.sh.tmpl`

- [ ] **Step 1: Replace the entire file**

  ```bash
  #!/bin/bash

  # This script installs mise tools
  # run_onchange: {{ template "queries/packages.tmpl" (dict "PackageManager" "mise" "root" .) }}

  {{ template "utilities/logging.sh.tmpl" }}

  set -euo pipefail

  # Ensure mise is in PATH
  if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
      export PATH="$HOME/.local/bin:$PATH"
  fi

  if ! command -v mise >/dev/null 2>&1; then
      echo "❌ mise is not installed. Please install mise first."
      exit 1
  fi

  log_section "🔧 Mise Tools"

  # Pre-check: find tools needing installation
  MISSING_TOOLS=()
  while IFS= read -r line; do
      tool=$(echo "$line" | awk '{print $1}')
      [[ -n "$tool" ]] && MISSING_TOOLS+=("$tool")
  done < <(mise ls --missing 2>/dev/null || true)

  if [[ ${#MISSING_TOOLS[@]} -eq 0 ]]; then
      total=$(mise ls 2>/dev/null | wc -l | tr -d ' ')
      log_summary "✓ All $total mise tools up to date"
      exit 0
  fi

  mise install >> "$LOG_FILE" 2>&1
  install_exit=$?

  for tool in "${MISSING_TOOLS[@]}"; do
      if mise which "$tool" >/dev/null 2>&1; then
          log_install_result "ok" "$tool"
      else
          log_install_result "fail" "$tool"
      fi
  done

  if [[ $install_exit -ne 0 ]]; then
      log_error "Some mise tools failed to install. See $LOG_FILE for details."
  fi
  ```

- [ ] **Step 2: Validate and apply**

  ```bash
  chezmoi apply --dry-run && chezmoi apply --force
  ```

  Expected:
  ```
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  🔧 Mise Tools
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ✓ All N mise tools up to date
  ```

- [ ] **Step 3: Commit**

  ```bash
  git add .chezmoiscripts/mise/run_onchange_after_100-mise-install-packages.sh.tmpl
  git commit -m "refactor: simplify mise output to pre-check pattern"
  ```

---

## Task 5: Update cargo script

**Files:**
- Modify: `.chezmoiscripts/mise/run_onchange_after_110-cargo-packages.sh.tmpl`

The cargo script already has `log_section`, per-package pre-check (`cargo install --list`), and routes output to `$LOG_FILE`. Changes: replace `show_progress` with per-package ✓/✗ emitted only for newly-installed packages; restructure to collect MISSING first, then install and report.

- [ ] **Step 1: Add an early "all up to date" path**

  After collecting `CARGO_PACKAGES`, add a pre-check that builds a `MISSING_PACKAGES` list before running any install:

  ```bash
  # Pre-check: capture installed list once, then identify what's missing
  INSTALLED_LIST=$(cargo install --list 2>/dev/null)
  MISSING_PACKAGES=()
  for package_spec in "${CARGO_PACKAGES[@]}"; do
      if [[ "$package_spec" == *"cargo install"* ]]; then
          tool_name=$(echo "$package_spec" | sed -n 's/.*--git.*\/\([^/]*\)\.git \([^ ]*\).*/\2/p')
          [[ -z "$tool_name" ]] && tool_name=$(echo "$package_spec" | awk '{print $NF}')
          echo "$INSTALLED_LIST" | grep -q "^$tool_name " || MISSING_PACKAGES+=("$package_spec")
      else
          echo "$INSTALLED_LIST" | grep -q "^$package_spec " || MISSING_PACKAGES+=("$package_spec")
      fi
  done

  if [[ ${#MISSING_PACKAGES[@]} -eq 0 ]]; then
      log_summary "✓ All ${#CARGO_PACKAGES[@]} cargo packages up to date"
      exit 0
  fi
  ```

- [ ] **Step 2: Replace the install loop**

  Replace the existing `for package_spec in "${CARGO_PACKAGES[@]}"` loop (which iterates all packages and calls `show_progress`) with one that only iterates `MISSING_PACKAGES` and emits ✓/✗:

  ```bash
  for package_spec in "${MISSING_PACKAGES[@]}"; do
      if [[ "$package_spec" == *"cargo install"* ]]; then
          tool_name=$(echo "$package_spec" | sed -n 's/.*--git.*\/\([^/]*\)\.git \([^ ]*\).*/\2/p')
          [[ -z "$tool_name" ]] && tool_name=$(echo "$package_spec" | awk '{print $NF}')
          if eval "$package_spec" >> "$LOG_FILE" 2>&1; then
              log_install_result "ok" "$tool_name"
          else
              log_install_result "fail" "$tool_name"
          fi
      else
          if command -v cargo-binstall >/dev/null 2>&1 && \
             cargo binstall --no-confirm "$package_spec" >> "$LOG_FILE" 2>&1; then
              log_install_result "ok" "$package_spec"
          elif cargo install "$package_spec" >> "$LOG_FILE" 2>&1; then
              log_install_result "ok" "$package_spec"
          else
              log_install_result "fail" "$package_spec"
          fi
      fi
  done
  ```

  Remove: `show_progress`, `clear_progress`, `installed`/`failed`/`total`/`current` counters, the final `log_summary "✅ Cargo packages: ..."` line.

- [ ] **Step 3: Validate and apply**

  ```bash
  chezmoi apply --dry-run && chezmoi apply --force
  ```

  Expected (all installed):
  ```
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  🦀 Global Cargo Installation (N packages)
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ✓ All N cargo packages up to date
  ```

- [ ] **Step 4: Commit**

  ```bash
  git add .chezmoiscripts/mise/run_onchange_after_110-cargo-packages.sh.tmpl
  git commit -m "refactor: simplify cargo output to pre-check + quiet install"
  ```

---

## Task 6: Update npm script

**Files:**
- Modify: `.chezmoiscripts/mise/run_onchange_after_120-npm-packages.sh.tmpl`

The npm script already has `log_section` and a pre-check loop. Changes: emit ✓/✗ per package instead of aggregate `log_summary`; remove `show_progress` from the fallback individual-install loop.

- [ ] **Step 1: Update the "nothing to install" path**

  Replace:
  ```bash
  if [[ ${#PACKAGES_TO_INSTALL[@]} -eq 0 ]]; then
      log_summary "✅ All npm packages already installed ($ALREADY_INSTALLED packages)"
      exit 0
  fi
  ```

  With:
  ```bash
  if [[ ${#PACKAGES_TO_INSTALL[@]} -eq 0 ]]; then
      log_summary "✓ All ${#NPM_PACKAGES[@]} npm packages up to date"
      exit 0
  fi
  ```

- [ ] **Step 2: Update the bulk install success path**

  Replace:
  ```bash
  if npm install -g "${PACKAGES_TO_INSTALL[@]}" >> "$LOG_FILE" 2>&1; then
      log_summary "✅ NPM packages: ${#PACKAGES_TO_INSTALL[@]} installed, $ALREADY_INSTALLED already present"
  ```

  With:
  ```bash
  if npm install -g "${PACKAGES_TO_INSTALL[@]}" >> "$LOG_FILE" 2>&1; then
      for package in "${PACKAGES_TO_INSTALL[@]}"; do
          log_install_result "ok" "$package"
      done
  ```

- [ ] **Step 3: Update the fallback individual install loop**

  Replace the fallback loop's `show_progress` + `log_detail` + final `log_summary` block with:
  ```bash
  for package in "${PACKAGES_TO_INSTALL[@]}"; do
      if npm install -g "$package" >> "$LOG_FILE" 2>&1; then
          log_install_result "ok" "$package"
      else
          log_install_result "fail" "$package"
      fi
  done
  ```

  Remove: `installed`/`failed`/`total`/`current` counters, `show_progress`, `clear_progress`, both `log_summary` lines at the end.

- [ ] **Step 4: Validate and apply**

  ```bash
  chezmoi apply --dry-run && chezmoi apply --force
  ```

- [ ] **Step 5: Commit**

  ```bash
  git add .chezmoiscripts/mise/run_onchange_after_120-npm-packages.sh.tmpl
  git commit -m "refactor: simplify npm output to per-package result"
  ```

---

## Task 7: Update pip script

**Files:**
- Modify: `.chezmoiscripts/mise/run_onchange_after_130-pip-packages.sh.tmpl`

This script lacks the logging utility and has no pre-check.

- [ ] **Step 1: Replace the entire file**

  ```bash
  #!/bin/bash

  # Global pip Package Installation
  # run_onchange: {{ template "queries/packages.tmpl" (dict "PackageManager" "pip" "root" .) }}

  {{ template "utilities/logging.sh.tmpl" }}

  set -euo pipefail

  if ! mise which python >/dev/null 2>&1; then
      echo "❌ Python not found. Please run mise installation first."
      exit 1
  fi

  log_section "🐍 Python pip Packages"

  PIP_PACKAGES=({{ template "queries/packages.tmpl" (dict "PackageManager" "pip" "root" .) }})

  if [[ ${#PIP_PACKAGES[@]} -eq 0 ]]; then
      log_summary "✓ No pip packages configured"
      exit 0
  fi

  # Pre-check
  MISSING=()
  for pkg in "${PIP_PACKAGES[@]}"; do
      pip show "$pkg" >/dev/null 2>&1 || MISSING+=("$pkg")
  done

  if [[ ${#MISSING[@]} -eq 0 ]]; then
      log_summary "✓ All ${#PIP_PACKAGES[@]} pip packages up to date"
      exit 0
  fi

  if pip install "${MISSING[@]}" >> "$LOG_FILE" 2>&1; then
      for pkg in "${MISSING[@]}"; do
          log_install_result "ok" "$pkg"
      done
  else
      for pkg in "${MISSING[@]}"; do
          if pip show "$pkg" >/dev/null 2>&1; then
              log_install_result "ok" "$pkg"
          else
              log_install_result "fail" "$pkg"
          fi
      done
      log_error "Some pip packages failed. See $LOG_FILE for details."
  fi
  ```

- [ ] **Step 2: Validate and apply**

  ```bash
  chezmoi apply --dry-run && chezmoi apply --force
  ```

- [ ] **Step 3: Commit**

  ```bash
  git add .chezmoiscripts/mise/run_onchange_after_130-pip-packages.sh.tmpl
  git commit -m "refactor: simplify pip output to pre-check + quiet install"
  ```

---

## Task 8: Update go script

**Files:**
- Modify: `.chezmoiscripts/mise/run_onchange_after_140-go-packages.sh.tmpl`

Go has no "check if installed" built-in. Pre-check by extracting the expected binary name from the package path and testing with `command -v`. The binary name is always the last path component before `@version`.

- [ ] **Step 1: Replace the entire file**

  ```bash
  #!/bin/bash

  # Global go Package Installation
  # run_onchange: {{ template "queries/packages.tmpl" (dict "PackageManager" "go" "root" .) }}

  {{ template "utilities/logging.sh.tmpl" }}

  set -euo pipefail

  if ! mise which go >/dev/null 2>&1; then
      echo "❌ Go not found. Please run mise installation first."
      exit 1
  fi

  export GOPATH="${GOPATH:-$HOME/go}"
  export PATH="$GOPATH/bin:$PATH"

  log_section "🐹 Go Packages"

  GO_PACKAGES=()

  # Language servers with go install
  {{- range .language_servers }}
  {{- if has "go" .installer }}
  {{- if hasKey . "install_command" }}
  GO_PACKAGES+=("{{ .install_command }}")
  {{- else }}
  GO_PACKAGES+=("{{ .name }}@latest")
  {{- end }}
  {{- end }}
  {{- end }}

  # Formatters with go install
  {{- range .formatters }}
  {{- if has "go" .installer }}
  {{- if hasKey . "install_command" }}
  GO_PACKAGES+=("{{ .install_command }}")
  {{- else }}
  GO_PACKAGES+=("{{ .name }}@latest")
  {{- end }}
  {{- end }}
  {{- end }}

  # Linters with go install
  {{- range .linters }}
  {{- if has "go" .installer }}
  {{- if hasKey . "install_command" }}
  GO_PACKAGES+=("{{ .install_command }}")
  {{- else }}
  GO_PACKAGES+=("{{ .name }}@latest")
  {{- end }}
  {{- end }}
  {{- end }}

  if [[ ${#GO_PACKAGES[@]} -eq 0 ]]; then
      log_summary "✓ No go packages configured"
      exit 0
  fi

  # Pre-check: extract binary name as last component of module path (before @)
  go_binary_name() {
      local pkg="$1"
      basename "${pkg%@*}"
  }

  MISSING=()
  for pkg in "${GO_PACKAGES[@]}"; do
      binary=$(go_binary_name "$pkg")
      command -v "$binary" >/dev/null 2>&1 || MISSING+=("$pkg")
  done

  if [[ ${#MISSING[@]} -eq 0 ]]; then
      log_summary "✓ All ${#GO_PACKAGES[@]} go packages up to date"
      exit 0
  fi

  for pkg in "${MISSING[@]}"; do
      binary=$(go_binary_name "$pkg")
      if go install "$pkg" >> "$LOG_FILE" 2>&1; then
          log_install_result "ok" "$binary"
      else
          log_install_result "fail" "$binary"
      fi
  done
  ```

- [ ] **Step 2: Validate and apply**

  ```bash
  chezmoi apply --dry-run && chezmoi apply --force
  ```

- [ ] **Step 3: Commit**

  ```bash
  git add .chezmoiscripts/mise/run_onchange_after_140-go-packages.sh.tmpl
  git commit -m "refactor: simplify go output to binary pre-check + quiet install"
  ```

---

## Task 9: Update gem script

**Files:**
- Modify: `.chezmoiscripts/mise/run_onchange_after_150-gem-packages.sh.tmpl`

This script has per-package `gem list -i` check and raw `echo`. The Go template `define` blocks at the top stay; just replace the echo-based output.

- [ ] **Step 1: Replace the entire file**

  ```bash
  #!/bin/bash

  # Global gem Package Installation
  # run_onchange: {{ template "queries/packages.tmpl" (dict "PackageManager" "gem" "root" .) }}

  {{ template "utilities/logging.sh.tmpl" }}

  set -euo pipefail

  if ! mise which ruby >/dev/null 2>&1; then
      echo "❌ Ruby not found. Please run mise installation first."
      exit 1
  fi

  log_section "💎 Ruby Gem Packages"

  GEM_PACKAGES=()

  {{- range .language_servers }}
  {{- if has "gem" .installer }}
  GEM_PACKAGES+=("{{ .name }}")
  {{- end }}
  {{- end }}

  {{- range .formatters }}
  {{- if has "gem" .installer }}
  GEM_PACKAGES+=("{{ .name }}")
  {{- end }}
  {{- end }}

  {{- range .linters }}
  {{- if has "gem" .installer }}
  GEM_PACKAGES+=("{{ .name }}")
  {{- end }}
  {{- end }}

  if [[ ${#GEM_PACKAGES[@]} -eq 0 ]]; then
      log_summary "✓ No gem packages configured"
      exit 0
  fi

  # Pre-check
  MISSING=()
  for pkg in "${GEM_PACKAGES[@]}"; do
      gem list -i "$pkg" >/dev/null 2>&1 || MISSING+=("$pkg")
  done

  if [[ ${#MISSING[@]} -eq 0 ]]; then
      log_summary "✓ All ${#GEM_PACKAGES[@]} gem packages up to date"
      exit 0
  fi

  for pkg in "${MISSING[@]}"; do
      if gem install "$pkg" >> "$LOG_FILE" 2>&1; then
          log_install_result "ok" "$pkg"
      else
          log_install_result "fail" "$pkg"
      fi
  done
  ```

  Note: the original script used template `define` blocks for `collect_gem_packages` and `install_gem_packages`. These can be removed since the new script inlines the package collection and installation directly.

- [ ] **Step 2: Validate and apply**

  ```bash
  chezmoi apply --dry-run && chezmoi apply --force
  ```

- [ ] **Step 3: Commit**

  ```bash
  git add .chezmoiscripts/mise/run_onchange_after_150-gem-packages.sh.tmpl
  git commit -m "refactor: simplify gem output to pre-check + quiet install"
  ```

---

## Task 10: Update bun script

**Files:**
- Modify: `.chezmoiscripts/mise/run_onchange_after_160-bun-packages.sh.tmpl`

Same pattern as gem. Has per-package `bun pm ls -g` check and raw `echo`.

- [ ] **Step 1: Replace the entire file**

  ```bash
  #!/bin/bash

  # Global bun Package Installation
  # run_onchange: {{ template "queries/packages.tmpl" (dict "PackageManager" "bun" "root" .) }}

  {{ template "utilities/logging.sh.tmpl" }}

  set -euo pipefail

  if ! command -v bun >/dev/null 2>&1; then
      echo "❌ bun not found. Installing bun..."
      curl -fsSL https://bun.sh/install | bash
      export PATH="$HOME/.bun/bin:$PATH"
      if ! command -v bun >/dev/null 2>&1; then
          echo "❌ Failed to install bun. Please install manually."
          exit 1
      fi
  fi

  log_section "🍞 Bun Packages"

  BUN_PACKAGES=()

  # AI agents
  {{- range .agents }}
  {{- if has "bun" .installer }}
  BUN_PACKAGES+=("{{ .name }}")
  {{- end }}
  {{- end }}

  # MCP servers
  {{- range .mcp_servers }}
  {{- if has "bun" .installer }}
  BUN_PACKAGES+=("{{ .name }}")
  {{- end }}
  {{- end }}

  # Language servers
  {{- range .language_servers }}
  {{- if has "bun" .installer }}
  BUN_PACKAGES+=("{{ .name }}")
  {{- end }}
  {{- end }}

  # Formatters
  {{- range .formatters }}
  {{- if has "bun" .installer }}
  BUN_PACKAGES+=("{{ .name }}")
  {{- end }}
  {{- end }}

  # Linters
  {{- range .linters }}
  {{- if has "bun" .installer }}
  BUN_PACKAGES+=("{{ .name }}")
  {{- end }}
  {{- end }}

  if [[ ${#BUN_PACKAGES[@]} -eq 0 ]]; then
      log_summary "✓ No bun packages configured"
      exit 0
  fi

  # Pre-check
  MISSING=()
  for pkg in "${BUN_PACKAGES[@]}"; do
      bun pm ls -g 2>/dev/null | grep -q "$pkg" || MISSING+=("$pkg")
  done

  if [[ ${#MISSING[@]} -eq 0 ]]; then
      log_summary "✓ All ${#BUN_PACKAGES[@]} bun packages up to date"
      exit 0
  fi

  for pkg in "${MISSING[@]}"; do
      if bun install -g "$pkg" >> "$LOG_FILE" 2>&1; then
          log_install_result "ok" "$pkg"
      else
          log_install_result "fail" "$pkg"
      fi
  done
  ```

- [ ] **Step 2: Validate and apply**

  ```bash
  chezmoi apply --dry-run && chezmoi apply --force
  ```

- [ ] **Step 3: Final idempotency check**

  Run `chezmoi apply` a second time to confirm all scripts take the "up to date" path:

  ```bash
  chezmoi apply
  ```

  Every script section should show `✓ All N ... up to date`.

- [ ] **Step 4: Commit**

  ```bash
  git add .chezmoiscripts/mise/run_onchange_after_160-bun-packages.sh.tmpl
  git commit -m "refactor: simplify bun output to pre-check + quiet install"
  ```
