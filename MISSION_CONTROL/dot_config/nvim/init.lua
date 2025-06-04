-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Start server socket for external tool integration
-- Using defer to avoid blocking startup
vim.defer_fn(function()
  local socket_path = vim.fn.tempname()
  vim.fn.serverstart(socket_path)
  vim.env.NVIM_LISTEN_ADDRESS = socket_path
end, 100)
