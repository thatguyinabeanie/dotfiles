local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

vim.opt.rtp:prepend(lazypath)


require("lazy").setup({
  spec = {
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    { import = "plugins/core" },
    { import = "plugins/llm" },
    { import = "plugins/ui" },
    { import = "plugins/snacks" },
    { import = "plugins/utilities" },
  },
  defaults = {
    lazy = false,
    version = false,
  },
  install = { colorscheme = { "catppuccin", "tokyonight", "habamax"} },
  checker = {
    enabled = true,
    notify = true,
    frequency = 3600, -- Check every hour (3600 seconds)
    check_pinned = false, -- Don't check pinned plugins
  },
  change_detection = {
    enabled = true,
    notify = true, -- Don't notify about config changes
  },
  ui = {
    border = "rounded",
  },
  rocks = {
    enabled = not (os.getenv("CI") == "true"), -- Disable luarocks in CI
    hererocks = not (os.getenv("CI") == "true"), -- Use hererocks locally, disable in CI
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
