-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local wk = require("which-key")

--
-- SCROLLING
--
-- When scrolling, center the cursor vertically within the buffer window
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
-- When searching, center the cursor vertically within the buffer window
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Treewalker movement (normal & visual mode)
vim.keymap.set({ 'n', 'v' }, '<M-h>', '<cmd>Treewalker Left<cr>', { desc = "Treewalker Left", silent = true })
vim.keymap.set({ 'n', 'v' }, '<M-j>', '<cmd>Treewalker Down<cr>', { desc = "Treewalker Down", silent = true })
vim.keymap.set({ 'n', 'v' }, '<M-k>', '<cmd>Treewalker Up<cr>', { desc = "Treewalker Up", silent = true })
vim.keymap.set({ 'n', 'v' }, '<M-l>', '<cmd>Treewalker Right<cr>', { desc = "Treewalker Right", silent = true })

-- Treewalker swapping (normal mode)
vim.keymap.set('n', '<M-H>', '<cmd>Treewalker SwapLeft<cr>', { desc = "Treewalker Swap Left", silent = true })
vim.keymap.set('n', '<M-J>', '<cmd>Treewalker SwapDown<cr>', { desc = "Treewalker Swap Down", silent = true })
vim.keymap.set('n', '<M-K>', '<cmd>Treewalker SwapUp<cr>', { desc = "Treewalker Swap Up", silent = true })
vim.keymap.set('n', '<M-L>', '<cmd>Treewalker SwapRight<cr>', { desc = "Treewalker Swap Right", silent = true })

--
-- LAZY PLUGINS KEYMAPS
--
vim.keymap.set("n", "<leader>ll", "<cmd>Lazy<cr>", { desc = "Lazy" })
vim.keymap.set("n", "<leader>ld", "<cmd>LazyDocker<cr>", { desc = "LazyDocker" })
vim.keymap.set("n", "<leader>lD", "<cmd>LazyDev<cr>", { desc = "LazyDev" })
vim.keymap.set("n", "<leader>le", "<cmd>LazyExtras<cr>", { desc = "LazyExtras" })
vim.keymap.set("n", "<leader>lg", "<cmd>LazyGit<cr>", { desc = "LazyGit" })

--
-- CONTROL BUFFERS
--
vim.keymap.set("n", "<leader>bss", "<cmd>w<cr>", { desc = "Save Current Buffer" })
vim.keymap.set("n", "<leader>bsa", "<cmd>w<cr>", { desc = "Save All Buffers" })
vim.keymap.set("n", "<leader>bsq", "<cmd>wqa<cr>", { desc = "Save All Buffers and Quit" })
vim.keymap.set("n", "<leader>bq<cr>", "<cmd>bq<cr>", { desc = "Quit Current Buffer" })
vim.keymap.set("n", "<leader>bqa", "<cmd>bqa<cr>", { desc = "Quit All Buffers" })

--
-- COPY RELATIVE PATH OF CURRENT BUFFER
--
vim.keymap.set("n", "<leader>fy", function()
  local relative_path = vim.fn.fnamemodify(vim.fn.expand("%"), ":.")
  vim.fn.setreg("+", relative_path)
end, { desc = "copy file's relative path" })

--
-- OPEN CURRENT BUFFER IN Cursor
--
vim.keymap.set("n", "<leader>bV", function()
  local current_file = vim.fn.expand("%:p")
  if current_file == "" then
    vim.notify("No file in current buffer", vim.log.levels.ERROR)
    return
  end

  local vscode_path = "/Applications/Cursor.app/Contents/MacOS/Cursor"

  if vim.fn.executable(vscode_path) == 1 then
    -- Use os.execute instead of system for better shell compatibility
    local success = os.execute(string.format('"%s" "%s" &', vscode_path, current_file))
    if not success then
      vim.notify("Failed to open Cursor.", vim.log.levels.ERROR)
    else
      vim.notify("Openning in Cursor: " .. current_file, vim.log.levels.INFO)
    end
  else
    -- For nushell compatibility, use open command
    local success = os.execute(string.format('open -a "Cursor" "%s"', current_file))
    if not success then
      vim.notify("Failed to open Cursor using open command", vim.log.levels.ERROR)
    else
      vim.notify("Openning in Cursor: " .. current_file, vim.log.levels.INFO)
    end
  end
end, { desc = "Open in Cursor " })

