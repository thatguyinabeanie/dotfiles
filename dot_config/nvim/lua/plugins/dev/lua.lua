-- Lua development tools and configuration
return {
  -- Lua LSP server
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        lua_ls = {
          filetypes = { "lua", "lua.tmpl" },
          root_dir = function(fname)
            if vim.fn.stridx(fname, ".chezmoitemplates") ~= -1 then
              return nil
            end
              return require("lazyvim.util").root.git()(fname)
          end,
        },
      },
    },
  },

  -- LazyDev for Neovim Lua development
  {
    "folke/lazydev.nvim",
    ft = "lua",
    cmd = "LazyDev",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        { path = "LazyVim", words = { "LazyVim" } },
        { path = "snacks.nvim", words = { "Snacks" } },
        { path = "lazy.nvim", words = { "LazyVim" } },
      },
    },
  },
}