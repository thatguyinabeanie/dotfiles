return {
  {
    "catppuccin/nvim",
    lazy = false,
    name = "catppuccin",
    opts = {
      integrations = {
        -- Essential integrations
        blink_cmp = {
          enabled = true,
          style = 'bordered',
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
        snacks = true,
        mini = {
          enabled = true,
          indentscope_color = "", -- Disabled, using Snacks scope
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
          enabled = false, -- Using Snacks indent/scope
        },
      },
    },
  }
}