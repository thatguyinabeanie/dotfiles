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
    lazy = true,
    cmd = { "CodeCompanion", "CodeCompanionActions", "CodeCompanionChat" },
    keys = {
      { "<leader>cc", "<cmd>CodeCompanionChat Toggle<cr>", desc = "CodeCompanion - Toggle Chat" },
      { "<leader>ca", "<cmd>CodeCompanionActions<cr>", desc = "CodeCompanion - Actions" },
    },
    opts = {
      strategies = {
        chat = { adapter = "copilot" },
        inline = { adapter = "copilot" },
        agent = { adapter = "copilot" },
      },
      adapters = {
        copilot = {
          -- Updated to use Claude Sonnet 4 through Copilot
          schema = {
            model = {
              default = "claude-sonnet-4-20250514", -- Claude Sonnet 4
            },
          },
        },
      },
      -- Enable logging for debugging
      log_level = "INFO", -- Change to "DEBUG" for more detailed logs
      -- Default display mode
      display = {
        chat = "float", -- Options: "float" or "buffer"
      },
    },
    keys = {
      { "<leader>ao", "<cmd>CodeCompanionChat<cr>", desc = "Code Companion Open Chat" },
      { "<leader>as", "<cmd>CodeCompanionActions<cr>", desc = "Code Companion Actions" },
      { "<leader>at", "<cmd>CodeCompanionToggle<cr>", desc = "Code Companion Toggle" },
      -- Visual mode mappings
      { "<leader>ao", "<cmd>CodeCompanionChat<cr>", mode = "v", desc = "Code Companion Open Chat" },
      { "<leader>as", "<cmd>CodeCompanionActions<cr>", mode = "v", desc = "Code Companion Actions" },
    }
  },
}
