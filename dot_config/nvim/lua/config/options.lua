-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- This file is automatically loaded by plugins.core
--
-- All LazyVim defaults have been removed to reduce noise.
-- Only custom settings that differ from LazyVim defaults are below.

local opt = vim.opt

-- PERSONAL PREFERENCES AND CUSTOMIZATIONS

opt.shell = "/bin/zsh"
opt.colorcolumn = "120" -- Show column guide at 120 characters

-- Zellij-friendly UI settings
opt.showtabline = 0 -- Never show tab line (Zellij handles tabs)
opt.laststatus = 3 -- Global statusline (one for all windows)

-- LazyVim auto format
vim.g.autoformat = false

-- LazyVim completion engine to use.
-- Using blink.cmp as the completion engine
vim.g.lazyvim_blink_main = true

-- LazyVim root dir detection
-- Each entry can be:
-- * the name of a detector function like `lsp` or `cwd`
-- * a pattern or array of patterns like `.git` or `lua`.
-- * a function with signature `function(buf) -> string|string[]`
vim.g.root_spec = {
  "lsp",
  {
    -- Version control
    ".git",
  },
  "cwd",
}

opt.backup = false
opt.swapfile = false
opt.undodir = vim.env.HOME .. "/.local/state/nvim/undodir"
opt.hlsearch = true
opt.incsearch = true
opt.autoread = true -- Auto-reload files changed outside of Neovim
opt.numberwidth = 2 -- Adjust gutter width for better compatibility
vim.g.lazyvim_prettier_needs_config = true
-- Disable Perl provider (optional, reduces health check warnings)
vim.g.loaded_perl_provider = 0

-- Provider configurations
-- Smart Python detection: respects virtual environments and mise
local function get_python_path()
  -- 1. Check for virtual environment first (respects .venv, venv, etc.)
  if vim.env.VIRTUAL_ENV then
    local venv_python = vim.env.VIRTUAL_ENV .. "/bin/python"
    if vim.fn.executable(venv_python) == 1 then
      return venv_python
    end
  end

  -- 2. Check for .venv in current working directory
  local cwd_venv = vim.fn.getcwd() .. "/.venv/bin/python"
  if vim.fn.executable(cwd_venv) == 1 then
    return cwd_venv
  end

  -- 3. Fall back to mise-managed Python (globally managed versions)
  local mise_python = "python3" -- mise handles PATH, so we can use the command directly
  if vim.fn.executable(mise_python) == 1 then
    return mise_python
  end

  -- 4. System Python as last resort
  return "python3"
end

vim.g.python3_host_prog = get_python_path()
