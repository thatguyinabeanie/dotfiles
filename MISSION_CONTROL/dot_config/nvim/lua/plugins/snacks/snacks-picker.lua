return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
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
    },
  },
}
