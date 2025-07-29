-- Simplified render-markdown configuration for transparent code blocks
return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      file_types = { "markdown", "Avante" },
      latex = { enabled = false }, -- Disable latex support to avoid latex2text warning
      code = {
        style = "language", -- Built-in style: disable_background = true, inline = false
      },
    },
    ft = { "markdown", "Avante" },
  },
}
