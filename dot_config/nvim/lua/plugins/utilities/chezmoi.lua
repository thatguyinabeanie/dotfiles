-- Enhanced Chezmoi configuration - extends LazyVim's chezmoi extra
-- Adds compound filetype detection for better syntax highlighting and LSP support

return {
  {
    "folke/snacks.nvim",
    keys = {
      {
        "<leader>fc",
        function()
          require("utils.chezmoi").find_files()
        end,
        desc = "Find Config File (Chezmoi)",
      },
      {
        "<leader>fC",
        function()
          require("utils.chezmoi").open_config_toml()
        end,
        desc = "Open chezmoi.toml",
      },
    },
  },
}
