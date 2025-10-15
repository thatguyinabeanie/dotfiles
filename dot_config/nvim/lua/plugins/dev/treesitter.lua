-- TreeSitter configuration and syntax highlighting
-- Fallback configuration when template is not generated
local config = {
  treesitter = {
    parsers = {
      "lua",
      "vim",
      "vimdoc",
      "query",
      "python",
      "javascript",
      "typescript",
      "html",
      "css",
      "json",
      "yaml",
      "toml",
      "bash",
      "markdown",
      "markdown_inline",
    },
  },
  filetypes = {
    templates = {
      bash = { "sh.tmpl", "zsh.tmpl" },
      lua = { "lua.tmpl" },
      nu = { "nu.tmpl" },
      toml = { "toml.tmpl" },
    },
  },
}

-- Try to load the template-generated config, fallback to defaults if not available
local ok, template_config = pcall(require, "utils.language-config")
if ok then
  config = template_config
end

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
