-- Mason tool management and auto-installation
local config = require("utils.language-config")

return {
  -- Mason: Core tools
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = config.mason.core_tools },
  },

  -- Mason LSP configuration bridge
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = { "mason-org/mason.nvim" },
    opts = {},
  },

  -- Mason: Auto-installer for exploration tools
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason-org/mason.nvim", "mason-org/mason-lspconfig.nvim" },
    event = "VeryLazy",

    opts = {
      ensure_installed = config.mason.exploration_tools,
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