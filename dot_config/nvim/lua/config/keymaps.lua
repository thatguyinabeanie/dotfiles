-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- local wk = require("which-key")

--
-- LINE OPERATIONS (Override LazyVim defaults)
--
-- Move LazyVim's Alt+j/k line movement to Alt+Ctrl+j/k to free up Alt+hjkl for Treewalker
-- LazyVim defaults: <A-j> and <A-k> move lines up/down
-- Our override: <A-C-j> and <A-C-k> move lines up/down

-- Move lines down (normal, insert, visual)
vim.keymap.set("n", "<A-C-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Line Down" })
vim.keymap.set("i", "<A-C-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Line Down" })
vim.keymap.set("v", "<A-C-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Lines Down" })

-- Move lines up (normal, insert, visual)
vim.keymap.set("n", "<A-C-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Line Up" })
vim.keymap.set("i", "<A-C-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Line Up" })
vim.keymap.set("v", "<A-C-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Lines Up" })

-- Indent/dedent lines (normal, visual)
vim.keymap.set("n", "<A-C-l>", ">>", { desc = "Indent Line" })
vim.keymap.set("n", "<A-C-h>", "<<", { desc = "Dedent Line" })
vim.keymap.set("v", "<A-C-l>", ">gv", { desc = "Indent Lines" })
vim.keymap.set("v", "<A-C-h>", "<gv", { desc = "Dedent Lines" })

-- Note: We don't delete LazyVim's default Alt+j/k here because Treewalker's
-- plugin keymaps (which load via lazy.nvim's keys spec) will naturally override
-- them. Deleting them here causes a race condition.

--
-- TREEWALKER KEYBINDINGS
--
-- Treewalker keybindings are now defined in the plugin file:
-- dot_config/nvim/lua/plugins/core/treewalker.lua
--
-- Quick reference:
--   Alt+hjkl           → Tree navigation (previous/down/up/next sibling)
--   Alt+Shift+hjkl     → Node swapping (reorder nodes)
--   Alt+Ctrl+jk        → Move lines up/down (LazyVim override)
--   Alt+Ctrl+hl        → Indent/dedent lines
--
-- See .docs/treewalker-integration.md for comprehensive documentation.

vim.keymap.set("n", "<leader>le", "<cmd>LazyExtras<cr>", { desc = "Lazy Extras" })
vim.keymap.set("n", "<leader>lg", "<cmd>LazyGit<cr>", { desc = "Lazy Git" })
vim.keymap.set("n", "<leader>ld", "<cmd>LazyDocker<cr>", { desc = "Lazy Docker" })
vim.keymap.set("n", "<leader>ll", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- Projects picker
vim.keymap.set("n", "<leader>fp", function()
  require("snacks").picker.projects()
end, { desc = "Find Project" })

-- -- Show hidden files in picker (matching snacks explorer)
-- vim.keymap.set("n", "<S-h>", function()
--   require("snacks").picker.files({ hidden = true })
-- end, { desc = "Find Files (including hidden)" })

--
-- COPY BUFFER PATHS
--
vim.keymap.set("n", "<leader>fy", function()
  local relative_path = vim.fn.fnamemodify(vim.fn.expand("%"), ":.")
  vim.fn.setreg("+", relative_path)
end, { desc = "Copy Buffer Relative Path" })

vim.keymap.set("n", "<leader>fY", function()
  local full_path = vim.fn.expand("%:p")
  vim.fn.setreg("+", full_path)
end, { desc = "Copy Buffer Absolute Path" })

vim.keymap.set("n", "<leader>fd", function()
  local parent_dir = vim.fn.fnamemodify(vim.fn.expand("%"), ":.:h")
  vim.fn.setreg("+", parent_dir)
end, { desc = "Copy Parent Dir Relative Path" })

vim.keymap.set("n", "<leader>fD", function()
  local parent_dir_full = vim.fn.expand("%:p:h")
  vim.fn.setreg("+", parent_dir_full)
end, { desc = "Copy Parent Dir Absolute Path" })

vim.keymap.set("n", "<leader>ft", function()
  local filetype = vim.bo.filetype
  if filetype == "" then
    vim.notify("No filetype set for current buffer", vim.log.levels.INFO)
  else
    vim.notify("Filetype: " .. filetype, vim.log.levels.INFO)
  end
end, { desc = "Show Buffer Filetype" })

--
-- BUFFER OPERATIONS
--
vim.keymap.set("n", "<leader>bx", function()
  vim.cmd("bufdo bd")
end, { desc = "Close All Buffers" })

--
-- NOTEBOOK KEYMAPS
--
vim.keymap.set("n", "<localleader>i", function()
  require("molten-nvim").init_kernel()
end, { desc = "Initialize Kernel" })

vim.keymap.set("n", "<localleader>r", function()
  require("molten-nvim").run_cell()
end, { desc = "Run Cell" })

vim.keymap.set("n", "<localleader>d", function()
  require("molten-nvim").delete_output()
end, { desc = "Delete Output" })
