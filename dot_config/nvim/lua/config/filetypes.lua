-- Custom filetype detection and configuration
-- This file is loaded early in init.lua to ensure custom filetypes are available

-- Enhanced filetype detection for common template files
vim.filetype.add({
  extension = {
    tmpl = function(path, bufnr)
      -- Detect the base extension before .tmpl
      local base_name = vim.fn.fnamemodify(path, ":t:r")
      local base_ext = vim.fn.fnamemodify(base_name, ":e")

      if base_ext ~= "" then
        return base_ext .. ".tmpl"
      end
      return "tmpl"
    end,
    ["yml.erb"] = "yaml.erb",
    ["yaml.erb"] = "yaml.erb",
  },
  filename = {
    [".chezmoiignore"] = "gitignore",
    [".chezmoiexternal"] = "toml",
    [".chezmoiexternal.toml"] = "toml",
  },
  pattern = {
    [".*%.toml%.tmpl"] = "toml.tmpl",
    [".*%.yaml%.tmpl"] = "yaml.tmpl",
    [".*%.yml%.tmpl"] = "yaml.tmpl",
    [".*%.json%.tmpl"] = "json.tmpl",
    [".*%.lua%.tmpl"] = "lua.tmpl",
    [".*%.sh%.tmpl"] = "sh.tmpl",
    [".*%.zsh%.tmpl"] = "zsh.tmpl",
    [".*%.nu%.tmpl"] = "nu.tmpl",
    [".*%.conf%.tmpl"] = "conf.tmpl",
  },
})

-- Configure syntax highlighting for ERB YAML files
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.yml.erb", "*.yaml.erb" },
  callback = function()
    vim.bo.filetype = "yaml.erb"
    vim.bo.syntax = "yaml.erb"
  end,
})
