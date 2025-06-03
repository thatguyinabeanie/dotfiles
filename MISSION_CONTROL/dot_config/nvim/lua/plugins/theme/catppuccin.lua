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
      show_end_of_buffer = false,
      term_colors = true,
      dim_inactive = {
        enabled = false,
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
      default_integrations = false, -- Disable default integrations for better control
      integrations = {
        -- Essential integrations (loaded immediately)
        blink_cmp = true,
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
            ok = { "italic" },
          },
          underlines = {
            errors = { "underline" },
            hints = { "underline" },
            warnings = { "underline" },
            information = { "underline" },
            ok = { "underline" },
          },
          inlay_hints = {
            background = true,
          },
        },
        treesitter = true,
        treesitter_context = true,
        -- Non-essential integrations (can be loaded on demand)
        cmp = false, -- Using blink_cmp instead
        neogit = true,
        ufo = true,
        dap = false, -- Load when debugging
        dap_ui = false, -- Load when debugging
        snacks = true,
        mini = {
          enabled = true,
          indentscope_color = "", -- Disabled, using Snacks scope instead
        },
        -- Common integrations we want
        gitsigns = true,
        telescope = {
          enabled = true,
          style = "nvchad",
        },
        which_key = true,
        indent_blankline = {
          enabled = false, -- Disabled, using Snacks indent/scope instead
          scope_color = "",
          colored_indent_levels = false,
        },
        mason = true,
        noice = true,
        notify = true,
        semantic_tokens = true,
        flash = true,
        markdown = true,
        render_markdown = true,
      },
    },
  },
  {
    "f-person/auto-dark-mode.nvim",
    opts = {
      update_interval = 1000,
      set_dark_mode = function()
        vim.o.background = "dark"
        vim.cmd("colorscheme catppuccin-mocha")
      end,
      set_light_mode = function()
        vim.o.background = "light"
        vim.cmd("colorscheme catppuccin-latte")
      end,
      fallback = "dark",
    },
  },
}
