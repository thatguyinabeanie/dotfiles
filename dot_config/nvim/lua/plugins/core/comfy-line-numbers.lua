-- Comfortable line numbers with smooth transitions and UI plugins
return {
  {
    "shortcuts/no-neck-pain.nvim",
    enabled = true,
  },
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    enabled = false,
    config = function()
      require("tiny-inline-diagnostic").setup({
        preset = "modern",
      })
      vim.diagnostic.config({ virtual_text = false })
    end,
  },
  {
    "mluders/comfy-line-numbers.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("comfy-line-numbers").setup({
        -- Use left-hand digits for easier vertical motions
        labels = require("utils.comfy-line-numbers-labels").labels,
        up_key = "k",
        down_key = "j",
        -- Hide line numbers for certain file types
        hidden_file_types = { "undotree", "NvimTree", "neo-tree", "dashboard", "snacks_dashboard", "alpha", "startify" },
        hidden_buffer_types = { "terminal", "nofile", "nowrite", "help", "quickfix" },
      })
    end,
  },
}
