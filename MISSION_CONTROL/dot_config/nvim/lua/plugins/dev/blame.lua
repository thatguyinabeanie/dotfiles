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
