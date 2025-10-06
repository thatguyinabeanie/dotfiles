return {
  {
    "ravitemer/mcphub.nvim",
    enabled = true,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("mcphub").setup({
        -- node_path = vim.fn.expand("~/.local/share/mise/installs/node/22/bin/node"),
        extensions = {
          avante = {
            make_slash_commands = true,
          },
          codecompanion = {
            make_slash_commands = true,
          },
          copilot = {
            make_slash_commands = true,
          },
          sidekick = {
            make_slash_commands = true,
          },
        },
      })

      vim.keymap.set("n", "<leader>am", "<cmd>MCPHub<cr>", { desc = "MCP Hub" })
    end,
  },
}
