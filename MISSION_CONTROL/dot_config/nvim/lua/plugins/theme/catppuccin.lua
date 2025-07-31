return {
  {
    "catppuccin/nvim",
    lazy = false,
    name = "catppuccin",
    opts = {
      transparent_background = true,
      flavour = "mocha",
      background = {
        light = "latte",
        dark = "mocha",
      },
      show_end_of_buffer = true,
      term_colors = true,
      dim_inactive = {
        enabled = true,
        shade = "dark",
        percentage = 0.15,
      },
      no_italic = false,
      no_bold = false,
      no_underline = false,
      styles = {
        comments = { "italic" },
        conditionals = { "italic" },
      },
      default_integrations = false,
      custom_highlights = function(colors)
        return {
          -- Very subtle but distinct colored indent lines
          IndentLevel1 = { fg = "#3C4C5A" }, -- Muted blue-gray
          IndentLevel2 = { fg = "#3C5A4C" }, -- Muted green-gray
          IndentLevel3 = { fg = "#5A5A3C" }, -- Muted yellow-gray
          IndentLevel4 = { fg = "#5A4C3C" }, -- Muted orange-gray
          IndentLevel5 = { fg = "#4C3C5A" }, -- Muted purple-gray
          IblScope = { fg = colors.overlay0 }, -- Disabled
          -- Multi-color cycling chunks
          ChunkLevel1 = { fg = colors.blue, bold = true },
          ChunkLevel2 = { fg = colors.green, bold = true },
          ChunkLevel3 = { fg = colors.yellow, bold = true },
          ChunkLevel4 = { fg = colors.peach, bold = true },
          ChunkLevel5 = { fg = colors.mauve, bold = true },

          -- Enhanced cursor/selection
          CursorLine = { bg = colors.surface0 },
          Visual = { bg = colors.surface1, style = { "bold" } },

          -- Better diff colors
          DiffAdd = { fg = colors.green, bg = colors.none },
          DiffChange = { fg = colors.yellow, bg = colors.none },
          DiffDelete = { fg = colors.red, bg = colors.none },

          -- Subtle line numbers
          LineNr = { fg = colors.overlay0 },
          CursorLineNr = { fg = colors.lavender, style = { "bold" } },

          -- Enhanced search
          Search = { fg = colors.base, bg = colors.yellow },
          IncSearch = { fg = colors.base, bg = colors.peach },

          -- Enhanced LSP diagnostics
          DiagnosticError = { fg = colors.red, style = { "bold" } },
          DiagnosticWarn = { fg = colors.yellow },
          DiagnosticInfo = { fg = colors.sky },
          DiagnosticHint = { fg = colors.teal },
          DiagnosticOk = { fg = colors.green },

          -- Virtual text styling
          DiagnosticVirtualTextError = { fg = colors.red, bg = colors.none, style = { "italic", "bold" } },
          DiagnosticVirtualTextWarn = { fg = colors.yellow, bg = colors.none, style = { "italic" } },
          DiagnosticVirtualTextInfo = { fg = colors.sky, bg = colors.none, style = { "italic" } },
          DiagnosticVirtualTextHint = { fg = colors.teal, bg = colors.none, style = { "italic" } },
          DiagnosticVirtualTextOk = { fg = colors.green, bg = colors.none, style = { "italic" } },

          -- Inlay hints styling
          LspInlayHint = { fg = colors.overlay1, bg = colors.surface0, style = { "italic" } },

          -- LSP signature help
          LspSignatureActiveParameter = { fg = colors.peach, style = { "bold", "underline" } },
        }
      end,
      integrations = {
        -- Essential integrations
        blink_cmp = {
          enabled = true,
          style = "bordered",
        },
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = { "italic", "bold" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
            ok = { "italic" },
          },
          underlines = {
            errors = { "undercurl" },
            hints = { "underdotted" },
            warnings = { "underdashed" },
            information = { "underline" },
            ok = { "underline" },
          },
          inlay_hints = {
            background = true,
          },
        },
        treesitter = true,
        treesitter_context = true,
        ufo = true,
        -- Git
        neogit = true,
        gitsigns = true,
        -- UI
        snacks = true,
        mini = {
          enabled = true,
        },
        telescope = {
          enabled = true,
        },
        which_key = true,
        mason = true,
        noice = true,
        notify = true,
        -- Navigation & Movement
        leap = true,
        harpoon = true,
        -- Task Management
        overseer = true,
        -- Additional UI
        -- barbecue = true, -- Not available in current Catppuccin version
        -- Features
        semantic_tokens = true,
        flash = true,
        markdown = true,
        render_markdown = true,
        -- Disabled
        cmp = false, -- Using blink_cmp
        dap = true, -- Load when debugging
        dap_ui = true, -- Load when debugging
      },
    },
  },
}
