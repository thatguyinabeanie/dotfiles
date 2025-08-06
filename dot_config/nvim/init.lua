-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Load custom filetypes early to ensure they override plugin defaults
require("config.filetypes")

-- Defer MCP server socket creation to improve startup time
vim.schedule(function()
  -- Start MCP server socket for external tool integration
  local socket_path = vim.fn.tempname()
  vim.fn.serverstart(socket_path)
  vim.env.NVIM_LISTEN_ADDRESS = socket_path
end)
