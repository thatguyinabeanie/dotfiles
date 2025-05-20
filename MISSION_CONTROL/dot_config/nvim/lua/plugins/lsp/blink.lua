return {
  {
    "saghen/blink.cmp",
    lazy = false,
    version = "*",
    opts = {
      keymap = {
        preset = "enter",
        ["<S-Tab>"] = { "select_prev", "fallback" },
        ["<Tab>"] = { "select_next", "fallback" },
      },

      cmdline = { sources = { "cmdline" } },
      sources = {
        default = { "lsp", "path", "luasnip", "buffer", "codecompanion" },
      },
    },
  },
}
