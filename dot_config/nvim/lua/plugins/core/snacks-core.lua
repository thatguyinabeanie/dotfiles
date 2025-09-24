return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = { enabled = true },
      dim = { enabled = true }, -- Focus mode by dimming inactive code
      gitbrowse = { enabled = true },
       image = { enabled = false }, -- Disable image support to avoid potential issues
      input = { enabled = true },
      lazygit = {
        enabled = true,
        win = {
          border = "rounded",
        },
      },
      notifier = { enabled = true },
        picker = {
          enabled = false, -- Temporarily disable to test if this causes the freeze
          ui_select = true, -- Enable vim.ui.select override
          exclude = { -- add folder names here to exclude
            ".DS_Store",
          },
          layout = {
            preset = "default", -- Force default layout (horizontal with floating preview)
            cycle = false,
          },
          sources = {
            files = {
              hidden = false, -- Start with hidden files off to avoid scanning issues
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
