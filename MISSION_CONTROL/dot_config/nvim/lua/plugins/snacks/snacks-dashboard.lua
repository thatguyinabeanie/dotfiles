return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      dashboard = {
        enabled = true,
        width = 60,
        height = 20,
        sections = {
          {
            section = "header",
          },
          {
            section = "keys",
            gap = 1,
            padding = 1,
          },
          {
            section = "startup",
            gap = 1,
            padding = 1,
          },
        },
        preset = {
          keys = {
            -- File Operations
            {
              icon = "󰈞 ",
              key = "f",
              desc = "Find File",
              action = function()
                Snacks.picker.files()
              end,
            },
            {
              icon = "󰄉 ",
              key = "r",
              desc = "Recent Files",
              action = function()
                Snacks.picker.recent()
              end,
            },
            {
              icon = "󰝒 ",
              key = "n",
              desc = "New File",
              action = ":ene | startinsert",
            },
            -- Search Operations
            {
              icon = "󰊄 ",
              key = "/",
              desc = "Find Text",
              action = function()
                Snacks.picker.grep()
              end,
            },
            -- Project Management  
            {
              icon = "󰉋 ",
              key = "p",
              desc = "Projects",
              action = function()
                Snacks.picker.projects()
              end,
            },
            -- Configuration
            {
              icon = "󰒓 ",
              key = "c",
              desc = "Config",
              action = function()
                Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
              end,
            },
            {
              icon = "󰒲 ",
              key = "l",
              desc = "Lazy",
              action = ":Lazy",
            },
            -- Git Operations
            {
              icon = "󰊢 ",
              key = "G",
              desc = "Git Status",
              action = function()
                Snacks.lazygit()
              end,
            },
            -- Terminal & Exit
            {
              icon = "󰆍 ",
              key = "t",
              desc = "Terminal",
              action = function()
                Snacks.terminal()
              end,
            },
            {
              icon = "󰅚 ",
              key = "q",
              desc = "Quit",
              action = ":qa",
            },
          },
        },
      },





    },
  },
}
