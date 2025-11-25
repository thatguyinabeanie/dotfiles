-- LazyDocker - A simple terminal UI for both Docker and Docker Compose
return {
  "crnvl96/lazydocker.nvim",
  keys = {
    { "<leader>l", "", desc = "+Lazy Tools" },
    {
      "<leader>ld",
      "<cmd>lua require('lazydocker').toggle({ engine = 'docker' })<cr>",
      mode = { "n", "t" },
      desc = "LazyDocker (Docker)",
    },
  },

  opts = {
    window = {
      settings = {
        width = 0.95, -- 95% of screen width for larger view
        height = 0.95, -- 95% of screen height for larger view
        border = "rounded",
        relative = "editor",
      },
    },
    -- Pass through navigation keys to vim-tmux-navigator
    on_open = function(term)
      vim.api.nvim_buf_set_keymap(term.buf, "t", "<C-h>", "<C-\\><C-n><C-h>", { silent = true })
      vim.api.nvim_buf_set_keymap(term.buf, "t", "<C-j>", "<C-\\><C-n><C-j>", { silent = true })
      vim.api.nvim_buf_set_keymap(term.buf, "t", "<C-k>", "<C-\\><C-n><C-k>", { silent = true })
      vim.api.nvim_buf_set_keymap(term.buf, "t", "<C-l>", "<C-\\><C-n><C-l>", { silent = true })
    end,
  },

  config = function(_, opts)
    require("lazydocker").setup(opts)
  end,
}
