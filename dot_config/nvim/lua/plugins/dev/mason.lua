-- Mason tool management and auto-installation
-- Fallback configuration when template is not generated
local config = {
  mason = {
    core_tools = {},
    lspconfig_servers = {},
    formatters = {},
    linters = {},
    exploration_tools = {},
  },
  filetypes = {
    lsp_servers = {},
  },
}

-- Try to load the template-generated config, fallback to defaults if not available
local ok, template_config = pcall(require, "utils.language-config")
if ok then
  config = template_config
end

return {
  -- Mason: Core tools
  {
    "mason-org/mason.nvim",
    opts = {
      -- Enhanced UI and performance settings
      ui = {
        border = "rounded",
        width = 0.8,
        height = 0.8,
      },
      ensure_installed = config.mason.core_tools,
    },
  },

   -- Mason LSP configuration bridge
   {
     "mason-org/mason-lspconfig.nvim",
     dependencies = { "mason-org/mason.nvim" },
     -- Updated events for better LSP attachment
     event = { "BufReadPre", "BufNewFile", "BufWritePre" },
     opts = {
       -- Ensure installed servers from our template config (using lspconfig names)
       ensure_installed = config.mason.lspconfig_servers,
       -- Let LazyVim handle LSP setup to avoid conflicts
       handlers = nil,
     },
   },

  -- Mason: Auto-installer for exploration tools
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason-org/mason.nvim", "mason-org/mason-lspconfig.nvim" },
    event = "VeryLazy",

    opts = {
      ensure_installed = {}, -- Temporarily disable auto-installation
      auto_update = false,
      run_on_start = false, -- Disable run on start to prevent freeze
      start_delay = 3000,
      debounce_hours = 5,
    },

    config = function(_, opts)
      -- Temporarily disable mason-tool-installer to prevent freeze
      -- require("mason-tool-installer").setup(opts)

      -- Auto-install LSP servers on filetype detection (temporarily disabled to fix freeze)
      -- vim.api.nvim_create_autocmd("FileType", {
      --   callback = function(event)
      --     -- Safely access lsp_servers mapping
      --     local lsp_servers = config.filetypes and config.filetypes.lsp_servers
      --     if not lsp_servers then
      --       return
      --     end
      --
      --     local server = lsp_servers[event.match]
      --     if server then
      --       local mason_registry = require("mason-registry")
      --       if not mason_registry.is_installed(server) then
      --         vim.notify("Installing " .. server .. " for " .. event.match .. "...", vim.log.levels.INFO)
      --         vim.cmd("MasonInstall " .. server)
      --       end
      --     end
      --   end,
      -- })
    end,
  },
}
