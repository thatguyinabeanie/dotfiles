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

-- Built-in Neovim 0.12+ packages
vim.cmd.packadd("nvim.undotree")
vim.keymap.set("n", "<leader>uu", "<cmd>Undotree<cr>", { desc = "Toggle Undotree" })

-- Auto-update plugins silently after startup (throttled to once per 24h)
vim.api.nvim_create_autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("lazy_auto_update", { clear = true }),
  callback = function()
    vim.defer_fn(function()
      local stamp_file = vim.fn.stdpath("state") .. "/lazy_last_update"
      local last_update = 0
      if vim.fn.filereadable(stamp_file) == 1 then
        local content = vim.fn.readfile(stamp_file)
        last_update = tonumber(content[1]) or 0
      end
      local now = os.time()
      -- Only update if more than 24 hours have passed
      if now - last_update > 86400 then
        vim.fn.writefile({ tostring(now) }, stamp_file)
        require("lazy").update({ show = false })
      end
    end, 5000)
  end,
})
