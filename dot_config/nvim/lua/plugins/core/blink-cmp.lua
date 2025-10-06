-- Override LazyVim blink extra configuration
-- https://www.lazyvim.org/extras/coding/blink
-- https://cmp.saghen.dev
return {
  "saghen/blink.cmp",

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    fuzzy = {
      implementation = "rust",
      use_frecency = true,
      use_proximity = true,
    },

    -- sources = {
    --   default = { "lsp", "path", "snippets", "buffer" },
    --   providers = {
    --     lsp = {
    --       min_keyword_length = 1,
    --       max_items = 50,
    --       score_offset = 0,
    --     },
    --     path = {
    --       min_keyword_length = 0,
    --       opts = {
    --         get_cwd = function(_)
    --           return vim.fn.getcwd()
    --         end,
    --       },
    --     },
    --     snippets = {
    --       min_keyword_length = 2,
    --       max_items = 20,
    --     },
    --     buffer = {
    --       min_keyword_length = 3,
    --       max_items = 10,
    --     },
    --   },
    -- },
    --
    -- signature = {
    --   enabled = true,
    --   window = {
    --     border = "rounded",
    --   },
    -- },

    -- completion = {
    --   list = {
    --     selection = {
    --       preselect = true,
    --       auto_insert = true,
    --     },
    --   },
    --   accept = {
    --     auto_brackets = {
    --       enabled = true,
    --     },
    --   },
    --   menu = {
    --     draw = {
    --       treesitter = { "lsp" },
    --       columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
    --     },
    --   },
    --   documentation = {
    --     auto_show = true,
    --     auto_show_delay_ms = 200,
    --     window = {
    --       border = "rounded",
    --     },
    --   },
    --   ghost_text = {
    --     enabled = true,
    --   },
    -- },

    -- cmdline = {
    --   enabled = true,
    --   completion = {
    --     menu = {
    --       auto_show = function(ctx)
    --         local line = ctx.line or ""
    --         return line:match("^%s*:%w+%s+") ~= nil
    --       end,
    --     },
    --     ghost_text = {
    --       enabled = true,
    --     },
    --   },
    --   keymap = {
    --     ["<CR>"] = { "fallback" },
    --     ["<C-y>"] = { "accept" },
    --   },
    -- },

    -- keymap = {
    --   preset = "default",
    --   ["<Tab>"] = {
    --     "snippet_forward",
    --     function()
    --       return require("sidekick").nes_jump_or_apply()
    --     end,
    --     "accept",
    --     "fallback",
    --   },
    -- },
  },
}
