return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false, -- Never set this value to "*"! Never!
    opts = {
      -- Using Copilot as the main provider
      provider = "copilot",
      providers = {
        copilot = {
          model = "claude-sonnet-4", -- Claude Sonnet 4 via Copilot
          timeout = 30000,
          extra_request_body = {
            temperature = 0,
            max_tokens = 8192, -- Default for copilot is 20480
          },
        },
        -- Keep OpenAI as a fallback option
      },
      -- MCP Integration - system prompt includes active MCP servers
      system_prompt = function()
        local hub_ok, mcphub = pcall(require, "mcphub")
        if hub_ok then
          local hub = mcphub.get_hub_instance()
          return hub and hub:get_active_servers_prompt() or ""
        end
        return ""
      end,
      -- MCP Tools - adds use_mcp_tool and access_mcp_resource
      custom_tools = function()
        local tools_ok, avante_ext = pcall(require, "mcphub.extensions.avante")
        if tools_ok then
          return {
            avante_ext.mcp_tool(),
          }
        end
        return {}
      end,
      -- Disable Avante's built-in tools to avoid conflicts with MCP Neovim server
      disabled_tools = {
        "list_files", -- Use MCP neovim server instead
        "search_files",
        "read_file",
        "create_file",
        "rename_file",
        "delete_file",
        "create_dir",
        "rename_dir",
        "delete_dir",
        "bash", -- Use MCP neovim server for terminal
      },
      -- Avante keymaps:
      -- <leader>aa - ask (chat with AI about selection/buffer)
      -- <leader>ae - edit (AI edit suggestions)
      -- <leader>ar - refresh (refresh AI suggestions)
      -- <C-l> - accept suggestion, <C-]>/<C-[> - next/prev, <C-c> - dismiss
      mappings = {
        ask = "<leader>aa", -- ask
        edit = "<leader>ae", -- edit
        refresh = "<leader>ar", -- refresh
        suggestion = {
          accept = "<C-l>",
          next = "<C-]>",
          prev = "<C-[>",
          dismiss = "<C-c>",
        },
      },
      -- Enable dual_boost for better performance with Claude
      dual_boost = {
        enabled = true,
        first_provider = "copilot",
        second_provider = "copilot",
        timeout = 60000,
      },
      -- Auto-suggestions settings
      auto_suggestions = true,
      hints = { enabled = true },
      -- UI improvements
      windows = {
        sidebar = {
          width = 50,
          border = "rounded",
        },
        input = {
          prefix = "> ",
          height = 8,
        },
        edit = {
          border = "rounded",
          start_insert = true,
        },
      },
    },
    config = function(_, opts)
      require("avante").setup(opts)

      -- Custom highlight groups for better contrast
      vim.api.nvim_set_hl(0, "AvanteTitle", { fg = "#ffffff", bg = "#1e1e1e", bold = true })
      vim.api.nvim_set_hl(0, "AvanteReversedTitle", { fg = "#1e1e1e", bg = "#ffffff", bold = true })
      vim.api.nvim_set_hl(0, "AvanteSubtitle", { fg = "#a0a0a0", bg = "#1e1e1e" })
      vim.api.nvim_set_hl(0, "AvanteReversedSubtitle", { fg = "#606060", bg = "#ffffff" })
      vim.api.nvim_set_hl(0, "AvanteThirdTitle", { fg = "#ffffff", bg = "#333333" })
      vim.api.nvim_set_hl(0, "AvanteReversedThirdTitle", { fg = "#333333", bg = "#ffffff" })

      -- Confirmation dialog styling
      vim.api.nvim_set_hl(0, "AvanteConflictCurrent", { bg = "#2d4f3e", fg = "#ffffff" })
      vim.api.nvim_set_hl(0, "AvanteConflictIncoming", { bg = "#3e2d4f", fg = "#ffffff" })
      vim.api.nvim_set_hl(0, "AvanteConflictAncestor", { bg = "#4f3e2d", fg = "#ffffff" })

      -- Popup/modal styling for better contrast
      vim.api.nvim_set_hl(0, "AvantePopupHint", { fg = "#ffffff", bg = "#333333", bold = true })
      vim.api.nvim_set_hl(0, "AvanteInlineHint", { fg = "#a0a0a0", bg = "NONE", italic = true })
    end,
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "echasnovski/mini.pick", -- for file_selector provider mini.pick
      "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
      "saghen/blink.cmp", -- autocompletion for avante commands and mentions
      "ibhagwan/fzf-lua", -- for file_selector provider fzf
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      "zbirenbaum/copilot.lua", -- for providers='copilot'
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
    },
  },
}
