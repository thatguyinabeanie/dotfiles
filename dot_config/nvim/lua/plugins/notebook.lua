return {
  {
    "GCBallesteros/jupytext.nvim",
    lazy = false,
    init = function()
      vim.g.jupytext_fmt = "qmd"
    end,
    config = function()
      require("jupytext").setup({
        -- notebook_filetypes = { "quarto", "markdown" }, -- Its not needed to be configured unless you want to add more filetypes
        -- extra_filetypes = {},
      })
    end,
  },
  {
    "benlubas/molten-nvim",
    dependencies = { "3rd/image.nvim" },
    ft = { "quarto", "markdown", "python" },
    init = function()
      vim.g.molten_image_provider = "image.nvim"
      vim.g.molten_output_win_max_height = 20
    end,
    opts = {
      -- your options here
      -- for example:
      -- auto_open_output = false,
      -- output_win_size = 15,
    },
  },
  {
    "quarto-dev/quarto-nvim",
    ft = { "quarto", "markdown" },
    config = function()
      require("quarto").setup({
        lspFeatures = {
          -- languages = { "r", "python", "julia" },
          chunks = "all",
          diagnostics = {
            enabled = true,
            triggers = { "BufWritePost", "InsertLeave" },
          },
          completion = {
            enabled = true,
          },
        },
      })
    end,
  },
  {
    "3rd/image.nvim",
    ft = { "quarto", "markdown" },
    opts = {
      backend = "ueberzug",
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          filetypes = { "markdown", "quarto" }, -- markdown extensions are supported!
        },
        neorg = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          filetypes = { "norg" },
        },
      },
      -- five_second_timer = true,
      max_width = 25,
      max_height = 12,
      max_width_window_percentage = 100,
      max_height_window_percentage = 100,
      -- window_overlap_clear_enabled = true, -- toggles images when windows are overlapped
      -- window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
    },
  },
}
