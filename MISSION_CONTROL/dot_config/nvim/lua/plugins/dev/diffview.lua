return {
  {
    "sindrets/diffview.nvim",
    enabled = true,
    lazy = true,
    cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Git - Diffview Open" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "Git - File History" },
    },
  },
}
