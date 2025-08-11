-- Set filetype for .yml.erb and .yaml.erb files
vim.filetype.add({
  extension = {
    ["yml.erb"] = "yaml.erb",
    ["yaml.erb"] = "yaml.erb",
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
