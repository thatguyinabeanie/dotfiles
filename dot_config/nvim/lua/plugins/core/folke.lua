return {
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      presets = {
        inc_rename = true, -- Enables an input dialog for inc-rename.nvim
        lsp_doc_border = true, -- Add a border to hover docs and signature help
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
      dim = { enabled = true }, -- Focus mode by dimming inactive code
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
        ui_select = true, -- Enable vim.ui.select override
        exclude = { -- add folder names here to exclude
          ".DS_Store",
        },
        layout = {
          preset = "default", -- Force default layout (horizontal with floating preview)
          cycle = true,
        },
        sources = {
          files = {
            hidden = true, -- Start with hidden files off to avoid scanning issues
          },
        },
      },
      quickfile = { enabled = true },
      rename = { enabled = true }, -- LSP file renaming with plugin integration
      scope = { enabled = true },
      scratch = { enabled = true }, -- Persistent scratch buffers
      scroll = { enabled = true }, -- Enable scroll animations
      statuscolumn = { enabled = true },
      terminal = { enabled = true }, -- Floating/split terminals
      words = { enabled = true }, -- Keep for word highlighting under cursor
      zen = { enabled = true }, -- Distraction-free coding mode

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
