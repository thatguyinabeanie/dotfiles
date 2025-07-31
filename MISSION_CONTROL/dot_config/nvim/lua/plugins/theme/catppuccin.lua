return {
  {
    "catppuccin/nvim",
    lazy = false,
    name = "catppuccin",
    opts = {
      flavour = "mocha",
      background = {
        light = "latte",
        dark = "mocha",
      },
      transparent_background = true,
      default_integrations = true,
      show_end_of_buffer = true,
      term_colors = true,
      dim_inactive = { enabled = false },
      no_italic = false,
      no_bold = false,
      no_underline = false,
      styles = {
        comments = { "italic" },
        conditionals = { "italic" },
      },
      custom_highlights = function(colors)
        return {
          -- Indent guide highlights (referenced by indent-blankline.lua)
          IndentLevel1 = { fg = "#3C4C5A" }, -- Muted blue-gray
          IndentLevel2 = { fg = "#3C5A4C" }, -- Muted green-gray
          IndentLevel3 = { fg = "#5A5A3C" }, -- Muted yellow-gray
          IndentLevel4 = { fg = "#5A4C3C" }, -- Muted orange-gray
          IndentLevel5 = { fg = "#4C3C5A" }, -- Muted purple-gray

          -- Chunk highlights (referenced by snacks.lua)
          ChunkLevel1 = { fg = colors.blue, bold = true },
          ChunkLevel2 = { fg = colors.green, bold = true },
          ChunkLevel3 = { fg = colors.yellow, bold = true },
          ChunkLevel4 = { fg = colors.peach, bold = true },
          ChunkLevel5 = { fg = colors.mauve, bold = true },
        }
      end,
    },
  },
}
