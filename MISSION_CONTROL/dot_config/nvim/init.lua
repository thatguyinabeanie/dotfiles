-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Start MCP server socket for external tool integration
local socket_path = os.tmpname()  -- Generate a unique temporary file name
vim.fn.serverstart(socket_path)   -- Start the server with the generated path
