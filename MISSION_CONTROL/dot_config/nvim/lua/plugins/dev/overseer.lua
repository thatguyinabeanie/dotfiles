return {
  {
    "stevearc/overseer.nvim",
    lazy = true,
    cmd = { "OverseerRun", "OverseerToggle", "OverseerInfo", "OverseerBuild", "OverseerQuickAction" },
    keys = {
      { "<leader>or", "<cmd>OverseerRun<cr>", desc = "Overseer - Run" },
      { "<leader>ot", "<cmd>OverseerToggle<cr>", desc = "Overseer - Toggle" },
    },
  },
}
