-- Improve floating window visibility with transparency
return {
  {
    "folke/lazy.nvim",
    event = "VeryLazy",
    config = function()
      -- Customize floating window appearance
      local border = "rounded"
      
      -- Override the default floating window handler
      local orig_win_open = vim.api.nvim_win_open
      vim.api.nvim_win_open = function(buffer, enter, config)
        -- Add border to floating windows if not already specified
        if config and config.relative and not config.border then
          config.border = border
        end
        
        -- If it's a floating window, add background color
        if config and config.relative then
          -- Set a semi-opaque background for better readability
          config.style = "minimal"
        end
        
        return orig_win_open(buffer, enter, config)
      end
      
      -- Customize Neovim's built-in documentation windows
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
        vim.lsp.handlers.hover,
        { border = border }
      )
      
      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
        vim.lsp.handlers.signature_help,
        { border = border }
      )
      
      -- Customize diagnostic floating windows
      vim.diagnostic.config({
        float = {
          border = border,
          style = "minimal",
        },
      })
    end,
  },
}
