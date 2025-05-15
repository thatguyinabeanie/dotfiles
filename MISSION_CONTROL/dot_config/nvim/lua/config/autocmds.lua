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
-- vim.api.nvim_create_autocmd({ "BufEnter" }, {
--   callback = function(ev)
--     local bufnr = ev.buf
--     local ft = vim.bo[bufnr].filetype
--
--     -- Skip if buffer already has LSP clients attached
--     if #vim.lsp.get_active_clients({ bufnr = bufnr }) > 0 then
--       return
--     end
--
--     -- Attempt to attach LSP clients for this filetype
--     vim.defer_fn(function()
--       if vim.api.nvim_buf_is_valid(bufnr) then
--         vim.cmd("LspStart")
--       end
--     end, 100)
--   end,
-- })

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

-- Obsidian and Markdown files
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "markdown" },
  callback = function()
    -- Enable spell checking
    vim.opt_local.spell = true
    vim.opt_local.spelllang = "en_us"

    -- Enable soft wrapping for markdown files
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.breakindent = true

    -- Set tab settings for markdown
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true

    -- Set conceallevel for markdown
    vim.opt_local.conceallevel = 2

    -- Disable auto-pairs for markdown files to avoid issues with brackets in links
    -- vim.g.AutoPairsMapSpace = 0
  end,
})

-- Detect Obsidian vault files
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*/obsidian-vault/**/*.md", "*/obsidian-vault-work/**/*.md", "*/smart-notes/**/*.md", "*/bramses-highly-opinionated-vault-2023/**/*.md" },
  callback = function()
    -- Set filetype to markdown
    vim.opt_local.filetype = "markdown.obsidian"

    -- Enable Obsidian-specific settings
    vim.b.obsidian_file = true
  end,
})
