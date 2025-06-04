return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- TypeScript/JavaScript (typescript-tools.nvim handles TS server)
        "eslint_d",
        "eslint-lsp",
        "prettierd",
        
        -- Ruby
        "ruby-lsp",
        "standardrb",
        "haml-lint",
        
        -- Markdown
        "marksman",
        "markdownlint-cli2",
        
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
