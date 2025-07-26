if true then return {} end

local plugin_dir = vim.fn.expand("~/source/todo-mcp.nvim")

-- Only load if the local development directory exists
if vim.fn.isdirectory(plugin_dir) == 1 then
  return {
    -- "thatguyinabeanie/todo-mcp.nvim",
    dir = plugin_dir,
    branch = "main",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "kkharji/sqlite.lua",
    },
    cmd = "TodoMCP",
    keys = {
      { "<leader>Td", "<cmd>TodoMCP<cr>", desc = "Todo List" },
      { "<leader>Ta", function() 
          vim.ui.input({ prompt = "Todo: " }, function(input)
            if input then
              require("todo-mcp").add(input)
              vim.notify("Todo added", vim.log.levels.INFO)
            end
          end)
        end, 
        desc = "Add Todo" 
      },
    },
    opts = {
      -- Everything else uses smart defaults
    },
  }
else
  -- Return empty table if directory doesn't exist (CI environment)
  return {}
end
