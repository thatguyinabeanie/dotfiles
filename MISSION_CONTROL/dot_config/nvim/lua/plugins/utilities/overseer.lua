return {
  {
    "stevearc/overseer.nvim",
    lazy = true,
    cmd = { "OverseerRun", "OverseerToggle", "OverseerInfo", "OverseerBuild", "OverseerQuickAction", "OverseerTaskAction" },
    keys = {
      { "<leader>or", "<cmd>OverseerRun<cr>", desc = "Overseer - Run Task" },
      { "<leader>ot", "<cmd>OverseerToggle<cr>", desc = "Overseer - Toggle List" },
      { "<leader>ob", "<cmd>OverseerBuild<cr>", desc = "Overseer - Build Task" },
      { "<leader>oq", "<cmd>OverseerQuickAction<cr>", desc = "Overseer - Quick Action" },
      { "<leader>oa", "<cmd>OverseerTaskAction<cr>", desc = "Overseer - Task Action" },
      { "<leader>oi", "<cmd>OverseerInfo<cr>", desc = "Overseer - Info" },
    },
    opts = {
      strategy = {
        "toggleterm",
        -- "terminal",
        -- "jobstart",
      },
      templates = { "builtin" },
      task_list = {
        direction = "bottom",
        min_height = 25,
        max_height = 25,
        default_detail = 1,
        bindings = {
          ["?"] = "ShowHelp",
          ["g?"] = "ShowHelp",
          ["<CR>"] = "RunAction",
          ["<C-e>"] = "Edit",
          ["o"] = "Open",
          ["<C-v>"] = "OpenVsplit",
          ["<C-s>"] = "OpenSplit",
          ["<C-f>"] = "OpenFloat",
          ["<C-q>"] = "OpenQuickFix",
          ["p"] = "TogglePreview",
          ["P"] = "IncreaseDetail",
          ["<C-p>"] = "DecreaseDetail",
          ["L"] = "IncreaseAllDetail",
          ["H"] = "DecreaseAllDetail",
          ["["] = "DecreaseWidth",
          ["]"] = "IncreaseWidth",
          ["{"] = "PrevTask",
          ["}"] = "NextTask",
          ["<C-k>"] = "ScrollOutputUp",
          ["<C-j>"] = "ScrollOutputDown",
          ["q"] = "Close",
        },
      },
      form = {
        border = "rounded",
        zindex = 40,
        min_width = 80,
        max_width = 0.9,
        min_height = 10,
        max_height = 0.9,
        win_opts = {
          winblend = 0,
        },
      },
      confirm = {
        border = "rounded",
        zindex = 40,
        min_width = 20,
        max_width = 0.5,
        min_height = 6,
        max_height = 0.9,
        win_opts = {
          winblend = 0,
        },
      },
      task_launcher = {
        bindings = {
          n = {
            ["<ESC>"] = "Cancel",
            ["<CR>"] = "Submit",
            ["?"] = "ShowHelp",
          },
        },
      },
      task_editor = {
        bindings = {
          n = {
            ["<ESC>"] = "Cancel",
            ["<CR>"] = "Confirm",
            ["?"] = "ShowHelp",
          },
        },
      },
      -- Auto-detect tasks for various build systems
      auto_detect_success_color = {
        fg = "#98c379",
        bg = "#31353f",
      },
    },
    config = function(_, opts)
      local overseer = require("overseer")
      overseer.setup(opts)
      
      -- Custom task templates for JavaScript/TypeScript
      overseer.register_template({
        name = "npm install",
        builder = function()
          return {
            cmd = { "npm", "install" },
            components = { "default" },
          }
        end,
        condition = {
          filetype = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
          callback = function()
            return vim.fn.filereadable("package.json") == 1
          end,
        },
      })
      
      overseer.register_template({
        name = "npm run dev",
        builder = function()
          return {
            cmd = { "npm", "run", "dev" },
            components = { "default" },
          }
        end,
        condition = {
          filetype = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
          callback = function()
            if vim.fn.filereadable("package.json") == 0 then return false end
            local ok, content = pcall(vim.fn.readfile, "package.json")
            if ok and content then
              local json_str = table.concat(content, "\n")
              return string.find(json_str, '"dev"')
            end
            return false
          end,
        },
      })
      
      -- Bun support
      overseer.register_template({
        name = "bun install",
        builder = function()
          return {
            cmd = { "bun", "install" },
            components = { "default" },
          }
        end,
        condition = {
          filetype = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
          callback = function()
            return vim.fn.filereadable("bun.lockb") == 1
          end,
        },
      })
      
      overseer.register_template({
        name = "bun run dev",
        builder = function()
          return {
            cmd = { "bun", "run", "dev" },
            components = { "default" },
          }
        end,
        condition = {
          filetype = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
          callback = function()
            return vim.fn.filereadable("bun.lockb") == 1 and vim.fn.filereadable("package.json") == 1
          end,
        },
      })
      
      -- pnpm support
      overseer.register_template({
        name = "pnpm install",
        builder = function()
          return {
            cmd = { "pnpm", "install" },
            components = { "default" },
          }
        end,
        condition = {
          filetype = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
          callback = function()
            return vim.fn.filereadable("pnpm-lock.yaml") == 1
          end,
        },
      })
      
      -- Deno support
      overseer.register_template({
        name = "deno run",
        builder = function()
          return {
            cmd = { "deno", "run", vim.fn.expand("%") },
            components = { "default" },
          }
        end,
        condition = {
          filetype = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
          callback = function()
            return vim.fn.filereadable("deno.json") == 1 or vim.fn.filereadable("deno.jsonc") == 1
          end,
        },
      })
      
      -- Ruby on Rails tasks
      overseer.register_template({
        name = "rails server",
        builder = function()
          return {
            cmd = { "bundle", "exec", "rails", "server" },
            components = { "default" },
          }
        end,
        condition = {
          filetype = { "ruby" },
          callback = function()
            return vim.fn.filereadable("Gemfile") == 1 and vim.fn.filereadable("config/application.rb") == 1
          end,
        },
      })
      
      overseer.register_template({
        name = "rails console",
        builder = function()
          return {
            cmd = { "bundle", "exec", "rails", "console" },
            components = { "default" },
          }
        end,
        condition = {
          filetype = { "ruby" },
          callback = function()
            return vim.fn.filereadable("Gemfile") == 1 and vim.fn.filereadable("config/application.rb") == 1
          end,
        },
      })
      
      overseer.register_template({
        name = "bundle install",
        builder = function()
          return {
            cmd = { "bundle", "install" },
            components = { "default" },
          }
        end,
        condition = {
          filetype = { "ruby" },
          callback = function()
            return vim.fn.filereadable("Gemfile") == 1
          end,
        },
      })
      
      -- Python tasks
      overseer.register_template({
        name = "python run",
        builder = function()
          return {
            cmd = { "python", vim.fn.expand("%") },
            components = { "default" },
          }
        end,
        condition = {
          filetype = { "python" },
        },
      })
      
      overseer.register_template({
        name = "pip install requirements",
        builder = function()
          return {
            cmd = { "pip", "install", "-r", "requirements.txt" },
            components = { "default" },
          }
        end,
        condition = {
          filetype = { "python" },
          callback = function()
            return vim.fn.filereadable("requirements.txt") == 1
          end,
        },
      })
      
      overseer.register_template({
        name = "django runserver",
        builder = function()
          return {
            cmd = { "python", "manage.py", "runserver" },
            components = { "default" },
          }
        end,
        condition = {
          filetype = { "python" },
          callback = function()
            return vim.fn.filereadable("manage.py") == 1
          end,
        },
      })
      
      -- Integrate with DAP for debugging
      require("dap.ext.vscode").json_decode = require("overseer.json").decode
      require("overseer").patch_dap(true)
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "mfussenegger/nvim-dap", -- for debugging integration
    },
  },
}
