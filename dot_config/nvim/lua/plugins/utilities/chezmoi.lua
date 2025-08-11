-- Enhanced Chezmoi configuration - extends LazyVim's chezmoi extra
-- Adds compound filetype detection for better syntax highlighting and LSP support

return {
  -- Extend the existing alker0/chezmoi.vim configuration from LazyVim extra
  {
    "alker0/chezmoi.vim",
    init = function()
      -- Enhanced filetype detection for Chezmoi template files
      -- Creates compound filetypes for better syntax highlighting and LSP support
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "template",
        callback = function()
          local filepath = vim.fn.expand("%:p")

          -- Only apply enhanced filetypes for files in chezmoi directories
          if not filepath:match("/%.local/share/chezmoi/") then
            return
          end

          -- Create compound filetypes for commonly used templates
          if filepath:match("%.sh%.tmpl$") then
            vim.bo.filetype = "sh.chezmoitmpl"
          elseif filepath:match("%.zsh%.tmpl$") then
            vim.bo.filetype = "zsh.chezmoitmpl"
          elseif filepath:match("%.nu%.tmpl$") then
            vim.bo.filetype = "nu.chezmoitmpl"
          elseif filepath:match("%.lua%.tmpl$") then
            vim.bo.filetype = "lua.chezmoitmpl"
          elseif filepath:match("%.json%.tmpl$") then
            vim.bo.filetype = "json.chezmoitmpl"
          elseif filepath:match("%.yaml%.tmpl$") or filepath:match("%.yml%.tmpl$") then
            vim.bo.filetype = "yaml.chezmoitmpl"
          elseif filepath:match("%.toml%.tmpl$") then
            vim.bo.filetype = "toml.chezmoitmpl"
          elseif filepath:match("%.conf%.tmpl$") then
            vim.bo.filetype = "conf.chezmoitmpl"
          end
        end,
      })
    end,
  },
  {
    "folke/snacks.nvim",
    keys = {
      {
        "<leader>fc",
        function()
          require("utils.chezmoi").find_files()
        end,
        desc = "Find Config File (Chezmoi)",
      },
      {
        "<leader>fC",
        function()
          require("utils.chezmoi").open_config_toml()
        end,
        desc = "Open chezmoi.toml",
      },
    },
  },
}
