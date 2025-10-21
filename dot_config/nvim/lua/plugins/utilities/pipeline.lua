if true then
  return {}
end
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

        -- Ensure workflows are initialized to prevent nil errors
        if not pipeline._workflows then
          pipeline._workflows = {}
        end

        -- Monkey-patch the get_workflows function to handle nil values safely
        local original_get_workflows = pipeline.get_workflows
        if original_get_workflows then
          pipeline.get_workflows = function(...)
            local workflows = original_get_workflows(...)
            return workflows or {}
          end
        end

        local setup_ok = pcall(pipeline.setup, opts)

        if not setup_ok then
          -- If setup fails, ensure minimal structure exists
          pipeline._pipelines = pipeline._pipelines or {}
          pipeline._workflows = pipeline._workflows or {}
        end
      end
    end,
  },
}
