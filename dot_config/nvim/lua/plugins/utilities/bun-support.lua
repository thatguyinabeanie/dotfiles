-- Bun project support for Neovim
-- Provides enhanced support for Bun projects including package.json detection,
-- bun.lockb handling, and Bun-specific commands

return {
  -- Enhanced package.json support
  {
    "vuki656/package-info.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    ft = "json",
    config = function()
      require("package-info").setup({
        colors = {
          up_to_date = "#3C4048",
          outdated = "#d19a66",
        },
        icons = {
          enable = true,
          style = {
            up_to_date = "|  ",
            outdated = "|  ",
          },
        },
        autostart = true,
        hide_up_to_date = false,
        hide_unstable_versions = false,
        package_manager = "auto", -- Will detect bun, npm, yarn, pnpm automatically
      })
    end,
  },

  -- File type detection for Bun files
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- Ensure we have the parsers we need for Bun projects
      vim.list_extend(opts.ensure_installed or {}, {
        "javascript",
        "typescript",
        "tsx",
        "json",
        "jsonc",
      })
    end,
  },

  -- LSP configuration for Bun projects
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}

      -- Ensure vtsls is disabled to prevent inlay hint errors
      opts.servers.vtsls = { enabled = false }

      -- Use typescript-language-server instead for stability
      opts.servers.typescript_language_server = {
        enabled = true,
        settings = {
          typescript = {
            preferences = {
              includePackageJsonAutoImports = "on",
            },
          },
          javascript = {
            preferences = {
              includePackageJsonAutoImports = "on",
            },
          },
        },
        init_options = {
          preferences = {
            disableSuggestions = false,
          },
        },
      }

      -- ESLint LSP for better linting
      opts.servers.eslint = {
        settings = {
          workingDirectories = { mode = "auto" },
          experimental = {
            useFlatConfig = true,
          },
        },
      }

      return opts
    end,
  },

  -- Auto-commands for Bun project detection and setup
  {
    "nvim-lua/plenary.nvim",
    config = function()
      -- Create autocommands for Bun project detection
      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = { "package.json", "bun.lockb", "bunfig.toml" },
        callback = function()
          -- Set up Bun-specific settings when we detect Bun files
          vim.b.is_bun_project = true

          -- Add Bun-specific keymaps
          local opts = { buffer = true, silent = true }
          vim.keymap.set("n", "<leader>bi", ":!bun install<CR>", opts)
          vim.keymap.set("n", "<leader>br", ":!bun run ", opts)
          vim.keymap.set("n", "<leader>bt", ":!bun test<CR>", opts)
          vim.keymap.set("n", "<leader>bd", ":!bun run dev<CR>", opts)
          vim.keymap.set("n", "<leader>bb", ":!bun build<CR>", opts)
        end,
      })

      -- Auto-detect Bun projects in directories
      vim.api.nvim_create_autocmd("DirChanged", {
        callback = function()
          local cwd = vim.fn.getcwd()
          if
            vim.fn.filereadable(cwd .. "/bun.lockb") == 1
            or (
              vim.fn.filereadable(cwd .. "/package.json") == 1
              and vim.fn.system("grep -q '\"bun\"' " .. cwd .. "/package.json") == ""
            )
          then
            vim.g.is_bun_project = true
            vim.notify("Bun project detected", vim.log.levels.INFO)
          end
        end,
      })
    end,
  },

  -- Enhanced JSON support for package.json and Bun config files
  {
    "b0o/schemastore.nvim",
    ft = { "json", "jsonc" },
    config = function()
      require("lspconfig").jsonls.setup({
        settings = {
          json = {
            schemas = require("schemastore").json.schemas({
              select = {
                "package.json",
                "tsconfig.json",
                "jsconfig.json",
                ".eslintrc",
                "bun.lockb",
              },
            }),
            validate = { enable = true },
          },
        },
      })
    end,
  },
}