vim.keymap.set("n", "<leader>xo", ":e ~/.local/state/nvim/lsp.log<cr>", { desc = "Open nvim's lsp.log file." })
vim.keymap.set("n", "<leader>xd", function()
  local log_file = vim.fn.expand("~/.local/state/nvim/lsp.log")
  local f = io.open(log_file, "w")
  if f then
    f:close()
    vim.notify("Cleared ~/.local/state/nvim/lsp.log", vim.log.levels.INFO)
  else
    vim.notify("Failed to clear ~/.local/state/nvim/lsp.log", vim.log.levels.ERROR)
  end
end, { desc = "Clear ~/.local/state/nvim/lsp.log" })

--
-- POMODORO TIMER KEYMAPS
--
wk.add({
  { "<leader>P", group = "Pomodoro", icon = "⏳" },
})
vim.keymap.set("n", "<leader>Ps", "<cmd>TimerStart<cr>", { desc = "Start timer" })
vim.keymap.set("n", "<leader>Pr", "<cmd>TimerRepeat<cr>", { desc = "Repeat last timer" })
vim.keymap.set("n", "<leader>Pp", "<cmd>TimerSession pomodoro<cr>", { desc = "Start pomodoro session" })
vim.keymap.set("n", "<leader>Pw", "<cmd>TimerStart 25m Work<cr>", { desc = "Start work timer (25m)" })
vim.keymap.set("n", "<leader>Pb", "<cmd>TimerStart 5m Break<cr>", { desc = "Start short break (5m)" })
vim.keymap.set("n", "<leader>PB", "<cmd>TimerStart 15m Long Break<cr>", { desc = "Start long break (15m)" })


--
-- OBSIDIAN
--
wk.add({
  { "<leader>O", group = "Obsidian", icon = "📁" },
})

-- Core Obsidian functionality
vim.keymap.set("n", "<leader>On", "<cmd>ObsidianNew<cr>", { desc = "New Obsidian Note" })
vim.keymap.set("n", "<leader>Oo", "<cmd>ObsidianOpen<cr>", { desc = "Open in Obsidian App" })
vim.keymap.set("n", "<leader>Of", "<cmd>ObsidianFollowLink<cr>", { desc = "Follow Link Under Cursor" })
vim.keymap.set("n", "<leader>Ob", "<cmd>ObsidianBacklinks<cr>", { desc = "Show Backlinks" })
vim.keymap.set("n", "<leader>Oq", "<cmd>ObsidianQuickSwitch<cr>", { desc = "Quick Switch" })
vim.keymap.set("n", "<leader>Os", "<cmd>ObsidianSearch<cr>", { desc = "Search in Vault" })

-- Daily notes
vim.keymap.set("n", "<leader>Ot", "<cmd>ObsidianToday<cr>", { desc = "Open Today's Note" })
vim.keymap.set("n", "<leader>Oy", "<cmd>ObsidianYesterday<cr>", { desc = "Open Yesterday's Note" })

-- Workspace switching
vim.keymap.set("n", "<leader>Owp", "<cmd>ObsidianWorkspace personal<cr>", { desc = "Switch to Personal Workspace" })
vim.keymap.set("n", "<leader>Ows", "<cmd>ObsidianWorkspace smart-notes<cr>", { desc = "Switch to Smart Notes Workspace" })
vim.keymap.set("n", "<leader>Owb", "<cmd>ObsidianWorkspace bramses<cr>", { desc = "Switch to Bramses Workspace" })
-- Work workspace is conditionally added in the obsidian.lua.tmpl file

--
-- LLM/AI KEYMAPS ORGANIZATION
--
-- All AI/LLM tools are organized under two main prefixes:
-- <leader>a - General AI tools (Avante, Claude, CodeCompanion)
-- <leader>p - Copilot-specific features
--
-- <leader>a mappings:
--   aa - Avante Ask
--   ae - Avante Edit
--   ar - Avante Refresh
--   ac - Claude Code Toggle
--   aC - Claude Code Continue
--   aV - Claude Code Verbose
--   ao - CodeCompanion Open Chat
--   as - CodeCompanion Actions
--   at - CodeCompanion Toggle
--   ap - CopilotChat Prompt
--   ah - CopilotChat Toggle
--   ad - CopilotChat Debug
--
-- <leader>p mappings (Copilot-specific):
--   pc - Toggle Chat
--   ps - Stop
--   pr - Reset
--   pe - Explain
--   pv - Review
--   pf - Fix
--   po - Optimize
--   pd - Docs
--   pt - Tests
--   pp - Visual Prompt
--   pq - Quick Chat
--   ph - Help Actions
--   pa - Prompt Actions
--

