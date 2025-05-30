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
      default_integrations = true,
      integrations = {
        cmp = true,
        neogit = true,
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
          ufo = true,
          treesitter = true,
          treesitter_context = true,
          dap = true,
          dap_ui = true,
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
          snacks = {
            enabled = true,
            indent_scope_color = "mocha",
          },
          mini = {
            enabled = true,
            indentscope_color = "mocha",
          },
        },
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-mocha",
    },
  }, 
}
