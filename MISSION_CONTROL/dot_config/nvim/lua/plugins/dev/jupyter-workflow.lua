-- Jupyter notebook workflow automations and file type configurations

-- Auto-commands for Jupyter workflows
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
    { "<leader>m", group = "Molten/Jupyter" },
    { "<leader>j", group = "Jupyter Tools" },
  })
end

-- Additional keybindings for Jupyter workflows
vim.keymap.set("n", "<leader>js", function()
  local file = vim.fn.expand("%")
  vim.cmd("!jupytext --sync " .. vim.fn.shellescape(file))
end, { desc = "Sync with jupytext" })

vim.keymap.set("n", "<leader>jp", function()
  local file = vim.fn.expand("%")
  vim.cmd("!jupytext --to py:percent " .. vim.fn.shellescape(file))
end, { desc = "Convert to Python percent format" })

vim.keymap.set("n", "<leader>jn", function()
  local file = vim.fn.expand("%")
  vim.cmd("!jupytext --to notebook " .. vim.fn.shellescape(file))
end, { desc = "Convert to notebook format" })

vim.keymap.set("n", "<leader>jm", function()
  local file = vim.fn.expand("%")
  vim.cmd("!jupytext --to markdown " .. vim.fn.shellescape(file))
end, { desc = "Convert to markdown format" })

-- Auto-detect and initialize appropriate kernel based on environment
vim.keymap.set("n", "<leader>ma", function()
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
end, { desc = "Auto-initialize kernel" })

-- Quick physics/data science notebook template
vim.keymap.set("n", "<leader>jt", function()
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
end, { desc = "Insert notebook template" })

return {}