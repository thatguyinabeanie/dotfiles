# 🛠️ Cross-Shell Dotfiles Generator System: Full Plan

---

## 1. Registry as Source of Truth

- **Location:** `.chezmoidata/dot_shell_registry.yaml`
- **Contents:** All aliases, functions, and (optionally) environment variables, with per-shell overrides.
- **Format Example:**

  ```yaml
  aliases:
    l:
      default: ls -l
    gs:
      zsh: git status
      nushell: git status
  functions:
    mkcd:
      description: Make a directory and cd into it
      body:
        zsh: |
          mkcd() { mkdir -p "$1"; cd "$1"; }
        nushell: |
          def mkcd [dir: string] { mkdir $dir; cd $dir }
  env:
    EDITOR: nvim
  ```

---

## 2. Generator Script

- **Location:** `MISSION_CONTROL/scripts/generate_shell_configs.py`
- **Responsibilities:**
  - Parse the registry YAML.
  - For each shell (zsh, nushell):
    - Generate the correct syntax for aliases, functions, and env vars.
    - Use shell-specific overrides if present, else use `default`.
    - If a function is missing for a shell, optionally call an LLM to generate a translation and insert it as a commented suggestion.
    - Write output to the correct config files:
      - Zsh: `MISSION_CONTROL/dot_config/zsh/aliases.zsh` (and/or `functions.zsh`)
      - Nushell: `MISSION_CONTROL/dot_config/nushell/aliases.nu.tmpl` (and/or `functions.nu.tmpl`)
  - Optionally, print warnings for missing or ambiguous entries.

- **AI Integration:**
  - If enabled, for each missing shell implementation, send the function description and source code to an LLM (e.g., OpenAI API).
  - Insert the AI-generated code as a comment, clearly marked as a suggestion.
  - Allow toggling AI assistance via a CLI flag or environment variable.

- **CLI Usage:**
  - `python3 generate_shell_configs.py [--ai] [--shell zsh|nushell|all]`

---

## 3. Chezmoi Integration

- **Script:** `.chezmoiscripts/run_generate_shell_configs.sh`
  - Calls the generator script.
  - Ensures configs are always up to date on `chezmoi apply`.

- **Registry Location:** `.chezmoidata/dot_shell_registry.yaml`
  - Accessible to both the generator and chezmoi templates.

---

## 4. Pre-commit/CI Integration (Optional but Recommended)

- **Pre-commit Hook:**
  - Runs the generator script.
  - Checks for changes in generated files.
  - Fails the commit if generated files are out of sync with the registry.

- **CI Pipeline:**
  - Runs the generator and checks for diffs.
  - Optionally, runs shell syntax checks (`zsh -n`, `nu --check`).

---

## 5. Output File Structure

- **Zsh:**
  - `aliases.zsh`: All aliases.
  - `functions.zsh`: All functions (or combined with aliases).
  - Optionally, `env.zsh` for environment variables.

- **Nushell:**
  - `aliases.nu.tmpl`: All aliases.
  - `functions.nu.tmpl`: All functions (or combined).
  - Optionally, `env.nu.tmpl` for environment variables.

---

## 6. Function Handling Details

- **If both shells have an implementation:** Use as-is.
- **If only one shell has an implementation:**
  - If AI is enabled, generate a translation and insert as a comment.
  - If not, insert a stub with a comment indicating missing implementation.
- **If only `default` is present:** Use for both, but warn if ambiguous.
- **If missing entirely:** Insert a stub with a warning comment.

---

## 7. AI Integration Details

- **API:** OpenAI (or local LLM endpoint).
- **Prompt Example:**

  ```zsh
  # Convert the following shell function to Nushell syntax.
  # Description: Make a directory and cd into it.
  # Zsh code:
  mkcd() { mkdir -p "$1"; cd "$1"; }
  ```

- **Result Handling:**
  - Insert as a comment in the generated file.
  - Mark clearly as AI-generated and for review.

- **Config:**
  - API key via environment variable or config file.
  - AI assistance enabled by default or via CLI flag.

---

## 8. User Workflow

1. **Edit the registry** (`.chezmoidata/dot_shell_registry.yaml`) to add or update aliases/functions.
2. **Run chezmoi apply** (or commit changes):
   - The chezmoi script runs the generator.
   - Shell config files are updated.
   - If a function is missing for a shell, an AI suggestion is inserted (if enabled).
3. **Review generated files:**
   - Accept, edit, or reject AI suggestions.
   - Fill in missing implementations as needed.
4. **Commit and push.**
5. **(Optional) Use pre-commit/CI to enforce consistency.**

---

## 9. Extensibility

- **Add new shells:** Add new output templates and shell keys in the registry.
- **Add new config types:** Extend the registry and generator to handle more (e.g., shell options, plugins).
- **Improve AI prompts:** Refine for better translations.

---

## 10. Documentation

- Document the workflow in your repo's README.
- Explain how to add new entries, run the generator, and review AI suggestions.

---

## 11. Example Output (Zsh, with AI suggestion for Nushell)

**`aliases.zsh`:**

```zsh
alias l="ls -l"
alias gs="git status"
```

**`functions.zsh`:**

```zsh
# mkcd: Make a directory and cd into it
mkcd() { mkdir -p "$1"; cd "$1"; }
```

**`aliases.nu.tmpl`:**

```nu
alias l = ls -l
alias gs = git status
```

**`functions.nu.tmpl`:**

```nu
# mkcd: Make a directory and cd into it
# AI-SUGGESTED TRANSLATION FROM ZSH:
# def mkcd [dir: string] {
#   mkdir $dir
#   cd $dir
# }
```

---

## 12. Security & Privacy

- If using OpenAI or a cloud LLM, be aware that function code/descriptions are sent to the API.
- For sensitive code, consider using a local LLM.

---

## 13. Error Handling & Logging

- Generator logs warnings for missing implementations, ambiguous defaults, and AI failures.
- Optionally, outputs a summary report after each run.

---

## 14. Testing

- Add a test mode to the generator to check for syntax errors in generated files.
- Optionally, run shell-specific syntax checks automatically.

## Example Shell Config

```bash
# Example shell config for Zsh
export EDITOR=nvim
export SHELL=zsh
```
