return {
  {
    "mbbill/undotree",
    event = "VeryLazy",
    config = function()
      -- Set up persistent undo directory
      local undodir = vim.fn.expand("~/.undotree")
      vim.opt.undodir = undodir
      vim.opt.undofile = true

      vim.keymap.set("n", "<leader>uu", vim.cmd.UndotreeToggle, { desc = "Toggle Undotree" })
    end,
  },
}
