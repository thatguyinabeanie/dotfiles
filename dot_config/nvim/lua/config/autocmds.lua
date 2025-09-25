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
    -- Get the first argument and ensure it's a string
    local first_arg = tostring(vim.fn.argv(0))

    -- If we're opening a directory
    if first_arg ~= "" and vim.fn.isdirectory(first_arg) == 1 then
      -- Change to the specified directory (don't go to git root)
      vim.cmd("cd " .. vim.fn.fnameescape(first_arg))
      vim.notify("Working directory: " .. first_arg, vim.log.levels.INFO)
    end
  end,
})

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

--
-- SPELL CHECKING DIAGNOSTICS
--
-- Custom spell check diagnostic source
-- local spell_namespace = vim.api.nvim_create_namespace("spell_diagnostics")
--
-- local function update_spell_diagnostics(bufnr)
--   bufnr = bufnr or vim.api.nvim_get_current_buf()
--
--   -- Only check if spell is enabled
--   if not vim.wo.spell then
--     vim.diagnostic.reset(spell_namespace, bufnr)
--     return
--   end
--
--   local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
--   local diagnostics = {}
--
--   for line_nr, line in ipairs(lines) do
--     local col = 0
--     while col < #line do
--       local word_start, word_end = string.find(line, "%w+", col + 1)
--       if not word_start then break end
--
--       local word = string.sub(line, word_start, word_end)
--       -- Check if word is misspelled using Vim's spellbadword()
--       local bad_word = vim.fn.spellbadword(word)
--       if bad_word[1] ~= "" then
--         local suggestions = vim.fn.spellsuggest(word, 3)
--         local message = "Misspelled word"
--         if #suggestions > 0 then
--           message = message .. ". Suggestions: " .. table.concat(suggestions, ", ")
--         end
--
--         table.insert(diagnostics, {
--           lnum = line_nr - 1,
--           col = word_start - 1,
--           end_col = word_end,
--           severity = vim.diagnostic.severity.HINT,
--           message = message,
--           source = "spell",
--         })
--       end
--
--       col = word_end
--     end
--   end
--
--   vim.diagnostic.set(spell_namespace, bufnr, diagnostics)
-- end
--
-- -- Update spell diagnostics on text changes and when spell is toggled
-- vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI", "BufEnter" }, {
--   callback = function()
--     -- Only for text files where spell checking makes sense
--     local ft = vim.bo.filetype
--     if ft == "markdown" or ft == "text" or ft == "gitcommit" or ft == "mail" then
--       vim.defer_fn(function()
--         update_spell_diagnostics()
--       end, 100)
--     end
--   end,
-- })
--
-- -- Update when spell option changes
-- vim.api.nvim_create_autocmd("OptionSet", {
--   pattern = "spell",
--   callback = function()
--     update_spell_diagnostics()
--   end,
-- })
--
-- -- Enable spell checking for markdown and text files
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = { "markdown", "text", "gitcommit", "mail" },
--   callback = function()
--     vim.opt_local.spell = true
--     -- Initial spell check
--     vim.defer_fn(function()
--       update_spell_diagnostics()
--     end, 200)
--   end,
-- })

-- Disable diagnostics for Markdown files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.diagnostic.enable(false)
  end,
})
