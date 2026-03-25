# Profile-Based Package Installation

## Problem

All packages declared in `.chezmoidata/*.yaml` are always installed regardless of machine role
or workflow needs. There is no way to say "install pyright only on machines where I do Python
development" without removing it from the YAML entirely.

## Decision

Add an optional `profiles` array field to package entries. Active profiles are stored in the
existing persistent config system and read into chezmoi template data as `ACTIVE_PROFILES`.
Query templates filter packages based on profile membership.

### Alternatives Considered

1. **Separate profile aggregation template** - cleaner separation but adds indirection and
   requires touching every installer script.
2. **New top-level YAML sections per profile** - clear structure but causes schema proliferation
   and package duplication across profiles.

Tag-based filtering (chosen) is backward compatible, minimal in surface area, and reuses
existing query infrastructure.

## How It Works

### YAML Schema

```yaml
dev_tools:
  - name: ripgrep
    installer: [brew]           # no profiles = always installed

  - name: pyright
    installer: [mise, mason]
    profiles: [python-dev, data-science]

  - name: node
    installer: [mise]
    profiles: [default]         # explicit default = always installed
```

### Rules

- Package with no `profiles` field: always installed (backward compatible)
- Package with `profiles: [default]`: always installed
- Package with `profiles: [python-dev]`: installed only when `python-dev` is active
- `"default"` is always considered active (cannot be deactivated)

### Activation

```bash
# Write to persistent config
config-persistence.sh write active_profiles "default,python-dev"
chezmoi apply

# Or override via environment variable (temporary)
ACTIVE_PROFILES="default,python-dev" chezmoi apply
```

### Data Flow

```
persistent config: active_profiles = "default,python-dev"
  -> chezmoi.toml.tmpl: ACTIVE_PROFILES = "default,python-dev"
  -> query templates: splitList -> ["default", "python-dev"]
  -> foreach package: include if no .profiles OR intersection non-empty
  -> run_onchange hash changes -> installer scripts run
```

## Files Changed

| File | Change |
|------|--------|
| `.chezmoi.toml.tmpl` | Added `ACTIVE_PROFILES` to `[data]` |
| `.chezmoitemplates/queries/packages.tmpl` | Profile filtering in all range blocks |
| `.chezmoitemplates/queries/brew-formulae.tmpl` | Profile filtering in all range blocks |
| `.chezmoitemplates/queries/brew-casks.tmpl` | Profile filtering in all range blocks |
| `CLAUDE.md` | Documented `profiles` field in schema reference |

## Template Pattern

All query templates use this inline filter for each range block:

```go-template
{{- $profileMatch := true -}}
{{- if hasKey . "profiles" -}}
  {{- $profileMatch = false -}}
  {{- range .profiles -}}
    {{- if has . $active_profiles -}}{{- $profileMatch = true -}}{{- end -}}
  {{- end -}}
{{- end -}}
{{- if $profileMatch -}}
  {{- $packages = append $packages .name -}}
{{- end -}}
```

`hasKey` is used instead of direct field access to safely handle packages that don't have a
`profiles` field (which is most of them, by design).
