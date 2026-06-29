-- Override render-markdown.nvim to disable code block backgrounds
-- This allows the terminal/Neovim transparent background to show through
return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      code = {
        -- Disable background for all languages to allow transparency
        disable_background = true,
        -- Border style for code blocks. The default 'hide' conceals the closing
        -- code-fence LINE (via conceal_lines), which also hides snacks.image's mermaid
        -- diagram — it's anchored to that line as virtual lines, so it only appeared at
        -- the cursor (where render-markdown's anti-conceal revealed the line).
        -- 'thin' overlays a border instead of concealing the line, so mermaid blocks
        -- render with styling AND the diagram stays visible. Applies to all code blocks.
        border = "thin",
      },
    },
  },
}
