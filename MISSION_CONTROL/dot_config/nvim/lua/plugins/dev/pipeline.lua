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
      -- Initialize empty pipelines table to prevent nil errors
      pipelines = {},
    },
    config = function(_, opts)
      -- Wrap setup in pcall to prevent errors during initialization
      local ok, pipeline = pcall(require, "pipeline")
      if ok and pipeline and pipeline.setup then
        -- Ensure pipeline has necessary data structures before setup
        if not pipeline._pipelines then
          pipeline._pipelines = {}
        end
        
        -- Create a safe wrapper for vim.tbl_map to handle nil values
        local original_tbl_map = vim.tbl_map
        local safe_tbl_map = function(func, t)
          if t == nil then
            return {}
          end
          return original_tbl_map(func, t)
        end
        
        -- Temporarily replace vim.tbl_map during setup
        vim.tbl_map = safe_tbl_map
        
        local setup_ok = pcall(pipeline.setup, opts)
        
        -- Restore original vim.tbl_map after setup
        vim.schedule(function()
          vim.tbl_map = original_tbl_map
        end)
        
        if not setup_ok then
          -- If setup fails, ensure minimal structure exists
          pipeline._pipelines = pipeline._pipelines or {}
        end
      end
    end,
  },
}
