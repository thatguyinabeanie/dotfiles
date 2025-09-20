-- Shell scripting and command-line tools
return {
  -- Shell LSP servers
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        bashls = {
          filetypes = { "sh", "bash", "zsh", "sh.tmpl", "zsh.tmpl" },
        },
        nushell = {
          filetypes = { "nu", "nu.tmpl" },
        },
      },
    },
  },
}
