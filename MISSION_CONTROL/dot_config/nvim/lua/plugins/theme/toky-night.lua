-- Disable indent-blankline in favor of Snacks.indent
return {
  {
    "folke/tokyonight.nvim",
    optional = true,
    opts = function(_, opts)
      -- Set up highlight groups that are compatible with both systems
      opts.on_highlights = function(hl, c)
        -- Indent guide highlights (dimmer)
        hl.IblIndent = { fg = c.bg_highlight }
        hl.IblWhitespace = { fg = c.bg_highlight }
        -- Scope highlight (more prominent)
        hl.IblScope = { fg = c.blue1 }
      end
    end,
  },
}
