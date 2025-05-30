-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Start MCP server socket for external tool integration
local socket_path = vim.loop.os_tmpdir() .. '/nvim-' .. vim.fn.getpid()
-- Remove existing socket if it exists
if vim.loop.fs_stat(socket_path) then
    os.remove(socket_path)
end
vim.fn.serverstart(socket_path)
