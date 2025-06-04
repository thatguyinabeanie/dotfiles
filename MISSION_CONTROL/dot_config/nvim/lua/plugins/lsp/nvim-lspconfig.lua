return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        bashls = {
          filetypes = { "sh", "bash", "zsh", "sh.tmpl", "zsh.tmpl" },
        },
        lua_ls = {
          filetypes = { "lua", "lua.tmpl" },
        },
        nushell = {
          filetypes = { "nu", "nu.tmpl" },
        },
        ruby_lsp = {},
        taplo = {
          filetypes = { "toml", "toml.tmpl" },
        },
        -- Disable these in favor of typescript-tools.nvim
        tsserver = {
          enabled = false,
        },
        ts_ls = {
          enabled = false,
        },
        vtsls = {
          enabled = false,
        },
      },
    },
  }
}
