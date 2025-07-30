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
        -- Lazy load dashboard when needed
        preset = {
          keys = {
            {
              icon = " ",
              key = "f",
              desc = "Find File",
              action = function()
                Snacks.picker.files()
              end,
            },
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            {
              icon = " ",
              key = "r",
              desc = "Recent Files",
              action = function()
                Snacks.picker.recent()
              end,
            },
            {
              icon = " ",
              key = "g",
              desc = "Find Text",
              action = function()
                Snacks.picker.grep()
              end,
            },
            {
              icon = " ",
              key = "c",
              desc = "Config",
              action = function()
                Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
              end,
            },
            {
              icon = " ",
              key = "s",
              desc = "Restore Session",
              action = function()
                require("persistence").load()
              end,
            },
            { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
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
        char = "│", -- Main indent character (same as indent-blankline default)
        blank = "│", -- Character for blank lines
        only_scope = false, -- Show all indent guides, not just scope
        only_current = false, -- Show indent guides for all levels
        hl = "IblIndent", -- Highlight group for indent guides (compatible with indent-blankline)
        animate = {
          enabled = true,
          style = "out", -- Animation style for indent changes
          easing = "linear",
          duration = {
            step = 20,
            total = 300,
          },
        },
        scope = { enabled = true },
        chunk = {
          enabled = true,
        },
        filter = function(buf)
          if not buf or buf == 0 or not vim.api.nvim_buf_is_valid(buf) then
            return false
          end
          local bt = vim.bo[buf].buftype
          local ft = vim.bo[buf].filetype
          -- Filter out special buffer types and filetypes
          if bt ~= "" then
            return false
          end
          if
            ft == "help"
            or ft == "alpha"
            or ft == "dashboard"
            or ft == "neo-tree"
            or ft == "Trouble"
            or ft == "lazy"
          then
            return false
          end
          return vim.g.snacks_indent ~= false and vim.b[buf].snacks_indent ~= false
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
    -- Override LazyVim's default keymaps to use cwd instead of root
    keys = {
      {
        "<leader>ff",
        function()
          Snacks.picker.files({ cwd = vim.fn.getcwd() })
        end,
        desc = "Find Files (cwd)",
      },
      {
        "<leader><space>",
        function()
          Snacks.picker.files({ cwd = vim.fn.getcwd() })
        end,
        desc = "Find Files (cwd)",
      },
      {
        "<leader>fF",
        function()
          Snacks.picker.files({ cwd = LazyVim.root() })
        end,
        desc = "Find Files (root)",
      },
      -- Git browse keybindings (lazy loaded)
      {
        "<leader>gB",
        function()
          Snacks.gitbrowse()
        end,
        desc = "Git Browse",
      },
      -- LazyGit integration
      {
        "<leader>gg",
        function()
          Snacks.lazygit()
        end,
        desc = "LazyGit",
      },
      -- Terminal
      {
        "<c-/>",
        function()
          Snacks.terminal()
        end,
        desc = "Terminal",
      },
      -- Zen mode
      {
        "<leader>z",
        function()
          Snacks.zen()
        end,
        desc = "Zen Mode",
      },
      {
        "<leader>Z",
        function()
          Snacks.zen.zoom()
        end,
        desc = "Zen Zoom",
      },
      -- Scratch buffers
      {
        "<leader>.",
        function()
          Snacks.scratch()
        end,
        desc = "Scratch Buffer",
      },
      {
        "<leader>S",
        function()
          Snacks.scratch.select()
        end,
        desc = "Select Scratch Buffer",
      },
      -- Dim toggle
      {
        "<leader>ud",
        function()
          Snacks.dim.toggle()
        end,
        desc = "Toggle Dim",
      },
      -- File rename
      {
        "<leader>cR",
        function()
          Snacks.rename.rename_file()
        end,
        desc = "Rename File",
      },
    },
  },
  {
    "folke/trouble.nvim",
    opts = { use_diagnostic_signs = true },
  },
}
