return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = { enabled = true },
      dashboard = { enabled = true },
      gitbrowse = { enabled = true },
      image = { enabled = true },
      indent = { enabled = true },
      input = { enabled = true },
      notifier = { enabled = true },
      picker = {
        enabled = true,
        exclude = { -- add folder names here to exclude
          ".git",
          "node_modules",
        },
        sources = {
          explorer = {
            auto_close = false,
            hidden = true,
            ignored = true,
            follow = true,
          },
        },
      },
      quickfile = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = false },
      statuscolumn = { enabled = true },
      words = { enabled = true },
    },
    -- Override LazyVim's default keymaps to use cwd instead of root
    keys = {
      { "<leader>ff", function() Snacks.picker.files({ cwd = vim.fn.getcwd() }) end, desc = "Find Files (cwd)" },
      { "<leader><space>", function() Snacks.picker.files({ cwd = vim.fn.getcwd() }) end, desc = "Find Files (cwd)" },
      { "<leader>fF", function() Snacks.picker.files({ cwd = LazyVim.root() }) end, desc = "Find Files (root)" },
    },
  },
  {
    "folke/trouble.nvim",
    opts = { use_diagnostic_signs = true },
  },
}
