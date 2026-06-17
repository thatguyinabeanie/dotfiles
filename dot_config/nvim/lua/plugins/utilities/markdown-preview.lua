-- markdown-preview.nvim — live browser preview of the current markdown file.
-- Opens in Chrome via a local web server; updates on save.
return {
  "iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle" },
  ft = { "markdown" },
  build = "cd app && npm install",
  init = function()
    vim.g.mkdp_browser = "chrome"
  end,
  keys = {
    { "<leader>cp", "<cmd>MarkdownPreviewToggle<cr>", ft = "markdown", desc = "Toggle Markdown Preview" },
  },
}
