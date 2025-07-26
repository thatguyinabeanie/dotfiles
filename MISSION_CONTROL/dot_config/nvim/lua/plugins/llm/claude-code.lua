local plugin_dir = vim.fn.expand("~/source/claude-code.nvim")

-- Only load if the local development directory exists
if vim.fn.isdirectory(plugin_dir) == 1 then
  return {
    dir = plugin_dir,
    name = "claude-code.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require('claude-code').setup()
    end,
  }
else
  -- Return empty table if directory doesn't exist (CI environment)
  return {}
end