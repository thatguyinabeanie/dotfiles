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
  }
}
