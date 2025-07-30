return {
  {
    "zbirenbaum/copilot.lua",
    opts = {
      copilot_node_command = vim.env.HOME .. "/.local/share/mise/installs/node/22/bin/node",
    },
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    opts = {
      model = "claude-sonnet-4", -- Claude Sonnet 4 via Copilot
    },
  },
}
