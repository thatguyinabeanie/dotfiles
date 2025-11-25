-- TreeSitter configuration and syntax highlighting
-- Minimal essential parsers - auto_install handles the rest

-- Map of special case filetypes to parsers
local parser_map = {
  sh = "bash",
  zsh = "bash",
}

return {
  -- TreeSitter configuration
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = { "RRethy/nvim-treesitter-endwise" },
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },

    config = function(_, opts)
      require("nvim-treesitter.install").prefer_git = true
      require("nvim-treesitter").setup(opts)

      -- Register yaml.jinja2 filetype to use both YAML and Jinja2 parsers
      vim.treesitter.language.register("yaml", "yaml.jinja2")

      -- Generic autocmd to handle template filetypes
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "*",
        callback = function(args)
          local buf = args.buf
          local ft = vim.bo[buf].filetype

          -- Automatically register template filetypes to their base parser
          local base_lang = ft:match("^(.+)%.tmpl$") or ft:match("^(.+)%.chezmoitmpl$")
          if base_lang then
            -- Use parser_map for special cases, otherwise use base_lang directly
            local parser = parser_map[base_lang] or base_lang
            vim.treesitter.language.register(parser, ft)
          end

          -- Ensure treesitter highlighting is attached
          if not vim.treesitter.highlighter.active[buf] then
            pcall(vim.treesitter.start, buf)
          end
        end,
      })
    end,

    opts = {
      auto_install = true,
      endwise = { enable = true },
      ensure_installed = {
        "lua", -- Neovim config
        "vim", -- Vim script
        "vimdoc", -- Vim documentation
        "query", -- TreeSitter queries
      },
      highlight = {
        enable = true,
        -- Disable treesitter for template files (follow chezmoi.vim recommendation)
        disable = function(lang, buf)
          local filetype = vim.bo[buf].filetype
          -- Disable for any .tmpl or .chezmoitmpl filetypes
          return filetype:match("%.tmpl$") or filetype:match("%.chezmoitmpl$")
        end,
      },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
    },
  },
}
