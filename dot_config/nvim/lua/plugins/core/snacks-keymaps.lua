return {
  "folke/snacks.nvim",
  keys = {
    -- Override default config finder to use Chezmoi directory
    {
      "<leader>fC",
      function()
        local chezmoi_path = vim.fn.expand("~/.local/share/chezmoi/dot_config")
        Snacks.picker.files({ cwd = chezmoi_path })
      end,
      desc = "Find Config File (Chezmoi)",
    },
  },
}
