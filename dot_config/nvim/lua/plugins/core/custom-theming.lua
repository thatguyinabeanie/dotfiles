if true then
  return {}
end
return {
  -- {
  --   "shortcuts/no-neck-pain.nvim",
  --   version = "*",
  -- },
  -- {
  --   "rachartier/tiny-inline-diagnostic.nvim",
  --   config = function()
  --     require("tiny-inline-diagnostic").setup({
  --       preset = "modern",
  --     })
  --     vim.diagnostic.config({ virtual_text = false })
  --   end,
  -- },

  {
    "catppuccin/nvim",
    opts = {
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

  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      indent = {
        enabled = true,
        -- only_scope = true, -- Only show chunks, not regular indent guides
        scope = { enabled = true }, -- Disable scope to avoid conflict
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

  {
    "lukas-reineke/indent-blankline.nvim",
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
  },

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
