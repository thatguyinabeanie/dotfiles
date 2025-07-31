if true then return {} end

-- Check work environment from environment variable
local is_work = os.getenv("WORK_ENVIRONMENT") == "true"

return {
  "epwalsh/obsidian.nvim",
  event = {
    "BufReadPre " .. vim.fn.expand("~") .. "/source/obsidian/**.md",
    "BufNewFile " .. vim.fn.expand("~") .. "/source/obsidian/**.md",
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    workspaces = {
      {
        name = "vault",
        path = is_work and "~/source/obsidian/obsidian-vault-work" or "~/source/obsidian/obsidian-vault",
      },
    },
    daily_notes = {
      folder = "daily",
      date_format = "%Y-%m-%d",
    },
    note_id_func = function(title)
      return title
    end,
    follow_url_func = function(url)
      vim.fn.system({"open", url})
    end,
    templates = {
      folder = "templates",
      date_format = "%Y-%m-%d",
      time_format = "%H:%M",
    },
    ui = {
      enable = false, -- Disable UI to avoid conflicts with render-markdown
    },
  },
  keys = is_work and {
    { "n", "<leader>Oww", "<cmd>ObsidianWorkspace work<cr>", { desc = "Switch to Work Workspace" } },
  } or {},
}
