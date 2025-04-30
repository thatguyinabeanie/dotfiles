-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

--
-- LSP ATTACH
--
vim.api.nvim_create_autocmd({ "LspAttach" }, {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client:supports_method("textDocument/completion") then
      vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
    end
  end,
})

--
-- BUFREAD< BUFNEWFILE
--
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.nu.tmpl",
  callback = function()
    vim.opt_local.syntax = "nu"
  end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.lua.tmpl",
  callback = function()
    vim.opt_local.syntax = "lua"
  end,
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern =  "*.sh.tmpl" ,
  callback = function()
    vim.opt_local.syntax = "sh"
  end,
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = { "*.zsh.tmpl" },
  callback = function()
    vim.opt_local.syntax = "zsh"
  end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.toml.tmpl",
  callback = function()
    vim.opt_local.syntax = "toml"
  end,
})
