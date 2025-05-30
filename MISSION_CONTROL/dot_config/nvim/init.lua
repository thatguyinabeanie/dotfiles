-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Start MCP server socket for external tool integration
local socket_path = '/tmp/nvim-' .. vim.fn.getpid()
-- Remove existing socket if it exists
os.remove(socket_path)
vim.fn.serverstart(socket_path)
