## Configuration Management

- Configuration data is highly modularized within the `.chezmoidata` directory, separated by platform (macOS, cross-platform) and context (shared, personal, work).
- A persistent configuration system is in place to store and restore settings across system reinstalls. Use the `chezmoi-backup-config` and `chezmoi-restore-config` scripts to manage this.

### ⚠️ CRITICAL: Never Edit Files in ~/.config/ Directly

**NEVER modify files in `~/.config/` or other target directories directly.** This breaks the entire chezmoi workflow and creates conflicts.

#### ❌ Wrong Approach:
```bash
# NEVER DO THIS - breaks chezmoi workflow
vim ~/.config/mise/config.toml
vim ~/.config/ghostty/config
mise use -g lefthook@1.12.3  # This modifies ~/.config/mise/config.toml directly
```

#### ✅ Correct Approach:
```bash
# Always edit source templates in the chezmoi repository
vim dot_config/mise/config.toml.tmpl
vim dot_config/ghostty/config.tmpl
vim .chezmoidata/tools.yaml  # Update data that feeds into templates

# Then apply changes through chezmoi
chezmoi apply --dry-run  # Validate first
chezmoi apply --force    # Apply when validation passes
```

#### The Chezmoi Rule:
1. **Source of truth**: All configuration lives in chezmoi templates (`.tmpl` files) and data (`.chezmoidata/`)
2. **Generated files**: Files in `~/.config/` are generated from templates and should never be edited directly
3. **Workflow**: Edit source → validate with dry-run → apply through chezmoi

#### When You Break This Rule:
- **Conflicts**: chezmoi detects changes and asks "diff/overwrite/all-overwrite/skip/quit"
- **Lost changes**: Your manual edits get overwritten when templates are applied
- **Inconsistency**: Configuration becomes out of sync between machines
- **Debugging hell**: Hard to track where configuration actually comes from

#### Recovery Steps:
If you accidentally edit files in `~/.config/`:
1. **Don't panic** - chezmoi will detect the conflict
2. **Choose 'diff'** to see what changed
3. **Update the source template** to include your intended changes
4. **Choose 'overwrite'** to let chezmoi apply the template
5. **Verify** the configuration is correct after chezmoi apply
