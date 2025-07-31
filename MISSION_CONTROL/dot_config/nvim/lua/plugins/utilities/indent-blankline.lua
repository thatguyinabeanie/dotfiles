return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  opts = {
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
  },
}
