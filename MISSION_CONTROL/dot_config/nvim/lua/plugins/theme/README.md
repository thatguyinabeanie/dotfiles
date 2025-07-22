# Theme plugins

This directory contains all theme and UI enhancement plugins for Neovim.

## Plugin overview

### Core theme

- **catppuccin.lua** - Main colorscheme with optimized integrations
  - Loading: Immediate (priority = 1000)
  - Features: Custom palette, selective integrations, transparent background support

- **theme.lua** - Extra theme utilities and LazyVim integration
  - Loading: Immediate
  - Features: Transparency toggle, theme switching helpers

### UI components

- **bufferline.lua** - Tab/buffer line at the top
  - Loading: Immediate (after colorscheme)
  - Features: Catppuccin integration, custom separators, diagnostics indicators

- **lualine.lua** - Status line at the bottom
  - Loading: VeryLazy event
  - Features: Custom theme, git info, diagnostics, file info, pipeline status

- **symbol-usage.lua** - Shows symbol references inline
  - Loading: On demand (lazy = true)
  - Features: Virtual text for references, implementations, definitions

### Visual enhancements

- **nvim-colorizer.lua** - Highlights color codes in files
  - Loading: VeryLazy event
  - Features: Red/Green/Blue highlighting, tailwind support, virtual text mode

- **visual-whitespace.lua** - Shows whitespace characters
  - Loading: VeryLazy event
  - Features: Configurable space/tab indicators, EOL markers

## Configuration Details

### Catppuccin Theme

```lua
-- Optimized with minimal integrations
default_integrations = false,
integrations = {
  cmp = true,
  gitsigns = true,
  nvimtree = true,
  treesitter = true,
  notify = true,
  mini = { enabled = true },
  native_lsp = {
    enabled = true,
    virtual_text = { errors = { "italic" } },
    underlines = { errors = { "underline" } },
  },
}
```

### Bufferline

- Custom separator style: `slant`
- Shows diagnostics from LSP
- Groups buffers by directory
- Mouse support for clicking tabs

### Lualine

- Six sections: mode, git, diagnostics, filename, filetype, location
- Integrated with:
  - Git status (branch, diff)
  - LSP diagnostics
  - Pipeline.nvim status (safely wrapped)
  - File encoding and format

## Keymappings

### Bufferline Navigation

- `<S-h>` - Previous buffer
- `<S-l>` - Next buffer
- `<leader>bp` - Toggle pin
- `<leader>bP` - Delete non-pinned buffers
- `<leader>bo` - Delete other buffers
- `<leader>br` - Delete buffers to the right
- `<leader>bl` - Delete buffers to the left
- `<leader>bd` - Sort by directory
- `<leader>be` - Sort by extension

### Visual Whitespace

- Automatically shows/hides based on context
- No manual keymappings required

## Performance Considerations

1. **Catppuccin** loads immediately with high priority to prevent flashing
2. **Bufferline** loads after colorscheme to ensure proper theming
3. **Lualine** deferred to VeryLazy for faster startup
4. **Symbol-usage** fully lazy loaded until needed
5. **Colorizer** and **visual-whitespace** load after UI settles

## Customization

### Changing Theme

The theme system is centrally managed through chezmoi configuration. Update `/Users/gmendoza/.config/chezmoi/chezmoi.toml`:

```toml
[data]
THEME_MODE = "system"              # Options: "system", "dark", "light"
THEME_LIGHT = "catppuccin-latte"   # Light theme variant
THEME_DARK = "catppuccin-mocha"    # Dark theme variant
```

Then run `chezmoi apply` to update the Neovim configuration.

#### Theme modes

- **"system"**: Automatically switches between light/dark themes using auto-dark-mode plugin
- **"dark"**: Forces the chosen dark theme, disables auto-dark-mode
- **"light"**: Forces the chosen light theme, disables auto-dark-mode

#### Available themes

- catppuccin-latte for light mode
- catppuccin-frappe for dark mode 
- `catppuccin-macchiato` (dark)
- `catppuccin-mocha` (dark)

### Transparency

Toggle with `<leader>ut` (managed by LazyVim core)

### Status Line Components

Add custom components to lualine sections in `lualine.lua`

## Dependencies

- Requires Nerd Font for icons
- Catppuccin theme must load before other UI plugins
- Some integrations depend on their respective plugins being installed

## Troubleshooting

### Theme Not Loading

- Check `:Lazy` for load errors
- Ensure catppuccin loads with high priority
- Verify no conflicting colorscheme commands

### Status Line Issues

- Pipeline status wrapped in pcall for safety
- Check `:LualineNotices` for component errors
- Verify LSP is running for diagnostics

### Performance

- Use `:Lazy profile` to check theme load times
- Consider disabling unused catppuccin integrations
- Reduce lualine update frequency if needed
