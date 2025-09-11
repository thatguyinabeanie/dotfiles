-- Ruby development tools
return {
  -- Ruby LSP server
  {
    "neovim/nvim-lspconfig", 
    opts = {
      servers = {
        ruby_lsp = {},
      },
    },
  },
}