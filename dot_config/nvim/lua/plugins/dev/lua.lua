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
            -- Ensure fname is valid
            if not fname or type(fname) ~= "string" or fname == "" then
              return nil
            end
            
            -- Skip LSP for chezmoi template files
            if string.find(fname, ".chezmoitemplates", 1, true) then
              return nil
            end
            
            local util = require("lspconfig.util")
            -- Ensure we return a valid path or nil
            local result = util.find_git_ancestor(fname)
            return result and type(result) == "string" and result or nil
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
