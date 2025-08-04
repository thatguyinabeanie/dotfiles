if true then return {} end

return {
  {
    "mfussenegger/nvim-dap",
    lazy = true,
    dependencies = {
      -- UI for DAP
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-telescope/telescope-dap.nvim",

      -- Language specific adapters
      "mxsdev/nvim-dap-vscode-js", -- JavaScript/TypeScript
      "suketa/nvim-dap-ruby", -- Ruby
      "mfussenegger/nvim-dap-python", -- Python

      -- Mason integration for automatic debugger installation
      "jay-babu/mason-nvim-dap.nvim",
    },
    keys = {
      -- Debugging controls
      {
        "<F5>",
        function()
          require("dap").continue()
        end,
        desc = "Debug: Start/Continue",
      },
      {
        "<F10>",
        function()
          require("dap").step_over()
        end,
        desc = "Debug: Step Over",
      },
      {
        "<F11>",
        function()
          require("dap").step_into()
        end,
        desc = "Debug: Step Into",
      },
      {
        "<F12>",
        function()
          require("dap").step_out()
        end,
        desc = "Debug: Step Out",
      },
      {
        "<leader>db",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "Debug: Toggle Breakpoint",
      },
      {
        "<leader>dB",
        function()
          require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end,
        desc = "Debug: Set Conditional Breakpoint",
      },
      {
        "<leader>dr",
        function()
          require("dap").repl.open()
        end,
        desc = "Debug: Open REPL",
      },
      {
        "<leader>dl",
        function()
          require("dap").run_last()
        end,
        desc = "Debug: Run Last",
      },
      {
        "<leader>dt",
        function()
          require("dap").terminate()
        end,
        desc = "Debug: Terminate",
      },

      -- DAP UI
      {
        "<leader>du",
        function()
          require("dapui").toggle()
        end,
        desc = "Debug: Toggle UI",
      },
      {
        "<leader>de",
        function()
          require("dapui").eval()
        end,
        desc = "Debug: Eval",
        mode = { "n", "v" },
      },
      {
        "<leader>dE",
        function()
          require("dapui").eval(vim.fn.input("Expression: "))
        end,
        desc = "Debug: Eval Expression",
      },

      -- Telescope integration
      {
        "<leader>ds",
        function()
          require("telescope").extensions.dap.configurations()
        end,
        desc = "Debug: Select Configuration",
      },
      {
        "<leader>dlb",
        function()
          require("telescope").extensions.dap.list_breakpoints()
        end,
        desc = "Debug: List Breakpoints",
      },
      {
        "<leader>dv",
        function()
          require("telescope").extensions.dap.variables()
        end,
        desc = "Debug: Variables",
      },
      {
        "<leader>df",
        function()
          require("telescope").extensions.dap.frames()
        end,
        desc = "Debug: Frames",
      },
    },
    config = function()
      -- Defer the configuration to avoid startup issues
      vim.schedule(function()
        local dap = require("dap")
        local dapui = require("dapui")

        -- DAP UI setup
        dapui.setup({
          icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
          mappings = {
            expand = { "<CR>", "<2-LeftMouse>" },
            open = "o",
            remove = "d",
            edit = "e",
            repl = "r",
            toggle = "t",
          },
          layouts = {
            {
              elements = {
                { id = "scopes", size = 0.25 },
                { id = "breakpoints", size = 0.25 },
                { id = "stacks", size = 0.25 },
                { id = "watches", size = 0.25 },
              },
              size = 40,
              position = "right",
            },
            {
              elements = {
                { id = "repl", size = 0.5 },
                { id = "console", size = 0.5 },
              },
              size = 0.25,
              position = "bottom",
            },
          },
        })

        -- Virtual text for debugging
        require("nvim-dap-virtual-text").setup({
          enabled = true,
          enabled_commands = true,
          highlight_changed_variables = true,
          highlight_new_as_changed = false,
          show_stop_reason = true,
          commented = false,
          only_first_definition = true,
          all_references = false,
          filter_references_pattern = "<module",
          virt_text_pos = "eol",
          all_frames = false,
          virt_lines = false,
          virt_text_win_col = nil,
        })

        -- Automatically open/close DAP UI
        dap.listeners.after.event_initialized["dapui_config"] = function()
          vim.schedule(function()
            dapui.open()
          end)
        end
        dap.listeners.before.event_terminated["dapui_config"] = function()
          vim.schedule(function()
            dapui.close()
          end)
        end
        dap.listeners.before.event_exited["dapui_config"] = function()
          vim.schedule(function()
            dapui.close()
          end)
        end

        -- JavaScript/TypeScript debugging
        require("dap-vscode-js").setup({
          node_path = "node",
          debugger_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter",
          debugger_cmd = { "js-debug-adapter" },
          adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
        })

        -- JavaScript/TypeScript configurations
        local js_based_languages = { "typescript", "javascript", "typescriptreact", "javascriptreact" }

        for _, language in ipairs(js_based_languages) do
          dap.configurations[language] = {
            -- Node.js
            {
              type = "pwa-node",
              request = "launch",
              name = "Launch file",
              program = "${file}",
              cwd = "${workspaceFolder}",
            },
            {
              type = "pwa-node",
              request = "attach",
              name = "Attach",
              processId = require("dap.utils").pick_process,
              cwd = "${workspaceFolder}",
            },
            -- Jest
            {
              type = "pwa-node",
              request = "launch",
              name = "Debug Jest Tests",
              -- trace = true, -- include debugger info
              runtimeExecutable = "node",
              runtimeArgs = {
                "./node_modules/.bin/jest",
                "--runInBand",
              },
              rootPath = "${workspaceFolder}",
              cwd = "${workspaceFolder}",
              console = "integratedTerminal",
              internalConsoleOptions = "neverOpen",
            },
            -- Vitest
            {
              type = "pwa-node",
              request = "launch",
              name = "Debug Vitest Tests",
              cwd = vim.fn.getcwd(),
              program = "${workspaceFolder}/node_modules/vitest/vitest.mjs",
              args = { "run", "${file}" },
              autoAttachChildProcesses = true,
              smartStep = true,
              console = "integratedTerminal",
              skipFiles = { "<node_internals>/**", "node_modules/**" },
            },
            -- Chrome/Edge debugging for web apps
            {
              type = "pwa-chrome",
              request = "launch",
              name = "Launch Chrome",
              url = "http://localhost:3000",
              webRoot = "${workspaceFolder}",
            },
          }
        end

        -- Ruby debugging
        require("dap-ruby").setup()

        -- Python debugging
        local dap_python = require("dap-python")

        -- Function to get the Python path from active virtual environment
        local function get_python_path()
          -- First check for Mason-installed debugpy
          local mason_debugpy = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
          if vim.fn.executable(mason_debugpy) == 1 then
            return mason_debugpy
          end

          -- Check if a virtual environment is activated
          local venv = vim.env.VIRTUAL_ENV
          if venv then
            local venv_python = venv .. "/bin/python"
            if vim.fn.executable(venv_python) == 1 then
              return venv_python
            end
          end

          -- Check conda environment
          local conda_prefix = vim.env.CONDA_PREFIX
          if conda_prefix then
            local conda_python = conda_prefix .. "/bin/python"
            if vim.fn.executable(conda_python) == 1 then
              return conda_python
            end
          end

          -- Check for uv virtual environment
          local uv_venv = vim.fn.getcwd() .. "/.venv/bin/python"
          if vim.fn.executable(uv_venv) == 1 then
            -- Check if this is a uv-managed venv by looking for .venv/uv-managed marker
            local uv_marker = vim.fn.getcwd() .. "/.venv/pyvenv.cfg"
            if vim.fn.filereadable(uv_marker) == 1 then
              return uv_venv
            end
          end

          -- Try to find python executable in common locations
          local possible_paths = {
            vim.fn.getcwd() .. "/.venv/bin/python",
            vim.fn.expand("~/.pyenv/shims/python"),
            "/usr/bin/python3",
            "python3",
            "python",
          }

          for _, path in ipairs(possible_paths) do
            if vim.fn.executable(path) == 1 then
              return path
            end
          end

          -- Final fallback: use system Python from PATH
          local system_python = vim.fn.exepath("python3") or vim.fn.exepath("python")
          if system_python and system_python ~= "" then
            return system_python
          end

          return nil
        end

        local python_path = get_python_path()
        if python_path then
          dap_python.setup(python_path)

          -- Additional Python configurations
          table.insert(dap.configurations.python, {
            type = "python",
            request = "launch",
            name = "Django",
            program = vim.fn.getcwd() .. "/manage.py",
            args = { "runserver", "--noreload" },
            django = true,
            console = "integratedTerminal",
          })

          table.insert(dap.configurations.python, {
            type = "python",
            request = "launch",
            name = "FastAPI",
            module = "uvicorn",
            args = { "main:app", "--reload" },
            console = "integratedTerminal",
          })
        end

        -- Signs
        vim.fn.sign_define("DapBreakpoint", { text = "🔴", texthl = "DapBreakpoint", linehl = "", numhl = "" })
        vim.fn.sign_define(
          "DapBreakpointCondition",
          { text = "🟡", texthl = "DapBreakpoint", linehl = "", numhl = "" }
        )
        vim.fn.sign_define("DapBreakpointRejected", { text = "⭕", texthl = "DapBreakpoint", linehl = "", numhl = "" })
        vim.fn.sign_define("DapLogPoint", { text = "📝", texthl = "DapLogPoint", linehl = "", numhl = "" })
        vim.fn.sign_define(
          "DapStopped",
          { text = "➡️", texthl = "DapStopped", linehl = "DapStopped", numhl = "DapStopped" }
        )

        -- Load telescope extension
        require("telescope").load_extension("dap")
      end) -- End of vim.schedule
    end,
  },
  {
    -- Automatic debugger installation
    "jay-babu/mason-nvim-dap.nvim",
    lazy = true,
    dependencies = {
      "mason-org/mason.nvim",
      "mfussenegger/nvim-dap",
    },
    opts = {
      ensure_installed = {
        "js-debug-adapter", -- JavaScript/TypeScript
        "debugpy", -- Python
      },
      automatic_installation = true,
      handlers = {},
    },
  },
}
