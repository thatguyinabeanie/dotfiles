-- Smart navigation that adapts to your terminal multiplexer
-- Detects TMUX or ZELLIJ environment and loads the appropriate plugin
--
-- Behavior:
--   - In tmux: Loads vim-tmux-navigator for seamless tmux+nvim navigation
--   - In Zellij: Loads zellij-nav.nvim for seamless zellij+nvim navigation
--   - In neither: No plugin loaded, Ctrl+h/j/k/l work for nvim splits only

local in_tmux = vim.env.TMUX ~= nil
local in_zellij = vim.env.ZELLIJ ~= nil

return {
  -- TMUX: vim-tmux-navigator
  {
    "christoomey/vim-tmux-navigator",
    enabled = in_tmux,
    lazy = false,
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>", desc = "Navigate left" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>", desc = "Navigate down" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>", desc = "Navigate up" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>", desc = "Navigate right" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>", desc = "Navigate previous" },
    },
  },

  -- ZELLIJ: zellij-nav.nvim
  {
    "swaits/zellij-nav.nvim",
    enabled = in_zellij,
    lazy = false,
    event = "VeryLazy",
    keys = {
      { "<c-h>", "<cmd>ZellijNavigateLeft<cr>", { silent = true, desc = "Navigate left" } },
      { "<c-j>", "<cmd>ZellijNavigateDown<cr>", { silent = true, desc = "Navigate down" } },
      { "<c-k>", "<cmd>ZellijNavigateUp<cr>", { silent = true, desc = "Navigate up" } },
      { "<c-l>", "<cmd>ZellijNavigateRight<cr>", { silent = true, desc = "Navigate right" } },
    },
    opts = {},
    config = function(_, opts)
      require("zellij-nav").setup(opts)

      -- Unlock Zellij when exiting Neovim
      vim.api.nvim_create_autocmd("VimLeave", {
        pattern = "*",
        command = "silent !zellij action switch-mode normal",
      })
    end,
  },
}
