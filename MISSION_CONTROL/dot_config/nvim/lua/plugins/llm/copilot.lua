return {
  {
    "zbirenbaum/copilot.lua",
    lazy = true,
    event = "InsertEnter",
    cmd = "Copilot",
    keys = {
      { "<leader>pE", "<cmd>Copilot enable<cr>", desc = "Copilot - Enable" },
      { "<leader>pD", "<cmd>Copilot disable<cr>", desc = "Copilot - Disable" },
    },
    opts = {
      copilot_node_command = os.getenv("HOME") .. "/.local/share/mise/installs/node/22/bin/node",
    },
  },
}
