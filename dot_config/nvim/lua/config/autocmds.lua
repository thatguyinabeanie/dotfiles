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

-- Built-in Neovim 0.12+ packages (pcall guards against minimal/popup envs)
if pcall(vim.cmd.packadd, "nvim.undotree") then
  local function undotree_open()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "undotree" then
        return true
      end
    end
    return false
  end
  vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    once = true,
    callback = function()
      Snacks.toggle({
        name = "Undotree",
        get = undotree_open,
        set = function(state)
          if state ~= undotree_open() then
            vim.cmd("Undotree")
          end
        end,
      }):map("<leader>uu")
    end,
  })
end

-- Stop LSP clients gracefully on quit to prevent NO_RESULT_CALLBACK_FOUND errors
-- (taplo and others log this when Neovim exits with pending LSP requests)
vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    vim.lsp.stop_client(vim.lsp.get_clients(), true)
  end,
})

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

-- Obsidian vault LSP arbitration:
--   * Inside an Obsidian vault (.obsidian marker) → obsidian-ls owns LSP; detach
--     markdown-oxide and marksman from the buffer.
--   * Outside vaults → markdown-oxide / marksman own LSP; detach obsidian-ls (which
--     always starts on markdown buffers and cannot be disabled via config).
local function buf_in_vault(buf)
  local name = vim.api.nvim_buf_get_name(buf)
  if name == "" then
    return false
  end
  local dir = vim.fn.fnamemodify(name, ":p:h")
  return vim.fs.find(".obsidian", { path = dir, upward = true, type = "directory" })[1] ~= nil
end

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("obsidian_lsp_arbitration", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end
    local in_vault = buf_in_vault(args.buf)
    local detach = (in_vault and (client.name == "markdown_oxide" or client.name == "marksman"))
      or (not in_vault and client.name == "obsidian-ls")
    if detach then
      vim.schedule(function()
        vim.lsp.buf_detach_client(args.buf, client.id)
      end)
    end
  end,
})
