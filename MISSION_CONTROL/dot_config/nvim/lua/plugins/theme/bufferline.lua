return {
  {
    "akinsho/bufferline.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    opts = {
      options = {
        diagnostics_indicator = function(count, level)
          local icon = level:match("error") and " " or " "
          return " " .. icon .. count
        end,
        indicator = {
          style = "underline",
        },
        text_align = "center",
        max_name_length = 14,     -- Limit filename length
        tab_size = 14,            -- Reduce tab width (default is 18)
        truncate_names = true,    -- Enable truncation of long filenames
        enforce_regular_tabs = true, -- Make all tabs the same width
      },
    },
  },
}
