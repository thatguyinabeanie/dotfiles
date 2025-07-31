return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = { 
      indent = {
        enabled = true,
        only_scope = true, -- Only show chunks, not regular indent guides
        scope = { enabled = false }, -- Disable scope to avoid conflict
        chunk = {
          enabled = true,
          char = {
            corner_top = "╭",
            corner_bottom = "╰",
            horizontal = "─",
            vertical = "│",
            arrow = ">",
          },
          hl = {
            "ChunkLevel1",
            "ChunkLevel2",
            "ChunkLevel3",
            "ChunkLevel4",
            "ChunkLevel5",
          },
        },
        filter = function(buf)
          return vim.g.snacks_indent ~= false and vim.b[buf].snacks_indent ~= false and vim.bo[buf].buftype == ""
        end,
      },
    },
  },
}
