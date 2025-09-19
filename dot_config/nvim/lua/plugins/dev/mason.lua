-- Mason tool management and auto-installation
-- Updated for LazyVim 15.x compatibility with Mason v2.x API
local config = require("utils.language-config")

return {
  -- Mason: Core tools
  {
    "mason-org/mason.nvim",
    opts = {
      -- LazyVim 15.x: Enhanced UI and performance settings
      ui = {
        border = "rounded",
        width = 0.8,
        height = 0.8,
      },
    },
  },

  -- Mason LSP configuration bridge
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = { "mason-org/mason.nvim" },
    -- LazyVim 15.x: Updated events for better LSP attachment
    event = { "BufReadPre", "BufNewFile", "BufWritePre" },
    opts = {
      -- LazyVim 15.x: Use automatic_enable instead of setup_handlers
      automatic_enable = true,
      -- Ensure installed servers from our template config (using lspconfig names)
      ensure_installed = config.mason.lspconfig_servers,
    },
  },

  -- Mason: Auto-installer for exploration tools
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason-org/mason.nvim", "mason-org/mason-lspconfig.nvim" },
    event = "VeryLazy",

    opts = {
      ensure_installed = vim.list_extend(
        config.mason.formatters,
        vim.list_extend(config.mason.linters, config.mason.exploration_tools)
      ),
      auto_update = false,
      run_on_start = true,
      start_delay = 3000,
      debounce_hours = 5,
    },
  },
}
