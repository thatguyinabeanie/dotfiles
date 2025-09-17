return {
  "NickvanDyke/opencode.nvim",
  dependencies = {
    -- Required for better prompt input and embedded terminal
    { "folke/snacks.nvim", opts = { input = { enabled = true } } },
  },
  event = "VeryLazy",
  config = function()
    -- Ensure autoread is enabled for auto-reload functionality
    vim.opt.autoread = true

    -- Configuration options
    vim.g.opencode_opts = {
      -- Basic configuration - see lua/opencode/config.lua for all options
      auto_reload = true, -- Auto-reload buffers edited by opencode
      auto_scroll = true, -- Auto-scroll to follow opencode output
      terminal = {
        enabled = true, -- Use embedded terminal
        position = "bottom", -- Terminal position: "bottom", "right", "left", "top"
        size = 0.3, -- Terminal size as fraction of editor
      },
      contexts = {
        -- Add custom context placeholders if needed
        -- ["@mycontext"] = function() return "my custom context" end
      },
      prompts = {
        -- Add custom prompts to the prompt library
        -- ["custom"] = "Explain this code in detail: @selection"
      },
    }

    -- Set up keymaps
    local function map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { desc = desc, silent = true })
    end

    -- Core functionality
    map("n", "<leader>oc", function()
      require("opencode").toggle()
    end, "Toggle opencode")

    map("n", "<leader>oA", function()
      require("opencode").ask()
    end, "Ask opencode")

    map("n", "<leader>oa", function()
      require("opencode").ask("@cursor: ")
    end, "Ask opencode about this")

    map("v", "<leader>oa", function()
      require("opencode").ask("@selection: ")
    end, "Ask opencode about selection")

    -- Session management
    map("n", "<leader>on", function()
      require("opencode").command("session_new")
    end, "New opencode session")

    map("n", "<leader>or", function()
      require("opencode").command("session_reset")
    end, "Reset opencode session")

    -- Response handling
    map("n", "<leader>oy", function()
      require("opencode").command("messages_copy")
    end, "Copy last opencode response")

    -- Navigation in messages
    map("n", "<S-C-u>", function()
      require("opencode").command("messages_half_page_up")
    end, "Messages half page up")

    map("n", "<S-C-d>", function()
      require("opencode").command("messages_half_page_down")
    end, "Messages half page down")

    -- Prompt selection
    map({ "n", "v" }, "<leader>os", function()
      require("opencode").select()
    end, "Select opencode prompt")

    -- Common AI coding tasks
    map("n", "<leader>oe", function()
      require("opencode").prompt("Explain @cursor and its context in detail")
    end, "Explain this code")

    map("v", "<leader>or", function()
      require("opencode").prompt("Review this code for potential improvements: @selection")
    end, "Review selected code")

    map("n", "<leader>of", function()
      require("opencode").prompt("Fix any issues in @buffer")
    end, "Fix issues in buffer")

    map("v", "<leader>od", function()
      require("opencode").prompt("Add comprehensive documentation for: @selection")
    end, "Document selected code")

    map("n", "<leader>oT", function()
      require("opencode").prompt("Generate unit tests for @cursor")
    end, "Generate tests for this")

    -- Buffer and diagnostic context
    map("n", "<leader>oD", function()
      require("opencode").ask("@diagnostics: Help me fix these diagnostic issues")
    end, "Fix diagnostics")

    map("n", "<leader>og", function()
      require("opencode").ask("@diff: Review these changes")
    end, "Review git diff")

    -- Set up autocmds for opencode events
    vim.api.nvim_create_autocmd("User", {
      pattern = "OpencodeEvent",
      callback = function(args)
        local event = args.data
        
        -- Handle different event types
        if event.type == "session.idle" then
          -- Opencode finished responding
          vim.notify("OpenCode response complete", vim.log.levels.INFO)
        elseif event.type == "session.thinking" then
          -- Opencode is processing
          vim.notify("OpenCode is thinking...", vim.log.levels.INFO)
        elseif event.type == "error" then
          -- Handle errors
          vim.notify("OpenCode error: " .. (event.message or "Unknown error"), vim.log.levels.ERROR)
        end
      end,
    })

    -- Auto-reload configuration when opencode config changes
    vim.api.nvim_create_autocmd("BufWritePost", {
      pattern = "*/opencode/*.lua",
      callback = function()
        -- Reload opencode configuration
        package.loaded["opencode"] = nil
        require("opencode")
        vim.notify("OpenCode configuration reloaded", vim.log.levels.INFO)
      end,
    })
  end,
}