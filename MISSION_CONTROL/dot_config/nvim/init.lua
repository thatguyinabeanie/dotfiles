-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Start MCP server socket for external tool integration
vim.fn.serverstart('/tmp/nvim')
