return {
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
