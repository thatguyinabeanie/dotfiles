if true then return {} end

return {
  {
    "zbirenbaum/copilot.lua",
    opts = {
      copilot_node_command = vim.env.HOME .. "/.local/share/mise/installs/node/22/bin/node",
    },
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      "ravitemer/mcphub.nvim", -- Ensure mcphub loads first for MCP integration
    },
    opts = {
      model = "claude-sonnet-4.5",
    },
    keys = {
      { "<leader>ap", "<cmd>CopilotChatOpen<cr>", desc = "Copilot Chat Open" },
      { "<leader>aq", "<cmd>CopilotChatClose<cr>", desc = "Copilot Chat Close" },
      { "<leader>az", "<cmd>CopilotChatToggle<cr>", desc = "Copilot Chat Toggle" },
      { "<leader>ax", "<cmd>CopilotChatReset<cr>", desc = "Copilot Chat Reset" },
    },
  },
}
