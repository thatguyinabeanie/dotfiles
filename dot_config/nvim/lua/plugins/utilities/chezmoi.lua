-- Enhanced Chezmoi configuration - extends LazyVim's chezmoi extra
-- Adds compound filetype detection for better syntax highlighting and LSP support

return {
  {
    -- highlighting for chezmoi files template files
    "alker0/chezmoi.vim",
    lazy = false, -- Override LazyVim default
  },
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
