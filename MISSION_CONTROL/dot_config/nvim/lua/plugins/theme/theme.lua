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
      default_integrations = true,
      integrations = {
        -- Essential integrations
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
        },
        treesitter = true,
        treesitter_context = true,
        ufo = true,
        -- Git
        neogit = true,
        gitsigns = true,
        -- UI
        snacks = true,
        mini = {
          enabled = true,
          indentscope_color = "", -- Disabled, using Snacks scope
        },
        telescope = {
          enabled = true,
          style = "nvchad",
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
        cmp = false, -- Using blink_cmp
        dap = false, -- Load when debugging
        dap_ui = false, -- Load when debugging
        indent_blankline = {
          enabled = false, -- Using Snacks indent/scope
          scope_color = "",
          colored_indent_levels = false,
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
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    opts = function(_, opts)
      table.insert(opts.sections.lualine_x, function()
        return "👻"
      end)

      opts.sections = {
        lualine_a = {
          {
            "mode",
            fmt = function(str)
              return str:sub(1, 1)
            end,
          },
        },
        lualine_b = {
          { "branch", icon = "" },
          {
            "diff",
            symbols = { added = " ", modified = " ", removed = " " },
            diff_color = {
              added = { fg = "#a6e3a1" },
              modified = { fg = "#f9e2af" },
              removed = { fg = "#f38ba8" },
            },
          },
          {
            "diagnostics",
            sources = { "nvim_diagnostic" },
            symbols = { error = " ", warn = " ", info = " ", hint = " " },
            always_visible = false,
          },
        },
        lualine_c = {
          {
            "filename",
            path = 1,
            symbols = {
              modified = "●",
              readonly = "",
              unnamed = "[No Name]",
              newfile = "[New]",
            },
          },
          { "searchcount", icon = "" },
          { "selectioncount", icon = "󰒅" },
        },
        lualine_x = {
          {
            function()
              -- Safely try to get pipeline status
              local ok, pipeline = pcall(require, "pipeline")
              if ok and type(pipeline) == "table" and type(pipeline.get_status) == "function" then
                local status_ok, status = pcall(pipeline.get_status)
                if status_ok and status then
                  return status
                end
              end
              return ""
            end,
            icon = "",
            cond = function()
              -- Only show if pipeline is loaded and properly initialized
              if package.loaded["pipeline"] ~= nil then
                local pipeline = package.loaded["pipeline"]
                return type(pipeline) == "table" and type(pipeline.get_status) == "function"
              end
              return false
            end,
          },
          {
            function()
              local msg = "No Active Lsp"
              local buf_ft = vim.api.nvim_get_option_value("filetype", { buf = 0 })
              local clients = vim.lsp.get_active_clients()
              if next(clients) == nil then
                return msg
              end
              for _, client in ipairs(clients) do
                local filetypes = client.config.filetypes
                if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                  return client.name
                end
              end
              return msg
            end,
            icon = " LSP:",
            color = { fg = "#89b4fa" },
          },
          { "encoding", icon = "󰉿" },
          { "fileformat", icon = "" },
          { "filetype", icon = "" },
          require('mcphub.extensions.lualine'),
        },
        lualine_y = {
          { "progress", icon = "󰦨", separator = " ", padding = { left = 1, right = 0 } },
          { "location", icon = "", padding = { left = 0, right = 1 } },
        },
        lualine_z = {
          function()
            return " " .. os.date("%R")
          end,
        },
      }

      opts.options = {
        icons_enabled = true,
        theme = "auto",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = {
          statusline = { "dashboard", "alpha", "starter" },
          winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = true,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        },
      }
    end,
  },
  {
    "f-person/auto-dark-mode.nvim",
    opts = {
      update_interval = 1000,
      set_dark_mode = function()
        vim.o.background = "dark"
        vim.cmd("colorscheme catppuccin-mocha")
      end,
      set_light_mode = function()
        vim.o.background = "light"
        vim.cmd("colorscheme catppuccin-latte")
      end,
      fallback = "dark",
    },
  },
}
