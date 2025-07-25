return {
  -- File format handling - convert between .ipynb and plain text formats
  {
    "GCBallesteros/jupytext.nvim",
    config = true,
    lazy = false, -- Don't lazy load for immediate availability
  },

  -- Interactive execution with Jupyter kernels (core functionality)
  {
    "benlubas/molten-nvim",
    version = "^1.0.0", -- Use stable version
    build = ":UpdateRemotePlugins",
    init = function()
      -- Start with basic configuration - no image support initially
      vim.g.molten_image_provider = "none" -- Disable images for now
      vim.g.molten_auto_open_output = true -- Use floating windows
      vim.g.molten_virt_text_output = false -- Start with floating windows for reliability
      vim.g.molten_wrap_output = true -- Wrap long output lines
      
      -- Performance and behavior settings
      vim.g.molten_output_show_exec_time = true -- Show execution timing
      vim.g.molten_limit_output_chars = 1000000 -- Handle large datasets
      vim.g.molten_tick_rate = 500 -- Update frequency in ms
      vim.g.molten_copy_output = false -- Don't auto-copy to clipboard
      
      -- Window styling for floating windows
      vim.g.molten_output_win_max_height = 20
      vim.g.molten_output_win_border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" }
      vim.g.molten_output_crop_border = true
      vim.g.molten_enter_output_behavior = "open_then_enter"
    end,
    keys = {
      -- Kernel management
      { "<leader>mi", ":MoltenInit<CR>", desc = "Initialize Molten" },
      { "<leader>md", ":MoltenDeinit<CR>", desc = "Deinitialize Molten" },
      { "<leader>mk", ":MoltenInfo<CR>", desc = "Molten kernel info" },
      
      -- Code execution
      { "<leader>me", ":MoltenEvaluateOperator<CR>", desc = "Evaluate operator" },
      { "<leader>ml", ":MoltenEvaluateLine<CR>", desc = "Evaluate line" },
      { "<leader>mr", ":MoltenReevaluateCell<CR>", desc = "Re-evaluate cell" },
      { "<leader>mv", ":<C-u>MoltenEvaluateVisual<CR>gv", mode = "v", desc = "Evaluate visual selection" },
      
      -- Output management
      { "<leader>mo", ":MoltenToggleOutput<CR>", desc = "Toggle output display" },
      { "<leader>mh", ":MoltenHideOutput<CR>", desc = "Hide output" },
      { "<leader>ms", ":MoltenShowOutput<CR>", desc = "Show output" },
      { "<leader>mc", ":MoltenDelete<CR>", desc = "Delete Molten cell" },
      
      -- Cell navigation
      { "<leader>mp", ":MoltenPrev<CR>", desc = "Go to previous cell" },
      { "<leader>mn", ":MoltenNext<CR>", desc = "Go to next cell" },
      
      -- Notebook operations
      { "<leader>mI", ":MoltenImportOutput<CR>", desc = "Import notebook outputs" },
      { "<leader>mE", ":MoltenExportOutput!<CR>", desc = "Export to .ipynb" },
    },
  },

  -- LSP support for embedded code blocks in markdown/notebooks
  {
    "jmbuhr/otter.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      lsp = {
        hover = {
          border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" },
        },
      },
      buffers = {
        set_filetype = true,
        write_to_disk = false,
      },
      strip_wrapping_quote_characters = { "'", '"', "`" },
    },
    config = function(_, opts)
      require("otter").setup(opts)
      
      -- Auto-activate otter for markdown and quarto files
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "markdown", "quarto", "ipynb" },
        callback = function()
          require("otter").activate({ "python", "r", "julia", "bash" })
        end,
      })
    end,
  },

  -- Optional: Image support (can be enabled later when dependencies are resolved)
  {
    "3rd/image.nvim",
    enabled = false, -- Disable for now until luarocks issues are resolved
    event = "VeryLazy",
    dependencies = {
      {
        "vhyrro/luarocks.nvim",
        priority = 1001,
        opts = {
          rocks = { "magick" },
        },
      },
    },
    opts = {
      backend = "kitty",
      processor = "magick_rock",
      max_width_window_percentage = 50,
      max_height_window_percentage = 50,
      window_overlap_clear_enabled = true,
      tmux_show_only_in_active_window = true,
    },
  },
}