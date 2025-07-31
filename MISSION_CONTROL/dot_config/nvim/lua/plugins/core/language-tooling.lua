-- Unified language tooling configuration
-- Combines Mason, LSP, TreeSitter, and auto-installation

-- Shared configuration
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

-- TreeSitter parsers to ensure are installed
local treesitter_ensure_installed = {
  "bash",
  "lua",
  "javascript",
  "typescript",
  "tsx",
  "html",
  "css",
  "scss",
  "vue",
  "svelte",
  "json",
  "yaml",
  "toml",
  "xml",
  "csv",
  "markdown",
  "markdown_inline",
  "vimdoc",
  "dockerfile",
  "nginx",
  "ssh_config",
  "git_config",
  "gitignore",
  "cmake",
  "comment",
  "diff",
  "dot",
  "embedded_template",
  "elixir",
  "gleam",
  "gpg",
  "graphql",
  "java",
  "jq",
  "kotlin",
  "llvm",
  "luadoc",
  "latex",
  "nu",
  "nix",
  "norg",
  "proto",
  "query",
  "readline",
  "r",
  "regex",
  "rust",
  "ruby",
  "swift",
  "superhtml",
  "sql",
  "scala",
  "tmux",
  "typst",
  "terraform",
  "vim",
  "zig",
}

-- Mason core tools (always installed)
local mason_core_tools = {
  "lua-language-server",
  "stylua",
  "marksman",
  "vale",
  "json-lsp",
  "yaml-language-server",
  "tailwindcss-language-server",
  "copilot-language-server",
  "bash-language-server",
  "shellcheck",
  "eslint_d",
  "eslint-lsp",
  "prettierd",
  -- Ruby workflow
  "ruby-lsp",
  "standardrb",
  "haml-lint",
}

-- Mason exploration tools (installed on-demand)
local mason_exploration_tools = {
  "css-lsp",
  "dockerfile-language-server",
  "html-lsp",
  "rust-analyzer",
  "gopls",
  "prettier",
}

-- Add conditional TypeScript tool to core
if use_typescript_tools then
  table.insert(mason_core_tools, "typescript-language-server")
end

-- Filetype mappings
local template_filetypes = {
  lua = "lua.tmpl",
  toml = "toml.tmpl",
  bash = { "sh.tmpl", "zsh.tmpl" },
  nu = "nu.tmpl",
}

local lsp_filetype_map = {
  javascript = "typescript-language-server",
  typescript = "typescript-language-server",
  javascriptreact = "typescript-language-server",
  typescriptreact = "typescript-language-server",
  rust = "rust-analyzer",
  go = "gopls",
  css = "css-lsp",
  html = "html-lsp",
  dockerfile = "dockerfile-language-server",
}

return {
  -- Mason core configuration
  {
    "mason-org/mason.nvim",
    version = "v2",
    opts = { ensure_installed = mason_core_tools },
  },

  -- LSP configuration with conditional TypeScript server handling
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        bashls = { filetypes = { "sh", "bash", "zsh", "sh.tmpl", "zsh.tmpl" } },
        lua_ls = { filetypes = { "lua", "lua.tmpl" } },
        nushell = { filetypes = { "nu", "nu.tmpl" } },
        ruby_lsp = {},
        taplo = { filetypes = { "toml", "toml.tmpl" } },
        -- Conditionally disable TypeScript servers based on Node version
        tsserver = { enabled = not use_typescript_tools },
        ts_ls = { enabled = not use_typescript_tools },
        vtsls = { enabled = not use_typescript_tools },
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
      for parser, templates in pairs(template_filetypes) do
        if type(templates) == "table" then
          for _, tmpl in ipairs(templates) do
            vim.treesitter.language.register(parser, tmpl)
          end
        else
          vim.treesitter.language.register(parser, templates)
        end
      end
    end,
    opts = {
      auto_install = true,
      endwise = { enable = true },
      ensure_installed = treesitter_ensure_installed,
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

  -- Mason tool auto-installer for language exploration
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason-org/mason.nvim", "mason-org/mason-lspconfig.nvim" },
    opts = {
      ensure_installed = mason_exploration_tools,
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
          local server = lsp_filetype_map[event.match]
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
        filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
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
