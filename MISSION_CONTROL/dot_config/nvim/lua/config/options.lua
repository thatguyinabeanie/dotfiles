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
-- Using blink.cmp as the completion engine
vim.g.lazyvim_blink_main = false

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

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

vim.opt.signcolumn = "yes"
vim.opt.numberwidth = 2  -- Adjust gutter width for better compatibility

vim.env.PATH = vim.env.HOME .. "/.local/share/mise/shims:" .. vim.env.PATH

-- Provider configurations
-- Set Python3 provider to use mise shim (stable path that dynamically resolves versions)
vim.g.python3_host_prog = vim.env.HOME .. "/.local/share/mise/shims/python3"

-- Disable Perl provider (optional, reduces health check warnings)
vim.g.loaded_perl_provider = 0

