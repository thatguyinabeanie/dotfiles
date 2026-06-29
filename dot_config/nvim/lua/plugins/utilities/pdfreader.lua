-- In-terminal PDF viewing: renders PDF pages via snacks.nvim image + Kitty graphics protocol
-- Opening any .pdf (:e file.pdf) triggers the plugin's BufReadCmd automatically.
-- Keys in a PDF buffer: n/p next/prev page, z/q zoom in/out, e reset zoom.
return {
  "r-pletnev/pdfreader.nvim",
  lazy = false, -- registers the .pdf BufReadCmd at startup (per upstream docs)
  dependencies = {
    "folke/snacks.nvim", -- image rendering (already configured in core/folke.lua)
  },
  opts = {}, -- lazy.nvim calls require("pdfreader").setup({})
}
