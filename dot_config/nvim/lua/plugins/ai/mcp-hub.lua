return {
  {
    "ravitemer/mcphub.nvim",
    enabled = not vim.env.CI,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    build = "npm install -g mcp-hub@latest",
    config = function()
      require("mcphub").setup({
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
        },
      })

      vim.keymap.set("n", "<leader>am", "<cmd>MCPHub<cr>", { desc = "MCP Hub" })
    end,
  },
}
