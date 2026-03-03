-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Markdown diagnostics re-enabled for Marksman LSP
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "markdown",
--   callback = function()
--     vim.diagnostic.enable(false)
--   end,
-- })

-- Optional: Notification when a file is reloaded
vim.api.nvim_create_autocmd("FileChangedShellPost", {
  pattern = "*",
  callback = function()
    vim.notify("File changed on disk. Buffer reloaded.", vim.log.levels.INFO)
  end,
})

-- Detect .yaml.j2 files as yaml.jinja2 for proper Jinja2 + YAML highlighting
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.yaml.j2",
  callback = function()
    vim.bo.filetype = "yaml.jinja2"
  end,
})

-- Auto-update plugins silently after startup
vim.api.nvim_create_autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("lazy_auto_update", { clear = true }),
  callback = function()
    vim.defer_fn(function()
      require("lazy").update({ show = false })
    end, 5000)
  end,
})
