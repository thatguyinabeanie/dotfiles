return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    opts = function(_, opts)
      table.insert(opts.sections.lualine_x, function()
        return "👻"
      end)

      opts.sections = {
        lualine_a = { "mode" },
        lualine_b = {
          "branch",
          "diff",
          {
            "diagnostics",
            sources = { "nvim_diagnostic" },
            symbols = { error = " ", warn = " ", info = " ", hint = " " },
          },
        },
        lualine_c = { "filename", "searchcount", "selectioncount" },
        lualine_x = { "lsp_status", "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      }

      opts.options = {
        icons_enabled = true,
        theme = "auto",
        disabled_filetypes = {
          winbar = {},
        },
        refresh = {
          statusline = 500,
          tabline = 500,
          winbar = 500,
        },
      }
    end,
  },
}
