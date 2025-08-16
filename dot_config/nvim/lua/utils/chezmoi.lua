---@diagnostic disable: undefined-global

local M = {}

local function open_file_in_floating_window(filepath)
  -- Create a new buffer and immediately load the file
  local buf = vim.api.nvim_create_buf(false, false)

  -- Load the file into the buffer
  vim.api.nvim_buf_call(buf, function()
    vim.cmd("edit " .. vim.fn.fnameescape(filepath))
  end)

  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
  })

  -- Ensure the file is loaded
  vim.api.nvim_win_call(win, function()
    vim.cmd("edit! " .. vim.fn.fnameescape(filepath))
  end)
end

function M.open_config_toml()
  local chezmoi_config = vim.fn.expand("~/.config/chezmoi/chezmoi.toml")
  open_file_in_floating_window(chezmoi_config)
end

function M.find_files()
  local chezmoi_path = vim.fn.expand("~/.local/share/chezmoi")
  require("snacks").picker.files({ cwd = chezmoi_path })
end

return M
