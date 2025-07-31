-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

--
-- AUTO CHANGE TO GIT ROOT DIRECTORY
--
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    -- Get the first argument
    local first_arg = vim.fn.argv(0)

    -- If we're opening a directory
    if first_arg ~= "" and vim.fn.isdirectory(first_arg) == 1 then
      -- Change to the specified directory (don't go to git root)
      vim.cmd("cd " .. vim.fn.fnameescape(tostring(first_arg)))
      vim.notify("Working directory: " .. tostring(first_arg), vim.log.levels.INFO)
    end
  end,
})

-- -- Obsidian and Markdown files
-- vim.api.nvim_create_autocmd({ "FileType" }, {
--   pattern = { "markdown" },
--   callback = function()
--     -- Enable spell checking
--     vim.opt_local.spell = true
--     vim.opt_local.spelllang = "en_us"
--
--     -- Enable soft wrapping for markdown files
--     vim.opt_local.wrap = true
--     vim.opt_local.linebreak = true
--     vim.opt_local.breakindent = true
--
--     -- Set tab settings for markdown
--     vim.opt_local.tabstop = 2
--     vim.opt_local.softtabstop = 2
--     vim.opt_local.shiftwidth = 2
--     vim.opt_local.expandtab = true
--
--     -- Set conceallevel for markdown
--     vim.opt_local.conceallevel = 2
--
--     -- Disable auto-pairs for markdown files to avoid issues with brackets in links
--     -- vim.g.AutoPairsMapSpace = 0
--   end,
-- })
--
-- Detect Obsidian vault files
-- vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
--   pattern = {
--     "*/obsidian-vault/**/*.md",
--     "*/obsidian-vault-work/**/*.md",
--     "*/smart-notes/**/*.md",
--     "*/bramses-highly-opinionated-vault-2023/**/*.md",
--   },
--   callback = function()
--     -- Set filetype to markdown
--     vim.opt_local.filetype = "markdown.obsidian"
--
--     -- Enable Obsidian-specific settings
--     vim.b.obsidian_file = true
--   end,
-- })

-- Override chezmoi template filetype detection
-- NOTE: Commented out - redundant with filetypes.lua which uses vim.filetype.add()
-- The modern vim.filetype.add() approach in filetypes.lua is preferred and more efficient
--[[
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.tmpl" },
  callback = function()
    local filepath = vim.fn.expand("%:p")
    
    -- Only process files in chezmoi directories
    if not string.find(filepath, "/chezmoi/") then
      return
    end
    
    -- Extract base filename without .tmpl extension
    local basename = vim.fn.fnamemodify(filepath, ":t:r")
    local ext = vim.fn.fnamemodify(basename, ":e")
    
    -- Map extensions to filetypes
    local ext_map = {
      lua = "lua",
      sh = "sh",
      zsh = "zsh", 
      nu = "nu",
      js = "javascript",
      ts = "typescript",
      py = "python",
      json = "json",
      yaml = "yaml",
      yml = "yaml",
      toml = "toml",
      html = "html",
      css = "css",
      md = "markdown"
    }
    
    if ext_map[ext] then
      vim.opt_local.filetype = ext_map[ext]
      
      -- Disable diagnostics for template files to avoid Go template syntax errors
      vim.defer_fn(function()
        vim.diagnostic.enable(false, { bufnr = 0 })
      end, 100)
    end
  end,
})
--]]
