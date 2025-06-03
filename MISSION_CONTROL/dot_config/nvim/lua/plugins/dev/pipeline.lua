return {
  {
    "topaxi/pipeline.nvim",
    lazy = true,
    keys = {
      { "<leader>ci", "<cmd>Pipeline<cr>", desc = "Open pipeline.nvim" },
    },
    cmd = "Pipeline",
    -- optional, you can also install and use `yq` instead.
    build = "make",
    opts = {
      -- Disable automatic updates to prevent startup errors
      update_interval = 0,
    },
    config = function(_, opts)
      -- Wrap setup in pcall to prevent errors during initialization
      local ok, pipeline = pcall(require, "pipeline")
      if ok and pipeline.setup then
        pcall(pipeline.setup, opts)
      end
    end,
  },
}
