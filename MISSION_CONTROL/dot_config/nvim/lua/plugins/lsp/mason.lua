return {
  {
    "williamboman/mason.nvim",
    version = "^2",
    opts = {
      ensure_installed = {
        -- TypeScript/JavaScript
        "typescript-language-server",
        "eslint_d",
        "eslint-lsp",
        "prettierd",

        -- Ruby
        "ruby-lsp",
        "standardrb",
        "haml-lint",

        -- Markdown
        "marksman",
        "vale",

        -- General tools
        "lua-language-server", -- For Neovim config
        "stylua", -- For Neovim config formatting
        "tailwindcss-language-server", -- Often used with TS projects
        "json-lsp",
        "yaml-language-server",
        "copilot-language-server", -- For AI assistance
      },
    },
  },
}
