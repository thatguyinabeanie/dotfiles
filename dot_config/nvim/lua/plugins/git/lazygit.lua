-- LazyGit - A simple terminal UI for git commands
return {
  "kdheepak/lazygit.nvim",
  cmd = {
    "LazyGit",
    "LazyGitConfig",
    "LazyGitCurrentFile",
    "LazyGitFilter",
    "LazyGitFilterCurrentFile",
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  keys = {
    { "<leader>gg", "<cmd>LazyGit<cr>", desc = "Git - LazyGit" },
    { "<leader>gf", "<cmd>LazyGitCurrentFile<cr>", desc = "Git - LazyGit (Current File)" },
    { "<leader>gc", "<cmd>LazyGitConfig<cr>", desc = "Git - LazyGit Config" },
  },
  config = function()
    -- Configure lazygit to work with vim-tmux-navigator
    vim.g.lazygit_floating_window_use_plenary = 0

    -- Set up autocmd to enable tmux navigation in lazygit terminal
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "lazygit",
      callback = function()
        vim.api.nvim_buf_set_keymap(0, "t", "<C-h>", "<C-\\><C-n><C-h>", { silent = true })
        vim.api.nvim_buf_set_keymap(0, "t", "<C-j>", "<C-\\><C-n><C-j>", { silent = true })
        vim.api.nvim_buf_set_keymap(0, "t", "<C-k>", "<C-\\><C-n><C-k>", { silent = true })
        vim.api.nvim_buf_set_keymap(0, "t", "<C-l>", "<C-\\><C-n><C-l>", { silent = true })
      end,
    })
  end,
}
