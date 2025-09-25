return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "mocha",
      background = {
        light = "latte",
        dark = "mocha",
      },
      transparent_background = true,
      float = {
        transparent = true, -- enable transparent floating windows
      },
      show_end_of_buffer = true,
      term_colors = true,
      dim_inactive = {
        enabled = false,
      },
      no_italic = false,
      no_bold = false,
      no_underline = false,
      styles = {
        comments = { "italic" },
        conditionals = { "italic" },
      },
      default_integrations = true,
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
        ufo = false,
        -- Git
        neogit = true,
        gitsigns = true,
        -- UI
        snacks = {
          enabled = true,
        },
        mini = {
          enabled = true,
          -- indentscope_color = "", -- Disabled, using Snacks scope
        },
        telescope = {
          enabled = true,
        },
        which_key = true,
        mason = true,
        noice = true,
        notify = true,
        -- Features
        semantic_tokens = true,
        flash = true,
        markdown = true,
        render_markdown = true,
        -- Disabled
        cmp = false, -- Using blink_cmp
        dap = true, -- Load when debugging
        dap_ui = true, -- Load when debugging
        indent_blankline = {
          enabled = true,
        },
      },
      custom_highlights = function(colors)
        return {
          -- Indent guide highlights (referenced by indent-blankline.lua)
          IndentLevel1 = { fg = "#3C4C5A" }, -- Muted blue-gray
          IndentLevel2 = { fg = "#3C5A4C" }, -- Muted green-gray
          IndentLevel3 = { fg = "#5A5A3C" }, -- Muted yellow-gray
          IndentLevel4 = { fg = "#5A4C3C" }, -- Muted orange-gray
          IndentLevel5 = { fg = "#4C3C5A" }, -- Muted purple-gray

          -- Chunk highlights (referenced by snacks.lua)
          ChunkLevel1 = { fg = colors.blue, bold = true },
          ChunkLevel2 = { fg = colors.green, bold = true },
          ChunkLevel3 = { fg = colors.yellow, bold = true },
          ChunkLevel4 = { fg = colors.peach, bold = true },
          ChunkLevel5 = { fg = colors.mauve, bold = true },
        }
      end,
    },
  },
  {
    "catppuccin",
    optional = true,
    opts = function()
      local bufferline = require("catppuccin.groups.integrations.bufferline")
      bufferline.get = bufferline.get or bufferline.get_theme
    end,
  },
}
