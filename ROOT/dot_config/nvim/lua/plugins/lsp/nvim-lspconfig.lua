local lspconfig = require("lspconfig")

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "saghen/blink.cmp",
    },
    ---@class PluginLspOpts
    opts = {
      servers = {
        bashls = {
          enabled = true,
          filetypes = { "sh", "bash", "zsh", "sh.tmpl", "zsh.tmpl" },
        },


        lua_ls = {
          enabled = true,
          filetypes = { "lua", "lua.tmpl" },
        },
        nushell = {
          enabled = true,
          filetypes = { "nu", "nu.tmpl" },
        },
        ruby_lsp = {
          enabled = true,
        },
        rubocop = {
          enabled = false,
        },
        solargraph = {
          enabled = false,
        },
        taplo = {
          enabled = true,
          filetypes = { "toml", "toml.tmpl" },
        },
        tsserver = {
          enabled = false,
        },
        ts_ls = {
          enabled = false,
        },
        vtsls = {
          enabled = false,
        },
      },
    },

    config = function(_, opts)
      if not lspconfig then
        vim.notify("Failed to load lspconfig", vim.log.levels.ERROR)
        return
      end

      -- Setup LSP keymaps when an LSP attaches to a buffer
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          local bufnr = ev.buf
          local client = vim.lsp.get_client_by_id(ev.data.client_id)

          if not client then
            vim.notify("No LSP client found for buffer", vim.log.levels.WARN)
            return
          end
          -- Enable completion triggered by <c-x><c-o>
          vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

          -- Buffer local mappings
          local map_opts = { buffer = bufnr, noremap = true, silent = true }
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, map_opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, map_opts)
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, map_opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, map_opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, map_opts)
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, map_opts)
          vim.keymap.set("n", "<leader>f", function()
            vim.lsp.buf.format({ async = true })
          end, map_opts)
        end,
      })

      for server, config in pairs(opts.servers) do
        config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
        if lspconfig[server] and lspconfig[server].setup then
          lspconfig[server].setup(config)
        end
      end
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        "shellcheck",
        "shfmt",
        "flake8",
        "ruby-lsp",
        "tailwindcss-language-server",
        "ast-grep",
        "eslint_d",
        "eslint-lsp",
        "bash-debug-adapter",
        "bash-language-server",
        "prettierd",
        "copilot-language-server",
        "dockerfile-language-server",
        "docker-compose-language-service",
        "gh-actions-language-server",
        "coffeesense-language-server",
        "cmake-language-server",
        "vim-language-server",
        "yaml-language-server",
        "llm-ls",
        "postgrestools",
        "luacheck",
        "luaformatter",
        "luau-lsp",
        "lua-language-server",
        "selene",
        "dot-language-server",
        "elixir-ls",
        "jsonlint",
        "jq",
        "jq-lsp",
        "json-lsp",
        "rust-analyzer",
        "snyk-ls",
        "systemd-language-server",
        "stylua",
        "tree-sitter-cli",
        "beautysh",
        "chrome-debug-adapter",
        "colorgen-nvim",
        "css-lsp",
        "css-variables-language-server",
        "cssmodules-language-server",
        "dotenv-linter",
        "gradle-language-server",
        "jinja-lsp",
        "nginx-language-server",
        "nginx-config-formatter",
        "node-debug2-adapter",
        "sql-formatter",
        "yq",
        "taplo",
        "codeql",
        "kotlin-language-server",
        "some-sass-language-server",
        "cpptools",
        "kotlin-debug-adapter",
        "vscode-java-decompiler",
        "checkstyle",
        "checkmake",
        "cspell",
        "haml-lint",
        "markdownlint",
        "typos",
        "yamllint",
        "standardrb",
        "typescript-language-server",
        "vtsls",
        "zls",
      },
    },
  },
}
