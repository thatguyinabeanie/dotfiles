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
      }, -- LazyGit integration      notifier = { enabled = true },
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
