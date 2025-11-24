-- Lua development tools and configuration

-- Node.js ecosystem development tools
-- Covers JavaScript, TypeScript, React, Vue, Tailwind, ESLint, and related tooling
-- Fallback configuration when template is not generated
local config = {
  filetypes = {
    web_frameworks = {},
  },
}

-- Try to load the template-generated config, fallback to defaults if not available
local ok, template_config = pcall(require, "utils.language-config")
if ok then
  config = template_config
end

return {
  -- LazyDev for Neovim Lua development
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

  -- Lua LSP server
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        lua_ls = {
          root_dir = function(fname)
            -- Ensure fname is valid
            if not fname or type(fname) ~= "string" or fname == "" then
              return nil
            end

            -- Skip LSP for chezmoi template files
            if string.find(fname, ".chezmoitemplates", 1, true) then
              return nil
            end

            local util = require("lspconfig.util")
            -- Ensure we return a valid path or nil
            local result = util.find_git_ancestor(fname)
            return result and type(result) == "string" and result or nil
          end,
        },
      },
    },
  },

  -- Ruby LSP server
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ruby_lsp = {},
      },
    },
  },

  -- TypeScript/JavaScript LSP servers
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Disable Angular language server (not needed for React/TypeScript projects)
        angularls = { enabled = false },

        -- TypeScript server
        tsserver = { enabled = true },
        vtsls = { enabled = true },

        -- ESLint with smart project detection
        eslint = {
          autostart = true,
          settings = {
            workingDirectories = { mode = "auto" },
            experimental = {
              useFlatConfig = true,
            },
          },
          root_dir = function(fname)
            -- Ensure fname is valid
            if not fname or type(fname) ~= "string" or fname == "" then
              return nil
            end

            local util = require("lspconfig.util")

            -- Check for ESLint config files first
            local config_patterns = {
              ".eslintrc",
              ".eslintrc.js",
              ".eslintrc.json",
              ".eslintrc.yaml",
              ".eslintrc.yml",
              "eslint.config.js",
              "eslint.config.mjs",
              "eslint.config.cjs",
            }

            local config_root = util.root_pattern(table.unpack(config_patterns))(fname)
            if config_root and type(config_root) == "string" then
              return config_root
            end

            -- Check package.json for ESLint dependency
            local package_root = util.root_pattern("package.json")(fname)
            if package_root and type(package_root) == "string" then
              local package_json = package_root .. "/package.json"
              local success, content = pcall(vim.fn.readfile, package_json)
              if success and content and #content > 0 then
                local package_str = table.concat(content, "\n")
                local ok_decode, package_data = pcall(vim.fn.json_decode, package_str)
                if ok_decode and package_data and type(package_data) == "table" then
                  local deps = package_data.dependencies or {}
                  local dev_deps = package_data.devDependencies or {}

                  if deps.eslint or dev_deps.eslint then
                    return package_root
                  end
                end
              end
            end

            return nil
          end,
          on_attach = function(client, bufnr)
            local root_dir = client.config.root_dir
            if not root_dir then
              client.stop()
              return
            end

            -- Check if ESLint is executable
            local eslint_cmd = "eslint"
            local local_eslint = root_dir .. "/node_modules/.bin/eslint"

            if vim.fn.executable(local_eslint) == 1 then
              eslint_cmd = local_eslint
            elseif vim.fn.executable("eslint") == 0 then
              vim.notify("ESLint not found. Install with: npm install eslint --save-dev", vim.log.levels.INFO)
              client.stop()
              return
            end

            -- Verify ESLint can run without errors (async)
            vim.system(
              { eslint_cmd, "--print-config", vim.api.nvim_buf_get_name(bufnr) },
              { text = true },
              function(result)
                if result.code ~= 0 then
                  vim.schedule(function()
                    vim.notify("ESLint configuration error. Check your ESLint config.", vim.log.levels.WARN)
                    client.stop()
                  end)
                end
              end
            )
          end,
        },
      },
    },
  },

  -- Tailwind CSS development tools
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

  -- Markdown LSP server
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        marksman = {
          root_dir = function(fname)
            -- Ensure fname is valid
            if not fname or type(fname) ~= "string" or fname == "" then
              return nil
            end

            local util = require("lspconfig.util")

            -- Priority 1: Look for .marksman.toml (project-specific config)
            local marksman_root = util.root_pattern(".marksman.toml")(fname)
            if marksman_root and type(marksman_root) == "string" then
              return marksman_root
            end

            -- Priority 2: Find git repository root
            local git_root = util.find_git_ancestor(fname)
            if git_root and type(git_root) == "string" then
              return git_root
            end

            -- Priority 3: Fallback to file's directory (single-file mode)
            return vim.fn.fnamemodify(fname, ":h")
          end,
        },
      },
    },
  },
}
