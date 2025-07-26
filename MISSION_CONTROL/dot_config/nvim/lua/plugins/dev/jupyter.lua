-- Jupyter notebook workflow automations and file type configurations
vim.api.nvim_create_augroup("JupyterWorkflow", { clear = true })

-- File type detection for Jupyter notebooks
vim.filetype.add({
  extension = {
    ipynb = function()
      -- If jupytext is available, treat as markdown/python
      if vim.fn.executable("jupytext") == 1 then
        return "python"
      end
      return "json"
    end,
  },
})

-- Auto-sync jupytext files on save
vim.api.nvim_create_autocmd("BufWritePost", {
  group = "JupyterWorkflow",
  pattern = { "*.ipynb", "*.py", "*.md", "*.qmd" },
  callback = function()
    -- Only sync if jupytext is available and this is a paired file
    if vim.fn.executable("jupytext") == 1 then
      local file = vim.fn.expand("%")
      -- Check if this file has a jupytext pairing
      local has_pairing = vim.fn.system("jupytext --test " .. vim.fn.shellescape(file))
      if vim.v.shell_error == 0 then
        vim.cmd("silent !jupytext --sync " .. vim.fn.shellescape(file))
      end
    end
  end,
})

-- Auto-import Molten outputs when opening notebook files
vim.api.nvim_create_autocmd("BufReadPost", {
  group = "JupyterWorkflow",
  pattern = "*.ipynb",
  callback = function()
    vim.schedule(function()
      -- Only import if Molten is available and initialized
      if vim.fn.exists(":MoltenImportOutput") == 2 then
        local ok, molten_status = pcall(require, "molten.status")
        if ok and molten_status.initialized() ~= "" then
          vim.cmd("MoltenImportOutput")
        end
      end
    end)
  end,
})

-- Enhanced which-key groups for Jupyter operations
if pcall(require, "which-key") then
  require("which-key").add({
    { "<leader>M", group = "Molten/Jupyter" },
    { "<leader>J", group = "Jupyter Tools" },
  })
end

return {
  -- File format handling - convert between .ipynb and plain text formats
  {
    "GCBallesteros/jupytext.nvim",
    init = function()
      -- Create a fixed health check module before the plugin loads
      package.preload["jupytext.health"] = function()
        return {
          check = function()
            vim.health.start("jupytext")
            
            -- Check if jupytext executable is available
            if vim.fn.executable("jupytext") == 1 then
              vim.health.ok("jupytext executable found")
              
              -- Check jupytext version
              local version_cmd = vim.fn.system("jupytext --version 2>/dev/null")
              if vim.v.shell_error == 0 then
                vim.health.ok("jupytext version: " .. vim.trim(version_cmd))
              end
            else
              vim.health.warn("jupytext executable not found", "Install with: pip install jupytext")
            end
          end
        }
      end
    end,
    config = function()
      require('jupytext').setup({
        style = "markdown",
        output_extension = "md",
        force_ft = nil,
      })
    end,
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
      -- Output display configuration (optimized for terminal with image support)
      vim.g.molten_image_provider = "image.nvim"
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
      
      -- Image display settings (applied if image.nvim is available)
      vim.g.molten_image_location = "both" -- Show in both float and virtual text
      vim.g.molten_auto_image_popup = false -- Don't auto-popup images
    end,
    keys = {
      -- Kernel management
      { "<leader>Mi", ":MoltenInit<CR>", desc = "Initialize Molten" },
      { "<leader>Md", ":MoltenDeinit<CR>", desc = "Deinitialize Molten" },
      { "<leader>Mk", ":MoltenInfo<CR>", desc = "Molten kernel info" },
      
      -- Code execution
      { "<leader>Me", ":MoltenEvaluateOperator<CR>", desc = "Evaluate operator" },
      { "<leader>Ml", ":MoltenEvaluateLine<CR>", desc = "Evaluate line" },
      { "<leader>Mr", ":MoltenReevaluateCell<CR>", desc = "Re-evaluate cell" },
      { "<leader>Mv", ":<C-u>MoltenEvaluateVisual<CR>gv", mode = "v", desc = "Evaluate visual selection" },
      
      -- Output management
      { "<leader>Mo", ":MoltenToggleOutput<CR>", desc = "Toggle output display" },
      { "<leader>Mh", ":MoltenHideOutput<CR>", desc = "Hide output" },
      { "<leader>Ms", ":MoltenShowOutput<CR>", desc = "Show output" },
      { "<leader>Mc", ":MoltenDelete<CR>", desc = "Delete Molten cell" },
      
      -- Cell navigation
      { "<leader>Mp", ":MoltenPrev<CR>", desc = "Go to previous cell" },
      { "<leader>Mn", ":MoltenNext<CR>", desc = "Go to next cell" },
      
      -- Notebook operations
      { "<leader>MI", ":MoltenImportOutput<CR>", desc = "Import notebook outputs" },
      { "<leader>ME", ":MoltenExportOutput!<CR>", desc = "Export to .ipynb" },
      
      -- Additional Jupyter workflow keybindings
      { "<leader>Js", function()
          local file = vim.fn.expand("%")
          vim.cmd("!jupytext --sync " .. vim.fn.shellescape(file))
        end, desc = "Sync with jupytext" },
      
      { "<leader>Jp", function()
          local file = vim.fn.expand("%")
          vim.cmd("!jupytext --to py:percent " .. vim.fn.shellescape(file))
        end, desc = "Convert to Python percent format" },
      
      { "<leader>Jn", function()
          local file = vim.fn.expand("%")
          vim.cmd("!jupytext --to notebook " .. vim.fn.shellescape(file))
        end, desc = "Convert to notebook format" },
      
      { "<leader>Jm", function()
          local file = vim.fn.expand("%")
          vim.cmd("!jupytext --to markdown " .. vim.fn.shellescape(file))
        end, desc = "Convert to markdown format" },
      
      { "<leader>Ma", function()
          local venv = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX")
          if venv then
            -- Extract environment name from path
            local kernel_name = string.match(venv, "/.+/(.+)")
            if kernel_name then
              vim.cmd(("MoltenInit %s"):format(kernel_name))
            else
              vim.cmd("MoltenInit python3")
            end
          else
            vim.cmd("MoltenInit python3")
          end
        end, desc = "Auto-initialize kernel" },
      
      { "<leader>Jt", function()
          local template = [[# Physics/Data Science Notebook

## Setup
```python
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
from scipy import stats
import seaborn as sns

# Configure matplotlib for better plots
plt.style.use('default')
%matplotlib inline
```

## Data Analysis

## Visualization

## Results

## Conclusion
]]
          
          vim.api.nvim_put(vim.split(template, "\n"), "l", true, true)
        end, desc = "Insert notebook template" },
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
}