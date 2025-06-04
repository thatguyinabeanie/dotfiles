return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = { enabled = true },
      dashboard = { 
        enabled = true,
        -- Lazy load dashboard when needed
        preset = {
          keys = {
            { icon = " ", key = "f", desc = "Find File", action = function() Snacks.picker.files() end },
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "r", desc = "Recent Files", action = function() Snacks.picker.recent() end },
            { icon = " ", key = "g", desc = "Find Text", action = function() Snacks.picker.grep() end },
            { icon = " ", key = "c", desc = "Config", action = function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end },
            { icon = " ", key = "s", desc = "Restore Session", action = [[<cmd>lua require("persistence").load()<cr>]] },
            { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
      },
      gitbrowse = { 
        enabled = true,
        -- Only load when actually browsing
      },
      image = { enabled = false }, -- Disabled to reduce overhead
      indent = { 
        enabled = true,
        char = "│",
        animate = {
          enabled = false, -- Set to true if you want animations
        },
        scope = {
          enabled = true,
          char = "│",
          underline = true,
        },
        indent = {
          enabled = true,
          char = "│",
          hl = {
            "SnacksIndent1",
            "SnacksIndent2",
            "SnacksIndent3",
            "SnacksIndent4",
            "SnacksIndent5",
            "SnacksIndent6",
            "SnacksIndent7",
            "SnacksIndent8",
          }, -- Colored indent levels
        },
      },
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
      words = { enabled = true }, -- Keep for word highlighting under cursor
    },
    -- Override LazyVim's default keymaps to use cwd instead of root
    keys = {
      { "<leader>ff", function() Snacks.picker.files({ cwd = vim.fn.getcwd() }) end, desc = "Find Files (cwd)" },
      { "<leader><space>", function() Snacks.picker.files({ cwd = vim.fn.getcwd() }) end, desc = "Find Files (cwd)" },
      { "<leader>fF", function() Snacks.picker.files({ cwd = LazyVim.root() }) end, desc = "Find Files (root)" },
      -- Git browse keybindings (lazy loaded)
      { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git Browse" },
      { "<leader>gb", function() Snacks.gitbrowse() end, desc = "Git Browse", mode = "v" },
    },
  },
  {
    "folke/trouble.nvim",
    opts = { use_diagnostic_signs = true },
  },
}
