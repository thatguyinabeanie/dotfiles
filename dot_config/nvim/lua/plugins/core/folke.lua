return {
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      presets = {
        inc_rename = true,
        lsp_doc_border = true,
      },
    },
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      -- Core features
      bigfile = { enabled = true },
      dim = { enabled = true },
      gitbrowse = { enabled = true },
      image = { enabled = true },
      input = { enabled = true },
      lazygit = {
        enabled = true,
        win = {
          border = "rounded",
        },
      },
      notifier = { enabled = true },
      picker = {
        enabled = true,
        ui_select = true,
        exclude = {
          ".DS_Store",
        },
        layout = {
          preset = "default",
          cycle = true,
        },
        sources = {
          files = {
            hidden = true,
          },
        },
      },
      quickfile = { enabled = true },
      rename = { enabled = true },
      scope = { enabled = true },
      scratch = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = { enabled = true },
      terminal = { enabled = true },
      words = { enabled = true },
      zen = { enabled = true },

      -- Dashboard configuration
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
          keys = { -- File Operations
            {
              icon = "󰈞 ",
              key = "f",
              desc = "Find File",
              action = function()
                Snacks.picker.files()
              end,
            }, -- Search Operations
            {
              icon = "󰊄 ",
              key = "/",
              desc = "Grep",
              action = function()
                Snacks.picker.grep()
              end,
            }, -- Configuration
            {
              icon = "󰒓 ",
              key = "c",
              desc = "chezmoi.toml",
              action = function()
                require("utils.chezmoi").open_config_toml()
              end,
            }, -- Package Management
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
            }, -- Exit
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
