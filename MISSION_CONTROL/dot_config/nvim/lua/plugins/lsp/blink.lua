return {
  {
    "saghen/blink.cmp",
    event = "InsertEnter",
    version = "*",
    dependencies = {
      "giuxtaposition/blink-cmp-copilot",
    },
    opts = {
      keymap = {
        preset = "enter",
        ["<S-Tab>"] = { "select_prev", "fallback" },
        ["<Tab>"] = { "select_next", "fallback" },
      },
      
      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = 'mono'
      },

      sources = {
        default = { "lsp", "path", "snippets", "buffer", "copilot" },
        cmdline = { "cmdline" },
        providers = {
          copilot = {
            name = "copilot",
            module = "blink-cmp-copilot",
            score_offset = 100,
            async = true,
          },
        },
      },
      
      completion = {
        accept = {
          auto_brackets = {
            enabled = true,
          },
        },
        menu = {
          draw = {
            treesitter = { "lsp" },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
        },
      },
    },
  },
}
