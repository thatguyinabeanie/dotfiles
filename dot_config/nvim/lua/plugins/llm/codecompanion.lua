-- https://codecompanion.olimorris.dev/

return {
  {
    "olimorris/codecompanion.nvim",
    opts = {
      llm = {
        provider = "copilot",
        model = "claude-3-sonnet-20240229",
      }
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "zbirenbaum/copilot.lua",
    },
  },
}
