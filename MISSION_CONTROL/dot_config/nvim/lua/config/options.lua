-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.lazyvim_check_order = true

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.opt.shell = "/bin/zsh"

-- LazyVim auto format
vim.g.autoformat = false

-- Snacks animations
-- Set to `false` to globally disable all snacks animations
vim.g.snacks_animate = true

-- LazyVim picker to use.
-- Can be one of: telescope, fzf
-- Leave it to "auto" to automatically use the picker
-- enabled with `:LazyExtras`
-- vim.g.lazyvim_picker = "snacks"

-- LazyVim completion engine to use.
-- Can be one of: nvim-cmp, blink.cmp
-- Leave it to "auto" to automatically use the completion engine
-- enabled with `:LazyExtras`
vim.g.lazyvim_cmp = "auto"

-- LazyVim completion engine to use.
-- Using blink.cmp as the completion engine
vim.g.lazyvim_blink_main = true

-- if the completion engine supports the AI source,
-- use that instead of inline suggestions
vim.g.ai_cmp = true

-- LazyVim root dir detection
-- Each entry can be:
-- * the name of a detector function like `lsp` or `cwd`
-- * a pattern or array of patterns like `.git` or `lua`.
-- * a function with signature `function(buf) -> string|string[]`
vim.g.root_spec = { "lsp", { ".git", "lua", "Gemfile" }, "cwd" }

vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.undodir = vim.env.HOME .. "/.local/state/nvim/undodir"
vim.opt.undofile = true
vim.opt.undolevels = 10000
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.wrap = false
vim.opt.smartindent = true
vim.opt.smartcase = true
vim.opt.grepprg = "rg --vimgrep"
vim.opt.expandtab = true
vim.opt.autowrite = true
vim.opt.confirm = true

vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

vim.opt.signcolumn = "yes"
vim.opt.numberwidth = 2 -- Adjust gutter width for better compatibility

vim.env.PATH = vim.env.HOME .. "/.local/share/mise/shims:" .. vim.env.PATH
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

  -- 3. Fall back to mise shim (globally managed versions)
  local mise_python = vim.env.HOME .. "/.local/share/mise/shims/python3"
  if vim.fn.executable(mise_python) == 1 then
    return mise_python
  end

  -- 4. System Python as last resort
  return "python3"
end

vim.g.python3_host_prog = get_python_path()


