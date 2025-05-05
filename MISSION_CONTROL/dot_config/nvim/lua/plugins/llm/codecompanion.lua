-- https://codecompanion.olimorris.dev/

return {
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "zbirenbaum/copilot.lua",
      "saghen/blink.cmp",
    },
    opts = {
      llm = {
        provider = "copilot",
        model = "claude-3.7-sonnet",
      },
    },
  },
}
