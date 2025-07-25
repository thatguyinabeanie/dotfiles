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
    dependencies = { 
      {
        "3rd/image.nvim",
        optional = false, -- Make image.nvim required now that we fixed tmux
      }
    },
    build = ":UpdateRemotePlugins",
    init = function()
      -- Check if image.nvim is available
      local has_image = pcall(require, "image")
      
      -- Output display configuration (optimized for terminal with image support)
      vim.g.molten_image_provider = has_image and "image.nvim" or "none"
      vim.g.molten_auto_open_output = false -- Use virtual text for cleaner interface
      vim.g.molten_virt_text_output = true -- Show output as virtual text
      vim.g.molten_virt_text_max_lines = 12 -- Show more lines for detailed output
      vim.g.molten_wrap_output = true -- Wrap long output lines
      vim.g.molten_virt_lines_off_by_1 = true -- Better spacing in markdown files
      
      -- Performance and behavior settings
      vim.g.molten_output_show_exec_time = true -- Show execution timing
      vim.g.molten_limit_output_chars = 1000000 -- Handle large datasets
      vim.g.molten_tick_rate = 500 -- Update frequency in ms
      vim.g.molten_copy_output = false -- Don't auto-copy to clipboard
      
      -- Window styling (when floating windows are used)
      vim.g.molten_output_win_max_height = 20
      vim.g.molten_output_win_border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" }
      vim.g.molten_output_crop_border = true
      vim.g.molten_enter_output_behavior = "open_then_enter"
      
      -- Image display settings (now that tmux passthrough is enabled)
      if has_image then
        vim.g.molten_image_location = "both" -- Show in both float and virtual text
        vim.g.molten_auto_image_popup = false -- Don't auto-popup images
      end
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

  -- Image rendering support for plots and visualizations
  {
    "3rd/image.nvim",
    event = "VeryLazy",
    dependencies = {
      {
        "vhyrro/luarocks.nvim",
        priority = 1001, -- this plugin needs to run before anything else
        opts = {
          rocks = { "magick" },
        },
      },
    },
    opts = {
      backend = "kitty", -- Works with both Kitty and Ghostty
      processor = "magick_rock", -- Use magick rock processor
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          filetypes = { "markdown", "vimwiki" },
        },
        neorg = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          filetypes = { "norg" },
        },
        html = {
          enabled = false,
        },
        css = {
          enabled = false,
        },
      },
      max_width = nil,
      max_height = nil,
      max_width_window_percentage = 50,
      max_height_window_percentage = 50,
      window_overlap_clear_enabled = true, -- Clear images when they overlap windows
      window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
      editor_only_render_when_focused = false,
      tmux_show_only_in_active_window = true, -- Important for tmux users
    },
  },
}