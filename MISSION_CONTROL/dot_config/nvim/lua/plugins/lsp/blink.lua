return {
  {
    "saghen/blink.cmp",
    lazy = false,
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

      cmdline = { sources = { "cmdline" } },
      sources = {
        default = { "lsp", "path", "buffer", "copilot" },
        providers = {
          copilot = {
            name = "copilot",
            module = "blink-cmp-copilot",
            score_offset = 100,
            async = true,
          },
        },
      },
    },
  },
}
