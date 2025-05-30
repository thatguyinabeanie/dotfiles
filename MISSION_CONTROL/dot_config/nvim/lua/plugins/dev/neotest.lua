return {
  {
    "nvim-neotest/neotest",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-jest",
      "marilari88/neotest-vitest"
    },
    opts = function()
      local adapters = {}
      
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
          if vim.fn.filereadable(root .. "/" .. config) == 1 then
            return true
          end
        end
        
        -- Check package.json for jest configuration or dependency
        local package_json = root .. "/package.json"
        if vim.fn.filereadable(package_json) == 1 then
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
          if vim.fn.filereadable(root .. "/" .. config) == 1 then
            return true
          end
        end
        
        -- Check package.json for vitest dependency
        local package_json = root .. "/package.json"
        if vim.fn.filereadable(package_json) == 1 then
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
      
      -- Add adapters based on project type
      if is_vitest_project() then
        adapters[#adapters + 1] = require("neotest-vitest")({
          filter_dir = function(name, rel_path, root)
            return name ~= "node_modules"
          end,
        })
      elseif is_jest_project() then
        adapters[#adapters + 1] = require("neotest-jest")({
          jestCommand = "npm test --",
          jestConfigFile = "jest.config.js",
          env = { CI = true },
          cwd = function(path)
            return vim.fn.getcwd()
          end,
        })
      end
      
      return { adapters = adapters }
    end,
    keys = {
      {
        "<leader>twr",
        function()
          require("neotest").run.run({ vitestCommand = "vitest --watch" })
        end,
        desc = "Run Watch",
      },
      {
        "<leader>twf",
        function()
          require("neotest").run.run({ vim.fn.expand("%"), vitestCommand = "vitest --watch" })
        end,
        desc = "Run Watch File",
      },
    },
  },
}