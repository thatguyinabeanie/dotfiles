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
      default_integrations = false,
      integrations = {
        -- Essential integrations
        blink_cmp = {
          enabled = true,
          style = 'bordered',
        },
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
        ufo = true,
        -- Git
        neogit = true,
        gitsigns = true,
        -- UI
        snacks = true,
        mini = {
          enabled = true,
          indentscope_color = "", -- Disabled, using Snacks scope
        },
        telescope = {
          enabled = true,
          style = "nvchad",
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
        dap = false, -- Load when debugging
        dap_ui = false, -- Load when debugging
        indent_blankline = {
          enabled = false, -- Using Snacks indent/scope
        },
      },
    },
  },
}
