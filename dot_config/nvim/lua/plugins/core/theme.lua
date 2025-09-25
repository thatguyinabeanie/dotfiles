return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    -- Override LazyVim's problematic colorscheme integration
    config = function(_, opts)
      require("catppuccin").setup(opts)
      -- Create the missing module by redirecting to the correct catppuccin bufferline special
      package.preload["catppuccin.groups.integrations.bufferline"] = function()
        local special_bufferline = require("catppuccin.special.bufferline")
        return {
          get = special_bufferline.get_theme or function()
            return special_bufferline.get()
          end,
          get_theme = special_bufferline.get_theme or special_bufferline.get,
        }
      end
    end,
    opts = {
      flavour = "mocha",
      background = {
        light = "latte",
        dark = "mocha",
      },
      transparent_background = true,
      float = {
        transparent = true, -- enable transparent floating windows
      },
      show_end_of_buffer = true,
      term_colors = true,
      dim_inactive = {
        enabled = false,
      },
      no_italic = false,
      no_bold = false,
      no_underline = false,
      styles = {
        comments = { "italic" },
        conditionals = { "italic" },
      },
      default_integrations = true,
      integrations = {
        -- Essential integrations
        blink_cmp = {
          enabled = true,
          style = "bordered",
        },
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = { "italic", "bold" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
            ok = { "italic" },
          },
          underlines = {
            errors = { "undercurl" },
            hints = { "underdotted" },
            warnings = { "underdashed" },
            information = { "underline" },
            ok = { "underline" },
          },
          inlay_hints = {
            background = true,
          },
        },
        treesitter = true,
        treesitter_context = true,
        neogit = true,
        gitsigns = true,
        snacks = {
          enabled = true,
        },
        mini = {
          enabled = true,
          -- indentscope_color = "", -- Disabled, using Snacks scope
        },
        telescope = {
          enabled = true,
        },
        which_key = true,
        mason = true,
        noice = true,
        notify = true,
        -- Features
        semantic_tokens = true,
        flash = true,
        markdown = true,
        render_markdown = true,
        -- Disabled
        bufferline = false, -- Disable to avoid LazyVim integration conflicts
        cmp = false, -- Using blink_cmp
        dap = true, -- Load when debugging
        dap_ui = true, -- Load when debugging
        indent_blankline = {
          enabled = true,
        },
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
