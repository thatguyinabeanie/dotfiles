-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- local wk = require("which-key")

-- Treewalker movement (normal & visual mode)
-- vim.keymap.set({ 'n', 'v' }, '<M-h>', '<cmd>Treewalker Left<cr>', { desc = "Treewalker Left", silent = true })
-- vim.keymap.set({ 'n', 'v' }, '<M-j>', '<cmd>Treewalker Down<cr>', { desc = "Treewalker Down", silent = true })
-- vim.keymap.set({ 'n', 'v' }, '<M-k>', '<cmd>Treewalker Up<cr>', { desc = "Treewalker Up", silent = true })
-- vim.keymap.set({ 'n', 'v' }, '<M-l>', '<cmd>Treewalker Right<cr>', { desc = "Treewalker Right", silent = true })

-- Treewalker swapping (normal mode)
-- vim.keymap.set('n', '<M-H>', '<cmd>Treewalker SwapLeft<cr>', { desc = "Treewalker Swap Left", silent = true })
-- vim.keymap.set('n', '<M-J>', '<cmd>Treewalker SwapDown<cr>', { desc = "Treewalker Swap Down", silent = true })
-- vim.keymap.set('n', '<M-K>', '<cmd>Treewalker SwapUp<cr>', { desc = "Treewalker Swap Up", silent = true })
-- vim.keymap.set('n', '<M-L>', '<cmd>Treewalker SwapRight<cr>', { desc = "Treewalker Swap Right", silent = true })

vim.keymap.set("n", "<leader>le", "<cmd>LazyExtras<cr>", { desc = "Lazy Extras" })
vim.keymap.set("n", "<leader>lg", "<cmd>LazyGit<cr>", { desc = "Lazy Git" })
vim.keymap.set("n", "<leader>ld", "<cmd>LazyDocker<cr>", { desc = "Lazy Docker" })

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
