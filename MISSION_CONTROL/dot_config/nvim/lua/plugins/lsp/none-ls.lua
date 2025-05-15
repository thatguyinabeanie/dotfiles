if true then return {} end;

return {
  {
    "nvimtools/none-ls.nvim",
    event = "VeryLazy",
    dependencies = { "davidmh/cspell.nvim" },
    opts = function(_, opts)
      local cspell = require("cspell")
      local none_ls = require("none-ls")
      local has_cspell_config = vim.fn.glob(".cspell.json") ~= ""
        or vim.fn.glob("cspell.json") ~= ""
        or vim.fn.glob(".cspell.config.json") ~= ""
        or vim.fn.glob("cspell.config.js") ~= ""
        or vim.fn.glob("cspell.config.json") ~= ""
        or vim.fn.glob("package.json") ~= "" and string.find(table.concat(vim.fn.readfile("package.json"), "\n"), '"cspell"') ~= nil

      opts.sources = opts.sources or {}

      -- Add markdownlint-cli2
      table.insert(opts.sources, none_ls.builtins.diagnostics.markdownlint)

      if has_cspell_config then
        table.insert(
          opts.sources,
          cspell.diagnostics.with({
            diagnostics_postprocess = function(diagnostic)
              diagnostic.severity = vim.diagnostic.severity.HINT
            end,
          })
        )
        table.insert(opts.sources, cspell.code_actions)
      end
    end,
  },
}
