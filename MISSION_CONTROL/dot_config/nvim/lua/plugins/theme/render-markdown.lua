-- Fix for transparent markdown code blocks
-- This overrides render-markdown.nvim's solid backgrounds
return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      file_types = { "markdown", "Avante" },
      -- Disable latex support to avoid latex2text warning
      latex = { enabled = false },
      -- Override code block styling to use transparent backgrounds
      code = {
        enabled = true,
        sign = false,
        style = "normal", -- Use 'normal' to show language header without full line backgrounds
        position = "left",
        width = "block",
        min_width = 0,
        border = "thin",
        above = "",
        below = "",
        language_name = true, -- Ensure language name is shown
        disable_background = { "diff" }, -- Disable backgrounds for diff blocks too
      },
    },
    ft = { "markdown", "Avante" },
    config = function(_, opts)
      require("render-markdown").setup(opts)

      -- Override any remaining highlight groups that might have backgrounds
      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = function()
          -- Make sure language labels are visible but transparent
          vim.api.nvim_set_hl(0, "RenderMarkdownCodeInline", { bg = "NONE" })
          vim.api.nvim_set_hl(0, "RenderMarkdownCode", { bg = "NONE" })
          vim.api.nvim_set_hl(0, "RenderMarkdownCodeLanguage", { bg = "NONE", fg = "#89b4fa" }) -- Catppuccin blue for visibility
          vim.api.nvim_set_hl(0, "RenderMarkdownCodeBlock", { bg = "NONE" })
          -- These handle the full-line backgrounds
          vim.api.nvim_set_hl(0, "RenderMarkdownCodeHead", { bg = "NONE" })
          vim.api.nvim_set_hl(0, "RenderMarkdownCodeTail", { bg = "NONE" })
          vim.api.nvim_set_hl(0, "RenderMarkdownCodeInfo", { bg = "NONE", fg = "#89b4fa" })
        end,
      })

      -- Apply immediately
      vim.api.nvim_set_hl(0, "RenderMarkdownCodeInline", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "RenderMarkdownCode", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "RenderMarkdownCodeLanguage", { bg = "NONE", fg = "#89b4fa" })
      vim.api.nvim_set_hl(0, "RenderMarkdownCodeBlock", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "RenderMarkdownCodeHead", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "RenderMarkdownCodeTail", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "RenderMarkdownCodeInfo", { bg = "NONE", fg = "#89b4fa" })
    end,
  },
}
