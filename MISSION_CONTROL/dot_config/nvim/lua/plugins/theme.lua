return {
  {
    "catppuccin/nvim",
    lazy = false,
    name = "catppuccin",
    opts = {
      transparent_background = true,
      flavour = "mocha",
      background = {
        light = "latte",
        dark = "mocha",
      },
      show_end_of_buffer = false,
      term_colors = true,
      dim_inactive = {
        enabled = false,
        shade = "dark",
        percentage = 0.15,
      },
      no_italic = false,
      no_bold = false,
      no_underline = false,
      styles = {
        comments = { "italic" },
        conditionals = { "italic" },
      },
      custom_highlights = function(colors)
        return {
          -- Improve floating window visibility
          NormalFloat = { bg = colors.mantle },
          FloatBorder = { fg = colors.blue, bg = colors.mantle },
          FloatTitle = { fg = colors.blue, bg = colors.mantle },

          -- Make documentation more readable
          TelescopeNormal = { bg = colors.mantle },
          TelescopeBorder = { fg = colors.blue, bg = colors.mantle },
          TelescopePromptNormal = { bg = colors.surface0 },
          TelescopePromptBorder = { fg = colors.blue, bg = colors.surface0 },
          TelescopePromptTitle = { fg = colors.blue, bg = colors.surface0 },
          TelescopePreviewTitle = { fg = colors.blue, bg = colors.mantle },
          TelescopeResultsTitle = { fg = colors.blue, bg = colors.mantle },

          -- Improve popup menu visibility
          Pmenu = { bg = colors.mantle },
          PmenuSel = { bg = colors.surface0, fg = colors.text },
          PmenuSbar = { bg = colors.surface0 },
          PmenuThumb = { bg = colors.overlay0 },

          -- Improve completion menu visibility
          CmpItemAbbrMatch = { fg = colors.blue, style = { "bold" } },
          CmpItemAbbrMatchFuzzy = { fg = colors.blue, style = { "bold" } },
          CmpItemMenu = { fg = colors.text },
        }
      end,
      default_integrations = true,
      integrations = {
        cmp = true,
        neogit = true,
        blink_cmp = true,
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
            ok = { "italic" },
          },
          ufo = true,
          treesitter = true,
          treesitter_context = true,
          dap = true,
          dap_ui = true,
          underlines = {
            errors = { "underline" },
            hints = { "underline" },
            warnings = { "underline" },
            information = { "underline" },
            ok = { "underline" },
          },
          inlay_hints = {
            background = true,
          },
          snacks = {
            enabled = true,
            indent_scope_color = "mocha",
          },
          mini = {
            enabled = true,
            indentscope_color = "mocha",
          },
        },
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-mocha",
    },
  },
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
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    opts = function(_, opts)
      table.insert(opts.sections.lualine_x, function()
        return "👻"
      end)

      opts.sections = {
        lualine_a = { "mode" },
        lualine_b = {
          "branch",
          "diff",
          {
            "diagnostics",
            sources = { "nvim_diagnostic" },
            symbols = { error = " ", warn = " ", info = " ", hint = " " },
          },
        },
        lualine_c = { "filename", "searchcount", "selectioncount" },
        lualine_x = { "lsp_status", "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      }

      opts.options = {
        icons_enabled = true,
        theme = "auto",
        disabled_filetypes = {
          winbar = {},
        },
        refresh = {
          statusline = 500,
          tabline = 500,
          winbar = 500,
        },
      }
    end,
  },
}
