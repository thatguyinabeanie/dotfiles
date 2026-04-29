return {
  -- blink.cmp v2 requires blink.lib as a separate dependency
  { "saghen/blink.lib", lazy = true },
  {
    "saghen/blink.cmp",
    dependencies = { "saghen/blink.lib" },
  },
}
