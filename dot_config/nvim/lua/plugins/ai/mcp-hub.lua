if true then return {} end

return {
  {
    "ravitemer/mcphub.nvim",
    -- enabled = not vim.env.CI,
    enabled = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    build = "~/.local/share/mise/installs/node/22/bin/npm install -g mcp-hub@latest",
    config = function()
      require("mcphub").setup({
        node_path = vim.fn.expand("~/.local/share/mise/installs/node/22.18.0/bin/node"),
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
