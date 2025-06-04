-- return {
--     -- "thatguyinabeanie/claude-code.nvim",
--     dir = vim.fn.expand("~/source/claude-code.nvim"),
--     dependencies = {
--       "nvim-lua/plenary.nvim", -- Required for git operations
--     }
-- }
return {
    dir = vim.fn.expand("~/source/claude-code.nvim"),
    name = "claude-code.nvim",  -- Add explicit name
    lazy = false,  -- Load immediately
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require('claude-code').setup()
    end,
  }

