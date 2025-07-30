--[[
Git Blame Plugin for Neovim

USAGE:
  <leader>gb - Toggle git blame annotations (shows author, date, commit message for each line)

WHEN BLAME IS ACTIVE:
  i          - Show detailed commit info for current line
  <TAB>      - Navigate to commit (stack push)
  <BS>       - Go back in commit history (stack pop)  
  <CR>       - Show full commit details
  <ESC> / q  - Close blame view

FEATURES:
  - Shows floating blame info on hover
  - Navigate through commit history with TAB/Backspace
  - Date format: DD.MM.YYYY
  - Commit messages truncated to 30 chars
  - Opens commit details in vertical split
--]]

return {
  {
    "FabijanZulj/blame.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "BlameToggle" },
    keys = {
      { "<leader>gb", "<cmd>BlameToggle<cr>", desc = "Toggle blame" },
    },
    opts = {
      date_format = "%d.%m.%Y",
      virtual_style = "float",
      merge_consecutive = true,
      max_summary_width = 30,
      commit_detail_view = "vsplit",
      mappings = {
        commit_info = "i",
        stack_push = "<TAB>",
        stack_pop = "<BS>",
        show_commit = "<CR>",
        close = { "<esc>", "q" },
      },
    },
    config = function(_, opts)
      require("blame").setup(opts)
    end,
  },
}
