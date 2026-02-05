-- Override render-markdown.nvim to disable code block backgrounds
-- This allows the terminal/Neovim transparent background to show through
return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      code = {
        -- Disable background for all languages to allow transparency
        disable_background = true,
      },
    },
  },
}
