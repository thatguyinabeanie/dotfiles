return {
  {
    "augmentcode/augment.vim",
    lazy = false,
    config = function()
      vim.api.nvim_set_keymap(
        "n",
        "<leader>az",
        ":AugmentCode<CR>",
        { desc = "Augment Code", noremap = true, silent = true }
      )
      vim.api.nvim_set_keymap(
        "n",
        "<leader>ax",
        ":AugmentExplain<CR>",
        { desc = "Explain Code", noremap = true, silent = true }
      )
      vim.api.nvim_set_keymap(
        "n",
        "<leader>af",
        ":AugmentRefactor<CR>",
        { desc = "Refactor Code", noremap = true, silent = true }
      )
    end,
  },
}
