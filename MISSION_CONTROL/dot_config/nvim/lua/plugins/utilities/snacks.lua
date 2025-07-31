return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    config = function(_, opts)
      require("snacks").setup(opts)
      -- Ensure UI overrides are properly set
      if opts.input and opts.input.enabled then
        require("snacks.input").enable()
      end
    end,
    opts = {
      bigfile = { enabled = true },
      dashboard = {
        enabled = true,
        width = 60,
        height = 20,
        sections = {
          {
            section = "header",
          },
          {
            section = "keys",
            gap = 1,
            padding = 1,
          },
          {
            section = "startup",
            gap = 1,
            padding = 1,
          },
        },
        preset = {
          keys = {
            -- File Operations
            {
              icon = "󰈞 ",
              key = "<space>",
              desc = "Find File",
              action = function()
                Snacks.picker.files()
              end,
            },
            {
              icon = "󰄉 ",
              key = "r",
              desc = "Recent Files",
              action = function()
                Snacks.picker.recent()
              end,
            },
            {
              icon = "󰝒 ",
              key = "n",
              desc = "New File",
              action = ":ene | startinsert",
            },
            -- Search Operations
            {
              icon = "󰊄 ",
              key = "/",
              desc = "Find Text",
              action = function()
                Snacks.picker.grep()
              end,
            },
            -- Project Management  
            {
              icon = "󰉋 ",
              key = "p",
              desc = "Projects",
              action = function()
                Snacks.picker.projects()
              end,
            },
            -- Configuration
            {
              icon = "󰒓 ",
              key = "c",
              desc = "Config",
              action = function()
                Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
              end,
            },
            {
              icon = "󰒲 ",
              key = "l",
              desc = "Lazy",
              action = ":Lazy",
            },
            -- Git Operations
            {
              icon = "󰊢 ",
              key = "G",
              desc = "Git Status",
              action = function()
                Snacks.lazygit()
              end,
            },
            -- Terminal & Exit
            {
              icon = "󰆍 ",
              key = "t",
              desc = "Terminal",
              action = function()
                Snacks.terminal()
              end,
            },
            {
              icon = "󰅚 ",
              key = "q",
              desc = "Quit",
              action = ":qa",
            },
          },
        },
      },
      dim = { enabled = true }, -- Focus mode by dimming inactive code
      gitbrowse = {
        enabled = true,
        -- Only load when actually browsing
      },
      image = { enabled = true }, -- Enable image support
      indent = {
        enabled = true,
        only_scope = true, -- Only show chunks, not regular indent guides
        scope = { enabled = false }, -- Disable scope to avoid conflict
        chunk = {
          enabled = true,
          char = {
            corner_top = "╭",
            corner_bottom = "╰",
            horizontal = "─",
            vertical = "│",
            arrow = ">",
          },
          hl = {
            "ChunkLevel1",
            "ChunkLevel2",
            "ChunkLevel3",
            "ChunkLevel4",
            "ChunkLevel5",
          },
        },
        filter = function(buf)
          return vim.g.snacks_indent ~= false and vim.b[buf].snacks_indent ~= false and vim.bo[buf].buftype == ""
        end,
      },
      input = { enabled = true },
      lazygit = { enabled = true }, -- LazyGit integration
      notifier = { enabled = true },
      picker = {
        enabled = true,
        ui_select = true, -- Enable vim.ui.select override
        exclude = { -- add folder names here to exclude
          ".git",
          "node_modules",
        },
        layout = {
          preset = "default", -- Force default layout (horizontal with floating preview)
          cycle = true,
        },
        sources = {
          explorer = {
            auto_close = false,
            hidden = true,
            ignored = true,
            follow = true,
          },
        },
      },
      quickfile = { enabled = true },
      rename = { enabled = true }, -- LSP file renaming with plugin integration
      scope = { enabled = true },
      scratch = { enabled = true }, -- Persistent scratch buffers
      scroll = { enabled = true }, -- Enable scroll animations
      statuscolumn = { enabled = true },
      terminal = { enabled = true }, -- Floating/split terminals
      words = { enabled = true }, -- Keep for word highlighting under cursor
      zen = { enabled = true }, -- Distraction-free coding mode
    },
  },
}
