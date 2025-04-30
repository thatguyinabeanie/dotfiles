return {
  "epwalsh/obsidian.nvim",
  version = "*",
  lazy = true,
  enabled = true,
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    workspaces = {
      {
        path = "~/.config/obsidian/obsidian-vault"
      },
    },
    daily_notes = {
      folder = "daily",
      date_format = "%Y-%m-%d",
      template = nil,
    },
    new_notes_location = "current_dir",
    note_id_func = function(title)
      return title
    end,
    follow_url_func = function(url)
      vim.fn.system({"open", url})
    end,
  },
  -- keys = {
  --   { "n", "<leader>On", "<cmd>ObsidianNew<cr>",          { desc = "New Obsidian Note" } },
  --   { "n", "<leader>Oo", "<cmd>ObsidianOpen<cr>",         { desc = "Open in Obsidian App" } },
  --   { "n", "<leader>Of", "<cmd>ObsidianFollowLink<cr>",   { desc = "Follow Link Under Cursor" } },
  --   { "n", "<leader>Ob", "<cmd>ObsidianBacklinks<cr>",    { desc = "Show Backlinks" } },
  --   { "n", "<leader>Ot", "<cmd>ObsidianToday<cr>",        { desc = "Open Today's Note" } },
  --   { "n", "<leader>Oy", "<cmd>ObsidianYesterday<cr>",    { desc = "Open Yesterday's Note" } },
  --   { "n", "<leader>Om", "<cmd>ObsidianTomorrow<cr>",     { desc = "Open Tomorrow's Note" } },
  --   { "n", "<leader>Os", "<cmd>ObsidianSearch<cr>",       { desc = "Search in Vault" } },
  --   { "n", "<leader>Ol", "<cmd>ObsidianLink<cr>",         { desc = "Create Link" } },
  --   { "n", "<leader>OL", "<cmd>ObsidianLinkNew<cr>",      { desc = "Create Link to New Note" } },
  --   { "v", "<leader>Ol", "<cmd>ObsidianLink<cr>",         { desc = "Create Link from Selection" } },
  --   { "v", "<leader>OL", "<cmd>ObsidianLinkNew<cr>",      { desc = "Create Link to New Note from Selection" } },
  --   { "n", "<leader>Op", "<cmd>ObsidianPasteImg<cr>",     { desc = "Paste Image from Clipboard" } },
  --   { "n", "<leader>Or", "<cmd>ObsidianRename<cr>",       { desc = "Rename Note" } },
  --   { "n", "<leader>Oq", "<cmd>ObsidianQuickSwitch<cr>",  { desc = "Quick Switch" } },
  -- }
}
