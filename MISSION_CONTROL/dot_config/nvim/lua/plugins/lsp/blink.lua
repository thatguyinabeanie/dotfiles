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
        ["<C-p>"] = { "select_prev", "fallback" },
        ["<C-n>"] = { "select_next", "fallback" },
        ["<C-j>"] = { "select_next", "fallback" },
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<C-b>"] = { "scroll_documentation_up", "fallback" },
        ["<C-f>"] = { "scroll_documentation_down", "fallback" },
        ["<C-e>"] = { "hide", "fallback" },
      },

      -- Add copilot and lazydev to default sources (LazyVim defaults: lsp, path, snippets, buffer)
      sources = {
        default = { "lsp", "path", "snippets", "buffer", "lazydev", "copilot" },
        per_filetype = {
          -- Optimize for specific filetypes
          gitcommit = { "buffer", "path" }, -- Override for commit messages
          markdown = { "buffer", "copilot" }, -- Add copilot for markdown
        },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 100, -- High priority for lazydev completions
          },
          copilot = {
            name = "copilot",
            module = "blink-cmp-copilot",
            score_offset = 90, -- Lower than LSP to show after primary suggestions
            async = true,
            min_keyword_length = 0, -- Allow single character triggers
            timeout_ms = 5000, -- Increase timeout for network requests
            transform_items = function(_, items)
              -- Remove icon from label since we handle it in kind_icon
              for _, item in ipairs(items) do
                item.labelDetails = { description = "AI" }
              end
              return items
            end,
          },
          buffer = {
            -- Enhanced buffer source from visible windows only
            opts = {
              get_bufnrs = function()
                return vim
                  .iter(vim.api.nvim_list_wins())
                  :map(function(win)
                    return vim.api.nvim_win_get_buf(win)
                  end)
                  :filter(function(buf)
                    return vim.bo[buf].buftype ~= "nofile"
                  end)
                  :totable()
              end,
            },
          },
        },
      },

      -- Enhanced beyond LazyVim defaults
      completion = {
        trigger = {
          prefetch_on_insert = true,
        },
        list = {
          max_items = 50,
        },
        menu = {
          border = "rounded",
          scrollbar = true,
          draw = {
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
                    return "AI" -- Use text instead of problematic icons
                  end
                  local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
                  return kind_icon
                end,
                highlight = function(ctx)
                  if ctx.source_name == "copilot" then
                    return "Keyword" -- Use a different highlight group
                  end
                  local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
                  return hl
                end,
              },
            },
          },
          -- Ensure selection is visible
          auto_show = true,
          selection = "auto_insert",
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 100,
          window = {
            border = "rounded",
            scrollbar = true,
            max_width = 80,
            max_height = 20,
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
