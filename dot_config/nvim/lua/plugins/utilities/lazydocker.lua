-- LazyDocker - A simple terminal UI for both Docker and Docker Compose
return {
  "crnvl96/lazydocker.nvim",
  keys = {
    { "<leader>l", "", desc = "+LazyDocker" },
    {
      "<leader>ld",
      "<cmd>lua require('lazydocker').toggle({ engine = 'docker' })<cr>",
      mode = { "n", "t" },
      desc = "LazyDocker (Docker)",
    },
    {
      "<leader>lp",
      "<cmd>lua require('lazydocker').toggle({ engine = 'podman' })<cr>",
      mode = { "n", "t" },
      desc = "LazyDocker (Podman)",
    },
  },

  opts = {
    window = {
      settings = {
        width = 0.618, -- Golden ratio percentage of screen width
        height = 0.618, -- Golden ratio percentage of screen height
        border = "rounded",
        relative = "editor",
      },
    },
  },

  config = function(_, opts)
    require("lazydocker").setup(opts)
  end,
}
