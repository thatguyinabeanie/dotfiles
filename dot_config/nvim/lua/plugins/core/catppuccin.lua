return {
  {
    "catppuccin/nvim",
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
      -- Improve contrast for dimmed/ignored files in Snacks Explorer
      -- Default overlay0 is too hard to read with transparent backgrounds
      custom_highlights = function(colors)
        return {
          SnacksPickerPathIgnored = { fg = colors.overlay2 },
          SnacksPickerPathHidden = { fg = colors.overlay2 },
          SnacksPickerGitStatusIgnored = { fg = colors.overlay2 },
        }
      end,
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
        neogit = true,
        gitsigns = true,
        snacks = {
          enabled = true,
        },
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
        -- Features
        semantic_tokens = true,
        flash = true,
        markdown = true,
        render_markdown = true,
        bufferline = true,
        cmp = false, -- Using blink_cmp
        dap = true, -- Load when debugging
        dap_ui = true, -- Load when debugging
        indent_blankline = {
          enabled = true,
        },
      },
    },
  },
}
