return {
  -- Configure nvim-lint for ERB files
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        ["yaml.erb"] = { "erb_lint" },
        ["html.erb"] = { "erb_lint" },
      },
    },
  },

  -- Configure conform.nvim for ERB formatting
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        ["yaml.erb"] = { "erb_format" },
        ["html.erb"] = { "erb_format" },
      },
    },
  },

  -- Disable ruby_lsp for ERB files to avoid mysql2 compilation issues
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ruby_lsp = {
          filetypes = { "ruby" }, -- Remove erb from filetypes
        },
      },
    },
  },
}
