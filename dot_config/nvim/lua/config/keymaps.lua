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

--
-- LAZY PLUGINS KEYMAPS
--
-- vim.keymap.set("n", "<leader>ll", "<cmd>Lazy<cr>", { desc = "Lazy" })
-- vim.keymap.set("n", "<leader>ld", "<cmd>LazyDocker<cr>", { desc = "LazyDocker" })
-- vim.keymap.set("n", "<leader>lD", "<cmd>LazyDev<cr>", { desc = "LazyDev" })
-- vim.keymap.set("n", "<leader>le", "<cmd>LazyExtras<cr>", { desc = "LazyExtras" })
-- vim.keymap.set("n", "<leader>lg", "<cmd>LazyGit<cr>", { desc = "LazyGit" })

--
-- CONTROL BUFFERS
--
-- vim.keymap.set("n", "<leader>bs", ":w<CR>", { desc = "Save buffer" })
-- vim.keymap.set("n", "<leader>bS", ":wa<CR>", { desc = "Save all buffers" })
-- vim.keymap.set("n", "<leader>bq", ":wq<CR>", { desc = "Save & quit buffer" })
-- vim.keymap.set("n", "<leader>bQ", ":wqa<CR>", { desc = "Save & quit all" })
-- vim.keymap.set("n", "<leader>bd", ":bd<CR>", { desc = "Delete buffer" })
-- vim.keymap.set("n", "<leader>bD", ":qa!<CR>", { desc = "Force quit all" })

--
-- COPY RELATIVE PATH OF CURRENT BUFFER
--
vim.keymap.set("n", "<leader>fy", function()
  local relative_path = vim.fn.fnamemodify(vim.fn.expand("%"), ":.")
  vim.fn.setreg("+", relative_path)
end, { desc = "Copy Relative Path" })

--
