-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- This file is automatically loaded by plugins.core
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Snacks animations
-- Set to `false` to globally disable all snacks animations
vim.g.snacks_animate = true

-- LazyVim picker to use.
-- Can be one of: telescope, fzf
-- Leave it to "auto" to automatically use the picker
-- enabled with `:LazyExtras`
vim.g.lazyvim_picker = "auto"

-- LazyVim completion engine to use.
-- Can be one of: nvim-cmp, blink.cmp
-- Leave it to "auto" to automatically use the completion engine
-- enabled with `:LazyExtras`
vim.g.lazyvim_cmp = "auto"

-- if the completion engine supports the AI source,
-- use that instead of inline suggestions
vim.g.ai_cmp = true

-- Optionally setup the terminal to use
-- This sets `vim.o.shell` and does some additional configuration for:
-- * pwsh
-- * powershell
-- LazyVim.terminal.setup("pwsh")

-- Set LSP servers to be ignored when used with `util.root.detectors.lsp`
-- for detecting the LSP root
vim.g.root_lsp_ignore = { "copilot" }

-- Hide deprecation warnings
vim.g.deprecation_warnings = false

-- Show the current document symbols location from Trouble in lualine
-- You can disable this for a buffer by setting `vim.b.trouble_lualine = false`
vim.g.trouble_lualine = true

local opt = vim.opt

opt.autowrite = true -- Enable auto write
-- only set clipboard if not in ssh, to make sure the OSC 52
-- integration works automatically. Requires Neovim >= 0.10.0
opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" -- Sync with system clipboard
opt.completeopt = "menu,menuone,noselect"
opt.conceallevel = 2 -- Hide * markup for bold and italic, but not markers with substitutions
opt.confirm = true -- Confirm to save changes before exiting modified buffer
opt.cursorline = true -- Enable highlighting of the current line
opt.expandtab = true -- Use spaces instead of tabs
opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}
opt.foldlevel = 99
opt.formatexpr = "v:lua.require'lazyvim.util'.format.formatexpr()"
opt.formatoptions = "jcroqlnt" -- tcqj
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.ignorecase = true -- Ignore case
opt.inccommand = "nosplit" -- preview incremental substitute
opt.jumpoptions = "view"
opt.laststatus = 3 -- global statusline
opt.linebreak = true -- Wrap lines at convenient points
opt.list = true -- Show some invisible characters (tabs...
opt.mouse = "a" -- Enable mouse mode
opt.number = true -- Print line number
opt.pumblend = 10 -- Popup blend
opt.pumheight = 10 -- Maximum number of entries in a popup
opt.relativenumber = true -- Relative line numbers
opt.ruler = false -- Disable the default ruler
opt.scrolloff = 4 -- Lines of context
opt.sessionoptions = {
  "buffers",
  "curdir",
  "tabpages",
  "winsize",
  "help",
  "globals",
  "skiprtp",
  "folds",
  "winpos",
  "terminal",
  "localoptions",
}
opt.shiftround = true -- Round indent
opt.shiftwidth = 2 -- Size of an indent
opt.shortmess:append({ W = true, I = true, c = true, C = true })
opt.showmode = false -- Dont show mode since we have a statusline
opt.sidescrolloff = 8 -- Columns of context
opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
opt.smartcase = true -- Don't ignore case with capitals
opt.smartindent = true -- Insert indents automatically
opt.spelllang = { "en" }
opt.splitbelow = true -- Put new windows below current
opt.splitkeep = "screen"
opt.splitright = true -- Put new windows right of current
opt.statuscolumn = [[%!v:lua.require'snacks.statuscolumn'.get()]]
opt.tabstop = 2 -- Number of spaces tabs count for
opt.termguicolors = true -- True color support
opt.timeoutlen = vim.g.vscode and 1000 or 300 -- Lower than default (1000) to quickly trigger which-key
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200 -- Save swap file and trigger CursorHold
opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
opt.wildmode = "longest:full,full" -- Command-line completion mode
opt.winminwidth = 5 -- Minimum window width
opt.wrap = false -- Disable line wrap

if vim.fn.has("nvim-0.10") == 1 then
  opt.smoothscroll = true
  opt.foldexpr = "v:lua.require'lazyvim.util'.ui.foldexpr()"
  opt.foldmethod = "expr"
  opt.foldtext = ""
else
  opt.foldmethod = "indent"
  opt.foldtext = "v:lua.require'lazyvim.util'.ui.foldtext()"
end

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

-- EVERYTHING BELOW THIS LINE ARE MY PERSONAL PREFERENCES

opt.shell = "/bin/zsh"

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
vim.g.root_spec = {
  "lsp",
  {
    -- Version control
    ".git",

    -- Project config files
    "package.json",
    "yarn.lock",
    "pnpm-lock.yaml",
    "bun.lockb",
    "Cargo.toml",
    "Cargo.lock",
    "go.mod",
    "go.sum",
    "pyproject.toml",
    "setup.py",
    "requirements.txt",
    "Pipfile",
    "poetry.lock",
    "Gemfile",
    "Gemfile.lock",
    "composer.json",
    "composer.lock",
    "mix.exs",
    "rebar.config",
    "deno.json",
    "deno.jsonc",

    -- Build tools
    "Makefile",
    "CMakeLists.txt",
    "meson.build",
    "build.gradle",
    "pom.xml",
    "build.sbt",
    "stack.yaml",
    "cabal.project",
    "flake.nix",
    "shell.nix",

    -- Config files
    ".neoconf.json",
    "lua",
    "mise.toml",
    ".mise.toml",

    -- Directories
    "node_modules",
    ".venv",
    "venv",
    "src",
    "lib",
    "app",
  },
  "cwd",
}

opt.backup = false
opt.swapfile = false
opt.undodir = vim.env.HOME .. "/.local/state/nvim/undodir"
opt.undofile = true
opt.undolevels = 10000
opt.hlsearch = true
opt.incsearch = true
opt.wrap = false
opt.smartindent = true
opt.smartcase = true
opt.grepprg = "rg --vimgrep"
opt.expandtab = true
opt.autowrite = true
opt.confirm = true
opt.signcolumn = "yes"
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

