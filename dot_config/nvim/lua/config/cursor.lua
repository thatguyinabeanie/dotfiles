-- Cursor configuration for consistent blinking hollow box appearance
-- This ensures cursor is properly restored when exiting Neovim

local M = {}

-- ANSI escape sequences for cursor shapes
local cursor_shapes = {
  block_blink = "\027[1 q", -- Blinking block (hollow box)
  block_steady = "\027[2 q", -- Steady block
  underline_blink = "\027[3 q", -- Blinking underline
  underline_steady = "\027[4 q", -- Steady underline
  bar_blink = "\027[5 q", -- Blinking bar
  bar_steady = "\027[6 q", -- Steady bar
}

-- Set cursor to blinking hollow box (default terminal cursor)
local function set_default_cursor()
  io.write(cursor_shapes.block_blink)
  io.flush()
end

-- Configure Neovim cursor shapes for different modes
local function setup_neovim_cursors()
  vim.opt.guicursor = {
    "n-v-c:block", -- Normal, visual, command modes: block cursor
    "i-ci-ve:ver25", -- Insert, command insert, visual exclusive: 25% vertical bar
    "r-cr:hor20", -- Replace, command replace: 20% horizontal line
    "o:hor50", -- Operator pending: 50% horizontal line
    "a:blinkwait700-blinkoff400-blinkon250", -- All modes: blink settings
    "sm:block-blinkwait175-blinkoff150-blinkon175", -- Showmatch: block cursor with fast blink
  }
end

-- Set up cursor restoration
local function setup_cursor_restoration()
  -- Create autocommand group for cursor management
  local cursor_group = vim.api.nvim_create_augroup("CursorShape", { clear = true })

  -- Restore default cursor when leaving Neovim
  vim.api.nvim_create_autocmd({ "VimLeave", "VimSuspend" }, {
    group = cursor_group,
    callback = set_default_cursor,
    desc = "Restore terminal cursor when leaving Neovim",
  })

  -- Set default cursor when entering Neovim (in case terminal didn't set it properly)
  vim.api.nvim_create_autocmd("VimEnter", {
    group = cursor_group,
    callback = function()
      -- Small delay to ensure terminal is ready
      vim.defer_fn(setup_neovim_cursors, 100)
    end,
    desc = "Setup Neovim cursor shapes on enter",
  })

  -- Restore cursor when switching back to terminal from Neovim
  vim.api.nvim_create_autocmd("FocusLost", {
    group = cursor_group,
    callback = set_default_cursor,
    desc = "Restore terminal cursor when losing focus",
  })
end

-- Initialize cursor configuration
function M.setup()
  setup_neovim_cursors()
  setup_cursor_restoration()
end

return M
