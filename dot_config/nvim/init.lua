-- Make snacks.image's terminal detection deterministic when running through tmux.
-- snacks normally probes the terminal to confirm ghostty's Kitty graphics support; this
-- override forces it on, avoiding any detection timing/race. TERM_PROGRAM is masked by tmux,
-- so GHOSTTY_RESOURCES_DIR (which survives tmux) is the reliable ghostty indicator.
if vim.env.GHOSTTY_RESOURCES_DIR then
  vim.env.SNACKS_GHOSTTY = "1"
end

-- Bootstrap lazy.nvim plugin manager
require("config.lazy")

-- Defer MCP server socket creation to improve startup time
vim.schedule(function()
  -- Start MCP server socket for external tool integration
  local socket_path = vim.fn.tempname()
  vim.fn.serverstart(socket_path)
  vim.env.NVIM_LISTEN_ADDRESS = socket_path
end)
