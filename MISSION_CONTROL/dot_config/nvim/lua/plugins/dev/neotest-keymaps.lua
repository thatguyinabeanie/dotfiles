return {
  {
    "nvim-neotest/neotest",
    keys = {
      {
        "<leader>twr",
        function()
          require("neotest").run.run({ vitestCommand = "vitest --watch" })
        end,
        desc = "Run Watch",
      },
      {
        "<leader>twf",
        function()
          require("neotest").run.run({ vim.fn.expand("%"), vitestCommand = "vitest --watch" })
        end,
        desc = "Run Watch File",
      },
    },
  },
}