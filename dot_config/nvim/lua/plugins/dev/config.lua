-- Configuration file tools (TOML, JSON, YAML, etc.)
return {
  -- Configuration file LSP servers
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        taplo = {
          filetypes = { "toml", "toml.tmpl" },
        },
        -- Note: JSON and YAML servers come from LazyVim language extras
      },
    },
  },
}
