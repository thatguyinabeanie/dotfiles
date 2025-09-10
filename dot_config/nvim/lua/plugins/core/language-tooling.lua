-- Unified language tooling configuration
-- Combines Mason, LSP, TreeSitter, and auto-installation

-- Load pre-compiled configuration (lightning fast!)
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

  -- LSP configuration
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        bashls = { filetypes = { "sh", "bash", "zsh", "sh.tmpl", "zsh.tmpl" } },
        lua_ls = {
          filetypes = { "lua", "lua.tmpl" },
          root_dir = function(fname)
            if vim.fn.stridx(fname, ".chezmoitemplates") ~= -1 then
              return nil
            end
            return require("lspconfig.util").root_pattern(".git")(fname)
          end,
        },
        nushell = { filetypes = { "nu", "nu.tmpl" } },
        ruby_lsp = {},
        taplo = { filetypes = { "toml", "toml.tmpl" } },

        -- Disable problematic TypeScript servers
        eslint = {
          settings = {
            workingDirectories = { mode = "auto" },
            experimental = {
              useFlatConfig = true,
            },
          },
        },
        tsserver = { enabled = true },
        vtsls = { enabled = true }, -- Disable vtsls due to inlay hint issues
      },
    },
  },

  -- TreeSitter configuration
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = { "RRethy/nvim-treesitter-endwise" },
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },

    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
      -- Register template file associations
      for parser, templates in pairs(config.filetypes.templates) do
        local tmpl_list = type(templates) == "table" and templates or { templates }
        for _, tmpl in ipairs(tmpl_list) do
          vim.treesitter.language.register(parser, tmpl)
        end
      end
    end,

    opts = {
      auto_install = true,
      endwise = { enable = true },
      ensure_installed = config.treesitter.parsers,
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

  -- Tailwind Tools
  {
    "luckasRanarison/tailwind-tools.nvim",
    name = "tailwind-tools",
    dependencies = { "nvim-treesitter/nvim-treesitter", "neovim/nvim-lspconfig" },
    build = ":UpdateRemotePlugins",
    lazy = true,

    ft = config.filetypes.web_frameworks,

    cmd = {
      "TailwindConcealEnable",
      "TailwindConcealDisable",
      "TailwindConcealToggle",
      "TailwindColorEnable",
      "TailwindColorDisable",
      "TailwindColorToggle",
      "TailwindSort",
      "TailwindSortOnSaveEnable",
      "TailwindSortOnSaveDisable",
      "TailwindSortOnSaveToggle",
    },

    opts = {
      server = { override = true, settings = {}, on_attach = function() end },
      document_color = { enabled = true, kind = "inline", inline_symbol = "󰝤 ", debounce = 200 },
      conceal = { enabled = false, min_length = nil, symbol = "󱏿", highlight = { fg = "#38BDF8" } },
      telescope = { utilities = { callback = function() end } },
    },
  },

  -- LazyDev
  {
    "folke/lazydev.nvim",
    ft = "lua",
    cmd = "LazyDev",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        { path = "LazyVim", words = { "LazyVim" } },
        { path = "snacks.nvim", words = { "Snacks" } },
        { path = "lazy.nvim", words = { "LazyVim" } },
      },
    },
  },

  --  -- Configure nvim-lint for ERB files
  -- {
  --   "mfussenegger/nvim-lint",
  --   opts = {
  --     linters_by_ft = {
  --       ["yaml.erb"] = { "erb_lint" },
  --       ["html.erb"] = { "erb_lint" },
  --     },
  --   },
  -- },
  -- -- Configure conform.nvim for ERB formatting
  -- {
  --   "stevearc/conform.nvim",
  --   opts = {
  --     formatters_by_ft = {
  --       ["yaml.erb"] = { "erb_format" },
  --       ["html.erb"] = { "erb_format" },
  --     },
  --   },
  -- },
  -- -- Disable ruby_lsp for ERB files to avoid mysql2 compilation issues 1Code has comments. Press enter to view.
  -- {
  --   "neovim/nvim-lspconfig",
  --   opts = {
  --     servers = {
  --       ruby_lsp = {
  --         filetypes = { "ruby" }, -- Remove erb from filetypes
  --       },
  --     },
  --   },
  -- },
  --
}
