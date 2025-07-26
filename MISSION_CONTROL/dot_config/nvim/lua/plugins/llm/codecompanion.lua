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
        chat = {
          adapter = {
            name = "copilot",
            model = "claude-sonnet-4",
          },
        },
        inline = {
          adapter = {
            name = "copilot", 
            model = "claude-sonnet-4",
          },
        },
        agent = {
          adapter = {
            name = "copilot",
            model = "claude-sonnet-4", 
          },
        },
      },
      -- Enable logging for debugging
      opts = {
        log_level = "INFO",
      },
      -- Display configuration
      display = {
        chat = {
          window = {
            layout = "vertical", -- vertical split instead of float
            width = 0.4,
            height = 0.8,
          },
        },
      },
    },
    keys = {
      { "<leader>ao", "<cmd>CodeCompanionChat<cr>", desc = "Code Companion Open Chat" },
      { "<leader>as", "<cmd>CodeCompanionActions<cr>", desc = "Code Companion Actions" },
      { "<leader>at", "<cmd>CodeCompanionChat Toggle<cr>", desc = "Code Companion Toggle Chat" },
      -- Visual mode mappings
      { "<leader>ao", "<cmd>CodeCompanionChat<cr>", mode = "v", desc = "Code Companion Open Chat" },
      { "<leader>as", "<cmd>CodeCompanionActions<cr>", mode = "v", desc = "Code Companion Actions" },
    }
  },
}
