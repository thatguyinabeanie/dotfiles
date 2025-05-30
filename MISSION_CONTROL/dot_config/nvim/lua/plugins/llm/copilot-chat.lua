-- CopilotChat.nvim for better Copilot integration with MCP support
return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    dependencies = {
      "zbirenbaum/copilot.lua", -- or github/copilot.vim
      "nvim-lua/plenary.nvim", -- for curl, log wrapper
    },
    build = "make tiktoken", -- Only on MacOS or Linux
    opts = {
      model = "claude-3.7-sonnet", -- GPT-4 model to use, can be 'gpt-3.5-turbo' or 'gpt-4'
      temperature = 0.1,
      auto_follow_cursor = true, -- Auto-follow cursor in chat
      auto_insert_mode = true, -- Automatically enter insert mode when opening window
      clear_chat_on_new_prompt = false, -- Clears chat on every new prompt
      context = 'buffers', -- Default context to use, 'buffers', 'buffer' or 'manual'
      highlight_headers = true, -- Highlight headers in chat
      separator = '─', -- Separator between different contexts
      window = {
        layout = 'float', -- 'vertical', 'horizontal', 'float', 'replace'
        width = 0.8, -- fractional width of parent
        height = 0.8, -- fractional height of parent
        border = 'rounded', -- 'single', 'double', 'rounded', 'solid', 'shadow'
      },
      mappings = {
        complete = {
          detail = 'Use @<Tab> or /<Tab> for options.',
          insert = '<Tab>',
        },
        close = {
          normal = 'q',
          insert = '<C-c>'
        },
        reset = {
          normal = '<leader>cr',
          insert = '<C-r>'
        },
        submit_prompt = {
          normal = '<CR>',
          insert = '<C-s>'
        },
        accept_diff = {
          normal = '<C-y>',
          insert = '<C-y>'
        },
        yank_diff = {
          normal = 'gy',
          register = '"',
        },
        show_diff = {
          normal = 'gd'
        },
        show_info = {
          normal = 'gi'
        },
        show_context = {
          normal = 'gc'
        },
      },
    },
    keys = {
      -- Main chat commands
      { "<leader>ap", ":CopilotChat ", desc = "CopilotChat - Prompt" },
      { "<leader>ah", "<cmd>CopilotChatToggle<cr>", desc = "CopilotChat - Toggle Chat" },
      { "<leader>ad", "<cmd>CopilotChatDebugInfo<cr>", desc = "CopilotChat - Debug Info" },
      
      -- Specific copilot features with <leader>p prefix
      { "<leader>pc", "<cmd>CopilotChatToggle<cr>", desc = "Copilot - Toggle Chat" },
      { "<leader>ps", "<cmd>CopilotChatStop<cr>", desc = "Copilot - Stop" },
      { "<leader>pr", "<cmd>CopilotChatReset<cr>", desc = "Copilot - Reset" },
      
      -- Code actions
      { "<leader>pe", "<cmd>CopilotChatExplain<cr>", mode = { "n", "v" }, desc = "Copilot - Explain" },
      { "<leader>pv", "<cmd>CopilotChatReview<cr>", mode = { "n", "v" }, desc = "Copilot - Review" },
      { "<leader>pf", "<cmd>CopilotChatFix<cr>", mode = { "n", "v" }, desc = "Copilot - Fix" },
      { "<leader>po", "<cmd>CopilotChatOptimize<cr>", mode = { "n", "v" }, desc = "Copilot - Optimize" },
      { "<leader>pd", "<cmd>CopilotChatDocs<cr>", mode = { "n", "v" }, desc = "Copilot - Docs" },
      { "<leader>pt", "<cmd>CopilotChatTests<cr>", mode = { "n", "v" }, desc = "Copilot - Tests" },
      
      -- Visual mode prompt
      { "<leader>pp", ":CopilotChatVisual ", mode = "x", desc = "Copilot - Visual Prompt" },
      
      -- Quick chat
      {
        "<leader>pq",
        function()
          local input = vim.fn.input("Quick Chat: ")
          if input ~= "" then
            require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
          end
        end,
        desc = "Copilot - Quick chat"
      },
      
      -- Help and prompt actions
      {
        "<leader>ph",
        function()
          require("CopilotChat.actions").pick(require("CopilotChat.actions").help_actions())
        end,
        desc = "Copilot - Help actions",
      },
      {
        "<leader>pa",
        function()
          require("CopilotChat.actions").pick(require("CopilotChat.actions").prompt_actions())
        end,
        desc = "Copilot - Prompt actions",
      },
    },
    config = function(_, opts)
      local chat = require("CopilotChat")
      local select = require("CopilotChat.select")
      
      -- Setup CopilotChat
      chat.setup(opts)
      
      -- Auto-complete support
      vim.api.nvim_create_user_command("CopilotChatVisual", function(args)
        chat.ask(args.args, { selection = select.visual })
      end, { nargs = "*", range = true })
      
      -- Inline chat
      vim.api.nvim_create_user_command("CopilotChatInline", function(args)
        chat.ask(args.args, {
          selection = select.visual,
          window = {
            layout = "float",
            relative = "cursor",
            width = 1,
            height = 0.4,
            row = 1,
          },
        })
      end, { nargs = "*", range = true })
      
      -- Quick chat with buffer context
      vim.api.nvim_create_user_command("CopilotChatBuffer", function(args)
        chat.ask(args.args, { selection = select.buffer })
      end, { nargs = "*" })
    end,
  },
}
