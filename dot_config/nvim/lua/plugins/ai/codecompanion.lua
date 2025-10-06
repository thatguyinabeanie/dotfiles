-- https://codecompanion.olimorris.dev/
-- CodeCompanion keymaps:
-- <leader>ac - open chat, <leader>as - actions menu, <leader>at - toggle chat
if true then return {} end

return {
  {
    "olimorris/codecompanion.nvim",
    enabled = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "zbirenbaum/copilot.lua",
      "saghen/blink.cmp",
      "ravitemer/mcphub.nvim", -- Ensure mcphub loads first for MCP integration
    },
    lazy = true,
    cmd = { "CodeCompanion", "CodeCompanionActions", "CodeCompanionChat" },
    opts = {
      strategies = {
        chat = {
          adapter = {
            name = "copilot",
            model = "claude-sonnet-4.5",
          },
        },
        inline = {
          adapter = {
            name = "copilot",
            model = "claude-sonnet-4.5",
          },
        },
        agent = {
          adapter = {
            name = "copilot",
            model = "claude-sonnet-4.5",
          },
        },
      },
      -- Enable MCP integration via mcphub extension
      extensions = {
        -- mcphub = {
        --   callback = "mcphub.extensions.codecompanion",
        --   opts = {
        --     -- MCP Tools
        --     make_tools = true, -- Make individual tools (@server__tool) and server groups (@server)
        --     show_server_tools_in_chat = true, -- Show individual tools in chat completion
        --     add_mcp_prefix_to_tool_names = false, -- Don't add mcp__ prefix
        --     show_result_in_chat = true, -- Show tool results directly in chat buffer
        --     -- MCP Resources
        --     make_vars = true, -- Convert MCP resources to #variables for prompts
        --     -- MCP Prompts
        --     make_slash_commands = true, -- Add MCP prompts as /slash commands
        --   },
        -- },
      },
      -- Enable logging for debugging
      opts = {
        log_level = "INFO",
      },
      -- Display configuration
      display = {
        chat = {
          window = {
            layout = "vertical", -- vertical split instead of float
            width = 0.4,
            height = 0.8,
          },
        },
        diff = {
          provider = "mini_diff",
        },
      },
      -- Prompt library configuration
      prompt_library = {
        ["Custom Workflow"] = {
          strategy = "chat",
          description = "Create a custom workflow",
          opts = {
            short_name = "workflow",
            auto_submit = false,
          },
          prompts = {
            {
              role = "user",
              content = "Please help me create a workflow for: ",
              opts = {
                contains_code = false,
              },
            },
          },
        },
      },
    },
    keys = {
      { "<leader>ac", "<cmd>CodeCompanionChat<cr>", desc = "Code Companion Open Chat" },
      { "<leader>as", "<cmd>CodeCompanionActions<cr>", desc = "Code Companion Actions" },
      { "<leader>at", "<cmd>CodeCompanionChat Toggle<cr>", desc = "Code Companion Toggle Chat" },
      -- Visual mode mappings
      { "<leader>ac", "<cmd>CodeCompanionChat<cr>", mode = "v", desc = "Code Companion Open Chat" },
      { "<leader>as", "<cmd>CodeCompanionActions<cr>", mode = "v", desc = "Code Companion Actions" },
    },
  },
}
