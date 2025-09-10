-- TreeSitter configuration and syntax highlighting
local config = require("utils.language-config")

return {
  -- TreeSitter configuration
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = { "RRethy/nvim-treesitter-endwise" },
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },

    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
      -- Register template file associations
      for parser, templates in pairs(config.filetypes.templates) do
        local tmpl_list = type(templates) == "table" and templates or { templates }
        for _, tmpl in ipairs(tmpl_list) do
          vim.treesitter.language.register(parser, tmpl)
        end
      end
    end,

    opts = {
      auto_install = true,
      endwise = { enable = true },
      ensure_installed = config.treesitter.parsers,
      highlight = { enable = true },
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