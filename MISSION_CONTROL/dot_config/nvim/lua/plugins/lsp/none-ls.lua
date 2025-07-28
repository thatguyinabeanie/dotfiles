return {
  "nvimtools/none-ls.nvim",
  opts = function(_, opts)
    local null_ls = require("null-ls")
    
    -- Override markdownlint to disable MD013 (line length) by default
    -- while still allowing project-specific configurations to take precedence
    opts.sources = opts.sources or {}
    
    -- Remove any existing markdownlint diagnostic source
    opts.sources = vim.tbl_filter(function(source)
      return source ~= null_ls.builtins.diagnostics.markdownlint
    end, opts.sources)
    
    -- Add customized markdownlint with MD013 disabled by default
    table.insert(opts.sources, null_ls.builtins.diagnostics.markdownlint.with({
      extra_args = function(params)
        -- Check if project has local .markdownlint.json
        local local_config = params.root .. "/.markdownlint.json"
        if vim.fn.filereadable(local_config) == 1 then
          -- Use project-specific config
          return { "--config", local_config }
        else
          -- Use global default with MD013 disabled
          return { "--config", vim.fn.json_encode({ MD013 = false }) }
        end
      end,
    }))
    
    return opts
  end,
}