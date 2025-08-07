return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = { enabled = true },
      dim = { enabled = true }, -- Focus mode by dimming inactive code
      gitbrowse = { enabled = true },
      image = { enabled = true }, -- Enable image support
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
        -- exclude = { -- add folder names here to exclude
        --   ".git",
        --   "node_modules",
        -- },
        layout = {
          preset = "default", -- Force default layout (horizontal with floating preview)
          cycle = true,
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
      rename = { enabled = true }, -- LSP file renaming with plugin integration
      scope = { enabled = true },
      scratch = { enabled = true }, -- Persistent scratch buffers
      scroll = { enabled = true }, -- Enable scroll animations
      statuscolumn = { enabled = true },
      terminal = { enabled = true }, -- Floating/split terminals
      words = { enabled = true }, -- Keep for word highlighting under cursor
      zen = { enabled = true }, -- Distraction-free coding mode
    },
  },
}
