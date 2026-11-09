-- Mason tool management and auto-installation
-- Fallback configuration when template is not generated
local config = {
  mason = {
    core_tools = {},
    lspconfig_servers = {},
    formatters = {},
    linters = {},
    exploration_tools = {},
    remove = {},
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

-- Mason package names flagged "install: false", as a set
local removed = {}
for _, name in ipairs(config.mason.remove or {}) do
  removed[name] = true
end

-- lspconfig names of the removed packages, from the same mason-lspconfig map LazyVim installs servers by.
-- The map needs mason's registry, which is loaded by the time LazyVim resolves these opts.
local function removed_servers()
  local servers = {}
  if next(removed) == nil then
    return servers
  end
  local found, map = pcall(function()
    return require("mason-lspconfig.mappings").get_mason_map().package_to_lspconfig
  end)
  if not found then
    return servers
  end
  for name in pairs(removed) do
    if map[name] then
      servers[map[name]] = true
    end
  end
  return servers
end

local function without(list, names)
  return vim.tbl_filter(function(name)
    return not names[name]
  end, list)
end

-- LazyVim (re)installs every name in these lists on each launch, so removed packages are filtered out.
-- The opts are functions so the filter sees the lists LazyVim and its extras merged in first.
return {
  -- Mason: Core tools
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      -- Enhanced UI and performance settings
      opts.ui = vim.tbl_deep_extend("force", opts.ui or {}, {
        border = "rounded",
        width = 0.8,
        height = 0.8,
      })
      -- LazyVim's opts_extend appends list values, so extend rather than replace.
      -- The rendered language-config has no core_tools today, hence the `or {}`.
      local ensure = vim.list_extend(opts.ensure_installed or {}, config.mason.core_tools or {})
      opts.ensure_installed = without(ensure, removed)
    end,
  },

  -- LazyVim installs each server in opts.servers through mason-lspconfig. mason = false stops that
  -- for removed packages; the server still starts if its binary is on PATH from another manager.
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      for server in pairs(removed_servers()) do
        local server_opts = opts.servers and opts.servers[server]
        -- LazyVim accepts `server = true` as shorthand for {}
        if server_opts == true then
          server_opts = {}
        end
        if type(server_opts) == "table" then
          server_opts.mason = false
          opts.servers[server] = server_opts
        end
      end
    end,
  },

  -- Mason LSP configuration bridge
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = { "mason-org/mason.nvim" },
    -- Updated events for better LSP attachment
    event = { "BufReadPre", "BufNewFile", "BufWritePre" },
    opts = function(_, opts)
      -- Ensure installed servers from our template config (using lspconfig names).
      -- LazyVim passes this list to mason-lspconfig's ensure_installed.
      opts.ensure_installed = without(vim.list_extend({}, config.mason.lspconfig_servers or {}), removed_servers())
      -- Use setup_handlers for better control over LSP server initialization
      opts.handlers = {
        -- Default handler for all servers
        function(server_name)
          require("lspconfig")[server_name].setup({})
        end,
      }
    end,
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
      auto_update = true,
      run_on_start = true, -- Disable run on start to prevent freeze
      start_delay = 3000,
      debounce_hours = 5,
    },

    config = function(_, opts)
      require("mason-tool-installer").setup(opts)

      -- Uninstall packages flagged "install: false" in .chezmoidata
      local registry = require("mason-registry")
      for _, name in ipairs(config.mason.remove or {}) do
        if registry.is_installed(name) then
          -- get_package throws for names missing from the registry
          local found, pkg = pcall(registry.get_package, name)
          if found then
            -- uninstall asserts (e.g. "already uninstalling"); pcall keeps the autocmd below registered
            local started, start_err = pcall(pkg.uninstall, pkg, {}, function(success, err)
              -- the callback may run in a fast event context
              vim.schedule(function()
                if success then
                  vim.notify("Mason: uninstalled " .. name, vim.log.levels.INFO)
                else
                  vim.notify("Mason: failed to uninstall " .. name .. ": " .. tostring(err), vim.log.levels.WARN)
                end
              end)
            end)
            if not started then
              vim.notify("Mason: failed to uninstall " .. name .. ": " .. tostring(start_err), vim.log.levels.WARN)
            end
          end
        end
      end

      -- Auto-install LSP servers on filetype detection
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(event)
          -- Safely access lsp_servers mapping
          local lsp_servers = config.filetypes and config.filetypes.lsp_servers
          if not lsp_servers then
            return
          end

          local server = lsp_servers[event.match]
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
