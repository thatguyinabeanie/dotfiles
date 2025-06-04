return {
  {
    "nvim-neotest/neotest",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      -- JavaScript/TypeScript adapters
      "nvim-neotest/neotest-jest",
      "marilari88/neotest-vitest",
      -- Ruby adapter
      "olimorris/neotest-rspec",
      -- Python adapter
      "nvim-neotest/neotest-python",
    },
    opts = function()
      local adapters = {}
      
      -- Helper function to check if file exists
      local function file_exists(path)
        return vim.fn.filereadable(path) == 1
      end
      
      -- Helper function to detect package manager
      local function detect_js_package_manager()
        local root = vim.fn.getcwd()
        if file_exists(root .. "/bun.lockb") then
          return "bun"
        elseif file_exists(root .. "/pnpm-lock.yaml") then
          return "pnpm"
        elseif file_exists(root .. "/yarn.lock") then
          return "yarn"
        elseif file_exists(root .. "/package-lock.json") then
          return "npm"
        elseif file_exists(root .. "/deno.json") or file_exists(root .. "/deno.jsonc") then
          return "deno"
        end
        return "npm" -- default fallback
      end
      
      -- Check for Jest project
      local function is_jest_project()
        local root = vim.fn.getcwd()
        -- Check for jest config files
        local jest_configs = {
          "jest.config.js",
          "jest.config.ts",
          "jest.config.mjs",
          "jest.config.json",
          ".jestrc",
          ".jestrc.js",
          ".jestrc.json"
        }
        
        for _, config in ipairs(jest_configs) do
          if file_exists(root .. "/" .. config) then
            return true
          end
        end
        
        -- Check package.json for jest configuration or dependency
        local package_json = root .. "/package.json"
        if file_exists(package_json) then
          local ok, content = pcall(vim.fn.readfile, package_json)
          if ok and content then
            local json_str = table.concat(content, "\n")
            if string.find(json_str, '"jest"') or string.find(json_str, '"@jest') then
              return true
            end
          end
        end
        
        return false
      end
      
      -- Check for Vitest project
      local function is_vitest_project()
        local root = vim.fn.getcwd()
        -- Check for vitest config files
        local vitest_configs = {
          "vitest.config.js",
          "vitest.config.ts",
          "vitest.config.mjs",
          "vitest.config.mts",
          "vite.config.js",
          "vite.config.ts",
          "vite.config.mjs",
          "vite.config.mts"
        }
        
        for _, config in ipairs(vitest_configs) do
          if file_exists(root .. "/" .. config) then
            return true
          end
        end
        
        -- Check package.json for vitest dependency
        local package_json = root .. "/package.json"
        if file_exists(package_json) then
          local ok, content = pcall(vim.fn.readfile, package_json)
          if ok and content then
            local json_str = table.concat(content, "\n")
            if string.find(json_str, '"vitest"') then
              return true
            end
          end
        end
        
        return false
      end
      
      -- Check for Ruby project
      local function is_ruby_project()
        local root = vim.fn.getcwd()
        return file_exists(root .. "/Gemfile") or 
               file_exists(root .. "/.rspec") or
               file_exists(root .. "/spec/spec_helper.rb")
      end
      
      -- Check for Python project
      local function is_python_project()
        local root = vim.fn.getcwd()
        return file_exists(root .. "/setup.py") or
               file_exists(root .. "/pyproject.toml") or
               file_exists(root .. "/requirements.txt") or
               file_exists(root .. "/Pipfile") or
               file_exists(root .. "/pytest.ini") or
               file_exists(root .. "/tox.ini")
      end
      
      -- JavaScript/TypeScript adapters
      local package_manager = detect_js_package_manager()
      
      if is_vitest_project() then
        adapters[#adapters + 1] = require("neotest-vitest")({
          vitestCommand = package_manager == "bun" and "bun test" or package_manager .. " test",
          filter_dir = function(name)
            return name ~= "node_modules"
          end,
        })
      elseif is_jest_project() then
        local jest_cmd = package_manager == "bun" and "bun test" or package_manager .. " test --"
        adapters[#adapters + 1] = require("neotest-jest")({
          jestCommand = jest_cmd,
          env = { CI = true },
          cwd = function()
            return vim.fn.getcwd()
          end,
        })
      end
      
      -- Ruby adapter
      if is_ruby_project() then
        adapters[#adapters + 1] = require("neotest-rspec")({
          rspec_cmd = function()
            return vim.tbl_flatten({
              "bundle",
              "exec",
              "rspec",
            })
          end,
          root_files = { "Gemfile", ".rspec", ".gitignore" },
          filter_dirs = { ".git", "node_modules" },
          transform_spec_path = function(path)
            return path
          end,
        })
      end
      
      -- Python adapter
      if is_python_project() then
        adapters[#adapters + 1] = require("neotest-python")({
          dap = { justMyCode = false },
          runner = "pytest", -- or "unittest"
          python = ".venv/bin/python", -- or dynamically with a function
          pytest_discover_instances = true,
        })
      end
      
      return {
        adapters = adapters,
        -- Global Neotest settings
        summary = {
          animated = true,
          enabled = true,
          expand_errors = true,
          follow = true,
          mappings = {
            attach = "a",
            clear_marked = "M",
            clear_target = "T",
            expand = { "<CR>", "<2-LeftMouse>" },
            expand_all = "e",
            jumpto = "i",
            mark = "m",
            next_failed = "J",
            output = "o",
            prev_failed = "K",
            run = "r",
            run_marked = "R",
            short = "O",
            stop = "u",
            target = "t",
            watch = "w",
          },
        },
        icons = {
          child_indent = "│",
          child_prefix = "├",
          collapsed = "─",
          expanded = "╮",
          failed = "✖",
          final_child_indent = " ",
          final_child_prefix = "╰",
          non_collapsible = "─",
          passed = "✔",
          running = "⟳",
          running_animated = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
          skipped = "↓",
          unknown = "?",
          watching = "👁",
        },
        floating = {
          border = "rounded",
          max_height = 0.9,
          max_width = 0.9,
          options = {},
        },
        quickfix = {
          enabled = true,
          open = false,
        },
      }
    end,
    keys = {
      -- Run tests
      { "<leader>tr", function() require("neotest").run.run() end, desc = "Run Nearest Test" },
      { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run Test File" },
      { "<leader>ta", function() require("neotest").run.run(vim.fn.getcwd()) end, desc = "Run All Tests" },
      { "<leader>tl", function() require("neotest").run.run_last() end, desc = "Run Last Test" },
      
      -- Debug tests
      { "<leader>td", function() require("neotest").run.run({strategy = "dap"}) end, desc = "Debug Nearest Test" },
      
      -- Test output
      { "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Show Test Output" },
      { "<leader>tO", function() require("neotest").output_panel.toggle() end, desc = "Toggle Output Panel" },
      
      -- Test summary
      { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Toggle Test Summary" },
      
      -- Navigation
      { "[t", function() require("neotest").jump.prev({ status = "failed" }) end, desc = "Previous Failed Test" },
      { "]t", function() require("neotest").jump.next({ status = "failed" }) end, desc = "Next Failed Test" },
      
      -- Stop tests
      { "<leader>tS", function() require("neotest").run.stop() end, desc = "Stop Tests" },
      
      -- Watch mode (for JS/TS projects)
      {
        "<leader>tw",
        function()
          local neotest = require("neotest")
          local package_manager = "npm"
          local root = vim.fn.getcwd()
          
          -- Detect package manager
          if vim.fn.filereadable(root .. "/bun.lockb") == 1 then
            package_manager = "bun"
          elseif vim.fn.filereadable(root .. "/pnpm-lock.yaml") == 1 then
            package_manager = "pnpm"
          elseif vim.fn.filereadable(root .. "/yarn.lock") == 1 then
            package_manager = "yarn"
          end
          
          -- Check for test runner
          if vim.fn.filereadable(root .. "/vitest.config.js") == 1 or 
             vim.fn.filereadable(root .. "/vitest.config.ts") == 1 or
             vim.fn.filereadable(root .. "/vite.config.js") == 1 or
             vim.fn.filereadable(root .. "/vite.config.ts") == 1 then
            neotest.run.run({ vitestCommand = package_manager .. " test -- --watch" })
          else
            neotest.run.run({ jestCommand = package_manager .. " test -- --watch" })
          end
        end,
        desc = "Run Tests in Watch Mode",
      },
    },
  },
}