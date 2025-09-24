-- Custom LSP configuration
-- This works alongside LazyVim's LSP configuration

return {
  -- Custom LSP server configuration
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      -- Add any custom LSP server configurations here
      opts.servers = opts.servers or {}
      return opts
    end,
  },
}