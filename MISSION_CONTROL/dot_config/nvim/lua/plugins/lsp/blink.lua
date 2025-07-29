return {
  {
    "saghen/blink.cmp",
    lazy = false,
    version = "*",
    dependencies = {
      "giuxtaposition/blink-cmp-copilot",
    },
    opts = {
      -- Enhanced keymap beyond LazyVim defaults (preset = "enter", <C-y> = select_and_accept)
      keymap = {
        preset = "enter", -- Your original preset - gives you <Enter> to accept, <C-y> for select_and_accept
        ["<C-p>"] = { "select_prev", "fallback" },
        ["<C-n>"] = { "select_next", "fallback" },
        ["<C-j>"] = { "select_next", "fallback" },
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<C-b>"] = { "scroll_documentation_up", "fallback" },
        ["<C-f>"] = { "scroll_documentation_down", "fallback" },
        ["<C-e>"] = { "hide", "fallback" },
      },

      -- Appearance settings
      appearance = {
        nerd_font_variant = 'mono',
      },

      -- Add copilot and lazydev to default sources (LazyVim defaults: lsp, path, snippets, buffer)
      sources = {
        default = { "lsp", "path", "snippets", "buffer", "lazydev", "copilot" },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
          },
          copilot = {
            name = "copilot",
            module = "blink-cmp-copilot",
            score_offset = 100,
            async = true,
          },
        },
      },

      -- Enhanced beyond LazyVim defaults
      completion = {
        accept = {
          auto_brackets = {
            enabled = true, -- Your original auto-brackets feature
          },
        },
        list = {
          max_items = 50,
        },
        menu = {
          border = "rounded",
          scrollbar = true,
          draw = {
            treesitter = { "lsp" }, -- Your original treesitter integration
            padding = 3,
            gap = 2,
            columns = {
              { "kind_icon", width = { fixed = 2 } },
              { "label", width = { min = 25 } },
            },
            components = {
              kind_icon = {
                ellipsis = true,
                text = function(ctx)
                  if ctx.source_name == "copilot" then
                    return ""
                  end
                  local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
                  return kind_icon
                end,
                highlight = function(ctx)
                  if ctx.source_name == "copilot" then
                    return "Special"
                  end
                  local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
                  return hl
                end,
              },
            },
          },
          -- Ensure selection is visible
          auto_show = true,
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200, -- Your original delay (was 100, back to your 200)
          window = {
            border = "rounded",
            scrollbar = true,
          },
        },
      },

      -- Enable cmdline (disabled by default in LazyVim)
      cmdline = {
        enabled = true,
        sources = { "cmdline", "path" },
      },

      -- Performance optimizations
      fuzzy = {
        use_frecency = true,
        use_proximity = true,
      },
    },
    config = function(_, opts)
      require("blink.cmp").setup(opts)

      -- Enhanced selection visibility - using correct blink.cmp highlight groups
      vim.api.nvim_set_hl(0, "BlinkCmpMenuSelection", {
        bg = "#74c7ec", -- Bright blue (Catppuccin sapphire)
        fg = "#11111b", -- Dark text for contrast
        bold = true,
      })

      -- Also set the cursor highlight for better visibility
      vim.api.nvim_set_hl(0, "BlinkCmpMenuCursor", {
        bg = "#74c7ec",
        fg = "#11111b",
        bold = true,
      })

      -- Set menu border highlight
      vim.api.nvim_set_hl(0, "BlinkCmpMenuBorder", {
        fg = "#89b4fa", -- Catppuccin blue
      })
    end,
  },
}
