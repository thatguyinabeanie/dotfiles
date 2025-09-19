return {
  "lukas-reineke/indent-blankline.nvim",
  dependencies = { "catppuccin" },
  dependencies = { "catppuccin" },
  event = "LazyFile",
  main = "ibl",
  opts = function()
    return {
      indent = {
        char = "│",
        highlight = {
          "IndentLevel1",
          "IndentLevel2", 
          "IndentLevel3",
          "IndentLevel4",
          "IndentLevel5",
        },
      },
      scope = {
        enabled = false, -- Let Snacks handle scope/chunks
      },
    }
  end,
  config = function(_, opts)
    require("ibl").setup(opts)
  end,
}
