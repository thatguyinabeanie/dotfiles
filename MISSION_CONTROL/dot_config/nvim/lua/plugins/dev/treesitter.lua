return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        -- Web technologies
        "css",
        "vue",
        "html",
        "javascript",
        "typescript",
        "tsx",
        "scss",
        "svelte",
        
        -- Documentation
        "markdown",
        "markdown_inline",
        
        -- Other languages already working
        "latex",
        "norg",
        "typst",
      },
    },
  },
}