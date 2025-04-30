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
-- OBSIDIAN
--
wk.add({
  { "<leader>O", group = "Obsidian", icon = "📁" },
})
vim.keymap.set("n", "<leader>On", "<cmd>ObsidianNew<cr>", { desc = "New Obsidian Note" })
vim.keymap.set("n", "<leader>Oo", "<cmd>ObsidianOpen<cr>", { desc = "Open in Obsidian App" })
vim.keymap.set("n", "<leader>Of", "<cmd>ObsidianFollowLink<cr>", { desc = "Follow Link Under Cursor" })
vim.keymap.set("n", "<leader>Ob", "<cmd>ObsidianBacklinks<cr>", { desc = "Show Backlinks" })
vim.keymap.set("n", "<leader>Ot", "<cmd>ObsidianToday<cr>", { desc = "Open Today's Note" })
vim.keymap.set("n", "<leader>Oy", "<cmd>ObsidianYesterday<cr>", { desc = "Open Yesterday's Note" })
vim.keymap.set("n", "<leader>Om", "<cmd>ObsidianTomorrow<cr>", { desc = "Open Tomorrow's Note" })
vim.keymap.set("n", "<leader>Os", "<cmd>ObsidianSearch<cr>", { desc = "Search in Vault" })
vim.keymap.set("n", "<leader>Ol", "<cmd>ObsidianLink<cr>", { desc = "Create Link" })
vim.keymap.set("n", "<leader>OL", "<cmd>ObsidianLinkNew<cr>", { desc = "Create Link to New Note" })
vim.keymap.set("v", "<leader>Ol", "<cmd>ObsidianLink<cr>", { desc = "Create Link from Selection" })
vim.keymap.set("v", "<leader>OL", "<cmd>ObsidianLinkNew<cr>", { desc = "Create Link to New Note from Selection" })
vim.keymap.set("n", "<leader>Op", "<cmd>ObsidianPasteImg<cr>", { desc = "Paste Image from Clipboard" })
vim.keymap.set("n", "<leader>Or", "<cmd>ObsidianRename<cr>", { desc = "Rename Note" })
vim.keymap.set("n", "<leader>Oq", "<cmd>ObsidianQuickSwitch<cr>", { desc = "Quick Switch" })

--
-- OPEN CURRENT BUFFER IN VS CODE - INSIDERS
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
      vim.notify("Failed to open VS Code using bin/code", vim.log.levels.ERROR)
    else
      vim.notify("Openning in VS Code: " .. current_file, vim.log.levels.INFO)
    end
  else
    -- For nushell compatibility, use open command
    local success = os.execute(string.format('open -a "Visual Studio Code - Insiders" "%s"', current_file))
    if not success then
      vim.notify("Failed to open VS Code using open command", vim.log.levels.ERROR)
    else
      vim.notify("Openning in VS Code - Insiders: " .. current_file, vim.log.levels.INFO)
    end
  end
end, { desc = "Open Buffer VS Code - Insiders" })

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
-- MARP
--
wk.add({
  { "<leader>M", group = "MARP", icon = "🎁" },
})
vim.keymap.set("n", "<leader>Mt", "<cmd>MarpToggle<cr>", { desc = "Toggle MARP", noremap = true, silent = true })
vim.keymap.set("n", "<leader>Ms", "<cmd>MarpStatus<cr>", { desc = "MARP Status", noremap = true, silent = true })

--
-- LLM
--
vim.keymap.set("n", "<leader>az", ":AugmentCode<CR>", { desc = "Augment Code", noremap = true, silent = true })
vim.keymap.set("n", "<leader>ax", ":AugmentExplain<CR>", { desc = "Explain Code", noremap = true, silent = true })
vim.keymap.set("n", "<leader>af", ":AugmentRefactor<CR>", { desc = "Refactor Code", noremap = true, silent = true })
