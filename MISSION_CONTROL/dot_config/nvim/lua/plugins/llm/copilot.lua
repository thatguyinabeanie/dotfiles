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
      copilot_node_command = vim.env.HOME .. "/.local/share/mise/installs/node/22/bin/node",
      suggestion = { enabled = false }, -- Disable to use blink-cmp-copilot
      panel = { enabled = false },       -- Disable to use blink-cmp-copilot
    },
  },
}
