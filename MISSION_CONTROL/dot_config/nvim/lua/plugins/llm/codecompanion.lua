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
    opts = {
      strategies = {
        chat = { adapter = "copilot" },
        inline = { adapter = "copilot" },
        agent = { adapter = "copilot" },
      },
      adapters = {
        copilot = {
          schema = {
            model = {
              default = "claude-3.5-sonnet", -- Use standard Claude model name
            },
          },
        },
      },
      -- Enable logging for debugging
      log_level = "INFO",
      -- Default display mode
      display = {
        chat = {
          window = {
            layout = "float", -- or "vertical", "horizontal"
          },
        },
      },
      -- Required window configuration
      window = {
        layout = "float",
        width = 0.4,
        height = 0.8,
        border = "rounded",
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
