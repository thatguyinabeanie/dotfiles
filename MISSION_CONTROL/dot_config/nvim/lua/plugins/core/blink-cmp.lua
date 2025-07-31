-- Override LazyVim blink extra configuration
-- https://www.lazyvim.org/extras/coding/blink
-- https://cmp.saghen.dev
return {
  "saghen/blink.cmp",
  build = false, -- Don't build from source (use prebuilt binaries)
  event = "VeryLazy",
  opts = {
    -- Performance optimizations (avoid compilation issues)
    fuzzy = {
      implementation = "prefer_rust_with_warning", -- Prefer Rust but fallback to Lua if needed
      use_frecency = true,
      use_proximity = true,
      prebuilt_binaries = {
        download = true, -- Use prebuilt binaries to avoid Rust nightly bug
        force_version = nil,
      },
    },
    sources = {
      providers = {
        path = {
          opts = {
            get_cwd = function(_)
              return vim.fn.getcwd()
            end,
          },
        },
      },
    },
    -- Improved completion menu with treesitter highlighting
    completion = {
      menu = {
        draw = {
          treesitter = { "lsp" }, -- Enable syntax highlighting for LSP completions
          columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
        },
      },
      ghost_text = {
        enabled = true, -- Show preview of completion inline
      },
    },

    -- Enable command-line completion (LazyVim default: enabled = false)
    cmdline = {
      enabled = true,
      completion = {
        menu = {
          -- Smart auto-show: function to control when menu appears
          auto_show = function(ctx)
            local line = ctx.line or ""
            -- Show completion after space (complex commands) or when explicitly triggered
            -- Don't show for simple commands like :w, :q, :wq without arguments
            return line:match("^%s*:%w+%s+") ~= nil
          end,
        },
        ghost_text = {
          enabled = true, -- Enable ghost text in cmdline (requires noice.nvim)
        },
      },
      keymap = {
        ["<CR>"] = { "fallback" }, -- Never accept with Enter
        ["<C-y>"] = { "accept" }, -- Accept with Ctrl+Y
      },
    },
  },
}
