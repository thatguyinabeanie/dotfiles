-- Unified language tooling configuration
-- Combines Mason, LSP, TreeSitter, and auto-installation

-- Check Node version for dynamic TypeScript LSP selection
local function get_node_version()
  local result = vim.fn.system("node --version 2>/dev/null")
  if result and result ~= "" then
    local major = result:match("v(%d+)")
    return tonumber(major)
  end
  return nil
end

local node_version = get_node_version()
local use_typescript_tools = not node_version or node_version < 16

return {
  -- TreeSitter configuration
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = { "RRethy/nvim-treesitter-endwise" },
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
      -- Register template file associations
      vim.treesitter.language.register("lua", "lua.tmpl")
      vim.treesitter.language.register("toml", "toml.tmpl")
      vim.treesitter.language.register("bash", "sh.tmpl")
      vim.treesitter.language.register("bash", "zsh.tmpl")
      vim.treesitter.language.register("nu", "nu.tmpl")
    end,
    opts = {
      auto_install = true,
      endwise = { enable = true },
      ensure_installed = {
        -- Core languages
        "bash", "lua", "python", "javascript", "typescript", "tsx",
        
        -- Web development
        "html", "css", "scss", "vue", "svelte",
        
        -- Configuration/Data
        "json", "yaml", "toml", "xml", "csv",
        
        -- Documentation
        "markdown", "markdown_inline", "vimdoc",
        
        -- System/DevOps
        "dockerfile", "nginx", "ssh_config", "git_config", "gitignore",
        
        -- Other languages (from your chezmoidata)
        "cmake", "comment", "diff", "dot", "embedded_template", "elixir",
        "gleam", "gpg", "graphql", "java", "jq", "kotlin", "llvm", "luadoc",
        "latex", "nu", "nix", "norg", "proto", "query", "readline", "r",
        "regex", "rust", "ruby", "swift", "superhtml", "sql", "scala",
        "tmux", "typst", "terraform", "vim", "zig",
      },
      highlight = { enable = true },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
    },
  },

  -- Mason core configuration
  {
    "mason-org/mason.nvim",
    version = "v2",
    opts = {
      ensure_installed = (function()
        local tools = {
          -- Core workflow tools (always installed)
          "lua-language-server",
          "stylua",
          "marksman",
          "vale",
          "json-lsp",
          "yaml-language-server",
          "tailwindcss-language-server",
          "copilot-language-server",

          -- TypeScript/JavaScript (conditional based on Node version)
          use_typescript_tools and "typescript-language-server" or nil,
          "eslint_d",
          "eslint-lsp", 
          "prettierd",

          -- Ruby workflow
          "ruby-lsp",
          "standardrb",
          "haml-lint",

          -- Additional tools for common languages
          "bash-language-server",
          "shellcheck",
        }
        
        -- Filter out nil values
        local filtered_tools = {}
        for _, tool in ipairs(tools) do
          if tool ~= nil then
            table.insert(filtered_tools, tool)
          end
        end
        return filtered_tools
      end)(),
    },
  },

  -- Mason tool auto-installer for language exploration
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
    },
    opts = {
      -- Additional tools for language exploration (beyond core workflow)
      ensure_installed = {
        -- LSP servers for exploration
        "css-lsp",
        "dockerfile-language-server", 
        "html-lsp",
        "pyright",
        "rust-analyzer",
        "gopls",

        -- Formatters
        "black",
        "prettier",
        "ruff",
      },
      auto_update = false,
      run_on_start = true,
      start_delay = 3000,
      debounce_hours = 5,
    },
    config = function(_, opts)
      require("mason-tool-installer").setup(opts)

      -- Auto-install LSP servers when opening new filetypes
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(event)
          local filetype = event.match
          local lsp_servers = {
            -- Map filetypes to LSP server names
            javascript = "typescript-language-server",
            typescript = "typescript-language-server",
            javascriptreact = "typescript-language-server", 
            typescriptreact = "typescript-language-server",
            python = "pyright",
            rust = "rust-analyzer",
            go = "gopls",
            css = "css-lsp",
            html = "html-lsp",
            dockerfile = "dockerfile-language-server",
          }

          local server = lsp_servers[filetype]
          if server then
            local mason_registry = require("mason-registry")
            if not mason_registry.is_installed(server) then
              vim.notify("Installing " .. server .. " for " .. filetype .. "...", vim.log.levels.INFO)
              vim.cmd("MasonInstall " .. server)
            end
          end
        end,
      })
    end,
  },

  -- LSP configuration with conditional TypeScript server handling
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        bashls = {
          filetypes = { "sh", "bash", "zsh", "sh.tmpl", "zsh.tmpl" },
        },
        lua_ls = {
          filetypes = { "lua", "lua.tmpl" },
        },
        nushell = {
          filetypes = { "nu", "nu.tmpl" },
        },
        ruby_lsp = {},
        taplo = {
          filetypes = { "toml", "toml.tmpl" },
        },
        -- Conditionally disable TypeScript servers based on Node version
        tsserver = {
          enabled = not use_typescript_tools,
        },
        ts_ls = {
          enabled = not use_typescript_tools,
        },
        vtsls = {
          enabled = not use_typescript_tools,
        },
      },
    },
  },

  -- TypeScript Tools (only for Node < 16 or no Node.js)
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    enabled = use_typescript_tools,
    ft = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
    config = function()
      require("typescript-tools").setup({
        on_attach = function(client, _)
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        end,
        filetypes = {
          "javascript",
          "javascriptreact", 
          "typescript",
          "typescriptreact",
          "vue",
        },
        settings = {
          jsx_close_tag = {
            enable = true,
            filetypes = { "javascriptreact", "typescriptreact" },
          },
        },
      })
    end,
  },

  -- Tailwind Tools (always enabled)
  {
    "luckasRanarison/tailwind-tools.nvim",
    name = "tailwind-tools",
    build = ":UpdateRemotePlugins",
    lazy = true,
    ft = { "html", "css", "scss", "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "svelte" },
    cmd = { 
      "TailwindConcealEnable", "TailwindConcealDisable", "TailwindConcealToggle",
      "TailwindColorEnable", "TailwindColorDisable", "TailwindColorToggle",
      "TailwindSort", "TailwindSortOnSaveEnable", "TailwindSortOnSaveDisable", "TailwindSortOnSaveToggle"
    },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-telescope/telescope.nvim", 
      "neovim/nvim-lspconfig",
    },
    opts = {
      server = {
        override = true,
        settings = {},
        on_attach = function() end,
      },
      document_color = {
        enabled = true,
        kind = "inline",
        inline_symbol = "󰝤 ",
        debounce = 200,
      },
      conceal = {
        enabled = false,
        min_length = nil,
        symbol = "󱏿",
        highlight = {
          fg = "#38BDF8",
        },
      },
      telescope = {
        utilities = {
          callback = function() end,
        },
      },
    },
  },
}