-- Minimal lualine configuration for use with Zellij
-- Shows only essential information to complement Zellij's status bar

return {
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      local icons = require("lazyvim.config").icons

      -- Ultra-minimal sections
      opts.sections = {
        -- Left side: Mode (icon) | Filename | Diagnostics
        lualine_a = {
          {
            "mode",
            fmt = function(str)
              -- Show only first letter
              return str:sub(1, 1)
            end,
          },
        },
        lualine_b = {
          {
            "filename",
            path = 1, -- Relative path
            symbols = {
              modified = " ●",
              readonly = " ",
              unnamed = "[No Name]",
            },
          },
        },
        lualine_c = {
          {
            "diagnostics",
            symbols = {
              error = icons.diagnostics.Error,
              warn = icons.diagnostics.Warn,
              info = icons.diagnostics.Info,
              hint = icons.diagnostics.Hint,
            },
          },
        },

        -- Right side: LSP (icon only) | Git branch
        lualine_x = {
          {
            function()
              local buf_clients = vim.lsp.get_clients({ bufnr = 0 })
              if #buf_clients == 0 then
                return ""
              end
              -- Show LSP icon only
              return ""
            end,
          },
        },
        lualine_y = {
          {
            "branch",
            icon = "",
          },
        },
        lualine_z = {
          -- Empty - no location info for minimalism
        },
      }

      -- Minimal inactive sections
      opts.inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      }

      -- Minimal styling
      opts.options = vim.tbl_deep_extend("force", opts.options or {}, {
        theme = "catppuccin",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
      })

      return opts
    end,
  },
}
