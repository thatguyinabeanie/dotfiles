-- Lualine configuration with filetype display
return {
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      -- Ensure sections exist
      opts.sections = opts.sections or {}
      opts.sections.lualine_c = opts.sections.lualine_c or {}

      -- Add filetype to the left side after filename (lualine_c)
      -- Display as text only (icon already shown by filename component)
      table.insert(opts.sections.lualine_c, {
        "filetype",
        icon_only = false,
        colored = true,
      })

      return opts
    end,
  },
}
