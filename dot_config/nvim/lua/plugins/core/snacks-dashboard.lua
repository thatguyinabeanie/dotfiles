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
            -- Project Management
            {
              icon = "󰉋 ",
              key = "p",
              desc = "Projects",
              action = function()
                Snacks.picker.projects()
              end,
            },
            -- File Operations
            {
              icon = "󰈞 ",
              key = "f",
              desc = "Find File",
              action = function()
                Snacks.picker.files()
              end,
            },
            -- Search Operations
            {
              icon = "󰊄 ",
              key = "/",
              desc = "Grep",
              action = function()
                Snacks.picker.grep()
              end,
            },
            -- {
            --   icon = "󰄉 ",
            --   key = "r",
            --   desc = "Recent Files",
            --   action = function()
            --     Snacks.picker.recent()
            --   end,
            -- },
            -- Configuration
            {
              icon = "󰒓 ",
              key = "c",
              desc = "chezmoi.toml",
              action = function()
                require("utils.chezmoi").open_config_toml()
              end,
            },
            -- Package Management
            {
              icon = "󰒲 ",
              key = "l",
              desc = "Lazy",
              action = ":Lazy",
            },
            {
              icon = "󰏗 ",
              key = "x",
              desc = "Lazy Extras",
              action = ":LazyExtras",
            },
            -- Exit
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
