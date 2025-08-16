return {
  "nat-418/boole.nvim",
  event = "VeryLazy",
  opts = {
    mappings = {
      increment = "<C-S-a>",
      decrement = "<C-S-x>",
    },
    -- User defined cycles (arrays of strings, not key-value pairs)
    additions = {
      { "true", "false" },
      { "success", "failure" },
      { "pass", "fail" },
      { "start", "stop" },
      { "open", "close" },
      { "show", "hide" },
      { "light", "dark" },
      { "min", "max" },
      { "minimum", "maximum" },
      { "horizontal", "vertical" },
      { "left", "right" },
      { "up", "down" },
      { "top", "bottom" },
      { "first", "last" },
      { "begin", "end" },
      { "public", "private" },
    },
    -- Auto-generate case variations for these additions (enable→Enable→ENABLE)
    allow_caps_additions = {
      { "active", "inactive" },
    },
  },
}
