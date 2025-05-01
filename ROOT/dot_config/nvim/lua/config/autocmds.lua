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

-- Handle LSP client attachment issues
vim.api.nvim_create_autocmd({ "BufEnter" }, {
  callback = function(ev)
    local bufnr = ev.buf

    -- Skip if buffer already has LSP clients attached
    if #vim.lsp.get_clients({ bufnr = bufnr }) > 0 then
      return
    end

    -- Attempt to attach LSP clients for this filetype
    vim.defer_fn(function()
      if vim.api.nvim_buf_is_valid(bufnr) then
        vim.cmd("LspStart")
      end
    end, 100)
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

-- CodeQL files
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.ql", "*.qll" },
  callback = function()
    vim.opt_local.filetype = "ql"
  end,
})

-- Customize LSP notifications to reduce noise
local orig_notify = vim.notify
vim.notify = function(msg, level, opts)
  -- Filter out specific LSP warnings
  if msg and msg:match("Client with id %d+ not attached to buffer") then
    -- Either silence completely or reduce to a lower level
    return orig_notify(msg, vim.log.levels.DEBUG, opts)
  end

  return orig_notify(msg, level, opts)
end
