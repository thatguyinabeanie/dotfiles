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
    config = function()
      -- Configuration options for molten-nvim
      vim.g.molten_auto_open_output = false
      vim.g.molten_output_win_size = 15
    end,
  },
  {
    "quarto-dev/quarto-nvim",
    dependencies = { "jmbuhr/otter.nvim" },
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
}
