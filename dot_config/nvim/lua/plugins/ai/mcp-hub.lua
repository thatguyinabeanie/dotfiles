return {
  {
    "ravitemer/mcphub.nvim",
    -- Only load mcphub outside of CI environments
    enabled = not vim.env.CI,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    build = "npm install -g mcp-hub@latest", -- Installs `mcp-hub` node binary globally
    config = function()
      -- Dynamically detect the latest installed Node.js version managed by mise
      local function get_latest_node_bin()
        local node_installs_dir = vim.env.HOME .. "/.local/share/mise/installs/node/"
        local uv = vim.loop
        local handle = uv.fs_scandir(node_installs_dir)
        if not handle then
          return nil
        end
        local versions = {}
        while true do
          local name, typ = uv.fs_scandir_next(handle)
          if not name then
            break
          end
          if typ == "directory" and name:match("^%d+%.%d+%.%d+$") then
            table.insert(versions, name)
          end
        end
        table.sort(versions, function(a, b)
          local function split(v)
            local major, minor, patch = v:match("^(%d+)%.(%d+)%.(%d+)$")
            return tonumber(major), tonumber(minor), tonumber(patch)
          end
          local a1, a2, a3 = split(a)
          local b1, b2, b3 = split(b)
          if a1 ~= b1 then
            return a1 > b1
          end
          if a2 ~= b2 then
            return a2 > b2
          end
          return a3 > b3
        end)
        if #versions == 0 then
          return nil
        end
        return node_installs_dir .. versions[1] .. "/bin"
      end

      -- Ensure mise tools are in PATH for Neovim
      local mise_node_bin = get_latest_node_bin()
      local current_path = vim.env.PATH or ""
      if mise_node_bin and not string.find(current_path, mise_node_bin, 1, true) then
        vim.env.PATH = mise_node_bin .. ":" .. current_path
      end

      require("mcphub").setup({
        --- `mcp-hub` binary related options-------------------
        config = vim.env.HOME .. "/.config/mcphub/servers.json",
        port = 37373, -- The port `mcp-hub` server listens to
        shutdown_delay = 60 * 1000, -- Delay in ms before shutting down the server when last instance closes
        use_bundled_binary = false, -- Use local `mcp-hub` binary
        mcp_request_timeout = 10000, -- Max time allowed for a MCP tool or resource to execute in ms

        ---Chat-plugin related options-----------------
        auto_approve = false, -- Auto approve mcp tool calls
        auto_toggle_mcp_servers = true, -- Let LLMs start and stop MCP servers automatically
        extensions = {
          avante = {
            make_slash_commands = true, -- make /slash commands from MCP server prompts
          },
          copilot = {
            make_slash_commands = true, -- make /slash commands from MCP server prompts
          },
          codecompanion = {
            make_slash_commands = true, -- make /slash commands from MCP server prompts
          },
        },

        --- Plugin specific options-------------------
        native_servers = {}, -- add your custom lua native servers here
        ui = {
          window = {
            width = 0.8, -- 0-1 (ratio); "50%" (percentage); 50 (raw number)
            height = 0.8, -- 0-1 (ratio); "50%" (percentage); 50 (raw number)
            align = "center", -- "center", "top-left", "top-right", "bottom-left", "bottom-right", "top", "bottom", "left", "right"
            relative = "editor",
            zindex = 50,
            border = "rounded", -- "none", "single", "double", "rounded", "solid", "shadow"
          },
          wo = { -- window-scoped options (vim.wo)
            winhl = "Normal:MCPHubNormal,FloatBorder:MCPHubBorder",
          },
        },
        log = {
          level = vim.log.levels.WARN, -- Reduced logging to minimize file I/O
          to_file = true, -- Enable file logging
          file_path = vim.env.HOME .. "/.config/mcphub/mcphub.log",
          prefix = "MCPHub",
        },
      })

      -- Universal MCP project integration
      local function setup_universal_mcp_integration()
        local augroup = vim.api.nvim_create_augroup("MCPHubUniversal", { clear = true })

        -- Auto-detect any MCP projects and notify
        vim.api.nvim_create_autocmd({ "DirChanged", "VimEnter" }, {
          group = augroup,
          callback = function()
            local cwd = vim.fn.getcwd()

            -- Check for any MCP configuration files
            local mcp_configs = {
              { file = "mcp.json", desc = "MCP configuration" },
              { file = "opencode.json", desc = "OpenCode MCP configuration" },
              { file = ".mcphub/servers.json", desc = "MCPHub configuration" },
              { file = ".vscode/mcp.json", desc = "VSCode MCP configuration" },
              { file = ".cursor/mcp.json", desc = "Cursor MCP configuration" },
              { file = "mcp-server.js", desc = "Node.js MCP server" },
              { file = "mcp-server.py", desc = "Python MCP server" },
              { file = "mcp-server.ts", desc = "TypeScript MCP server" },
            }

            local found_configs = {}
            for _, config in ipairs(mcp_configs) do
              if vim.fn.filereadable(cwd .. "/" .. config.file) == 1 then
                table.insert(found_configs, config)
              end
            end

            if #found_configs > 0 then
              local project_name = vim.fn.fnamemodify(cwd, ":t")
              vim.notify("🔌 MCP project detected: " .. project_name, vim.log.levels.INFO)

              for _, config in ipairs(found_configs) do
                vim.notify("  📄 " .. config.desc .. " found", vim.log.levels.INFO)
              end

              vim.notify("💡 Use <leader>am to configure MCP servers", vim.log.levels.INFO)
            end
          end,
          desc = "Auto-detect MCP projects",
        })
      end

      -- Setup keymaps for MCP Hub
      local function setup_keymaps()
        local function map(mode, lhs, rhs, opts)
          opts = opts or {}
          opts.silent = opts.silent ~= false
          vim.keymap.set(mode, lhs, rhs, opts)
        end

        -- MCP Hub management keymaps
        map("n", "<leader>am", "<cmd>MCPHub<cr>", { desc = "Open MCP Hub" })
        map("n", "<leader>an", function()
          -- Universal status function that works for any MCP project
          local cwd = vim.fn.getcwd()
          local project_name = vim.fn.fnamemodify(cwd, ":t")

          vim.notify("📁 Project: " .. project_name, vim.log.levels.INFO)

          -- Check for various MCP configuration files
          local mcp_files = {
            "mcp.json",
            "opencode.json",
            "mcp-server.js",
            "mcp-server.py",
            "mcp-server.ts",
            ".mcphub/servers.json",
            ".vscode/mcp.json",
            ".cursor/mcp.json",
          }

          local found_files = {}
          for _, file in ipairs(mcp_files) do
            if vim.fn.filereadable(cwd .. "/" .. file) == 1 then
              table.insert(found_files, file)
            end
          end

          if #found_files > 0 then
            vim.notify("✅ MCP configurations found:", vim.log.levels.INFO)
            for _, file in ipairs(found_files) do
              vim.notify("  📄 " .. file, vim.log.levels.INFO)
            end
          else
            vim.notify("❌ No MCP configurations found", vim.log.levels.WARN)
          end

          vim.cmd("MCPHub")
        end, { desc = "MCP Hub Status" })

        -- Quick access to MCP Hub features
        map("n", "<leader>ao", "<cmd>MCPHub<cr>", { desc = "MCP Tools & Resources" })
        map("n", "<leader>ag", function()
          vim.notify("🔄 Refreshing MCP Hub connections...", vim.log.levels.INFO)
          vim.cmd("MCPHub")
        end, { desc = "Refresh MCP Hub" })
      end

      -- Initialize integrations
      setup_universal_mcp_integration()
      setup_keymaps()

      -- Show startup message for any MCP project
      vim.defer_fn(function()
        local cwd = vim.fn.getcwd()
        local has_mcp = vim.fn.filereadable(cwd .. "/mcp.json") == 1
          or vim.fn.filereadable(cwd .. "/opencode.json") == 1
          or vim.fn.filereadable(cwd .. "/mcp-server.js") == 1
          or vim.fn.filereadable(cwd .. "/mcp-server.py") == 1
          or vim.fn.filereadable(cwd .. "/mcp-server.ts") == 1

        if has_mcp then
          local project_name = vim.fn.fnamemodify(cwd, ":t")
          vim.notify("💡 " .. project_name .. " MCP project - Use <leader>am to open MCP Hub", vim.log.levels.INFO)
        end
      end, 2000)
    end,
  },
}
