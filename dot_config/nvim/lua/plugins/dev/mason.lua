-- Mason tool management and auto-installation
local config = require("utils.language-config")

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
      -- Use setup_handlers for better control over LSP server initialization
      handlers = {
        -- Default handler for all servers
        function(server_name)
          require("lspconfig")[server_name].setup({})
        end,
      },
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

    config = function(_, opts)
      require("mason-tool-installer").setup(opts)

      -- Auto-install LSP servers on filetype detection
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(event)
          local server = config.filetypes.lsp_servers[event.match]
          if server then
            local mason_registry = require("mason-registry")
            if not mason_registry.is_installed(server) then
              vim.notify("Installing " .. server .. " for " .. event.match .. "...", vim.log.levels.INFO)
              vim.cmd("MasonInstall " .. server)
            end
          end
        end,
      })
    end,
  },
}
