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
      suggestion = { enabled = true }, -- Disable to use blink-cmp-copilot
      panel = { enabled = true },       -- Disable to use blink-cmp-copilot
    },
    config = function(_, opts)
      require("copilot").setup(opts)
      -- Ensure LSP client starts even with disabled suggestions/panel
      vim.defer_fn(function()
        require("copilot.client").buf_attach()
      end, 1000)
    end,
  },
}
