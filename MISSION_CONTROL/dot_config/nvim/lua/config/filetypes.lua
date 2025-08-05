-- Custom filetype detection for template files
-- Extends the chezmoi filetype detection to handle shell templates properly

vim.filetype.add({
  pattern = {
    -- Symlink templates (should be first to take precedence)
    ["symlink_.*%.tmpl"] = "text",

    -- Chezmoi script templates (higher priority)
    [".*/%.chezmoiscripts/.*/.*%.sh%.tmpl"] = "sh",
    [".*/%.chezmoiscripts/.*/.*%.bash%.tmpl"] = "bash",
    [".*/%.chezmoiscripts/.*/.*%.zsh%.tmpl"] = "zsh",

    -- Chezmoi template files with shell extensions
    ["%.sh%.tmpl"] = "sh",
    ["%.zsh%.tmpl"] = "zsh",
    ["%.bash%.tmpl"] = "bash",
    ["%.fish%.tmpl"] = "fish",
    ["%.nu%.tmpl"] = "nu",

    -- Other common template patterns
    ["%.js%.tmpl"] = "javascript",
    ["%.ts%.tmpl"] = "typescript",
    ["%.py%.tmpl"] = "python",
    ["%.rb%.tmpl"] = "ruby",
    ["%.go%.tmpl"] = "go",
    ["%.rs%.tmpl"] = "rust",
    ["%.lua%.tmpl"] = "lua",

    -- Config file templates
    ["%.json%.tmpl"] = "json",
    ["%.yaml%.tmpl"] = "yaml",
    ["%.yml%.tmpl"] = "yaml",
    ["%.toml%.tmpl"] = "toml",
    ["%.xml%.tmpl"] = "xml",
    ["%.ini%.tmpl"] = "dosini",
    ["%.conf%.tmpl"] = "conf",

    -- -- Special chezmoi patterns in template directories
    -- [".*/%.chezmoitemplates/.*/.*%.tmpl"] = function(path, bufnr)
    --   -- Extract the base filename without .tmpl extension
    --   local basename = vim.fn.fnamemodify(path, ":t:r")
    --   -- If the basename has an extension, use that for filetype
    --   local ext = vim.fn.fnamemodify(basename, ":e")
    --   if ext ~= "" then
    --     -- Map common extensions to filetypes
    --     local ext_map = {
    --       sh = "sh",
    --       zsh = "zsh",
    --       bash = "bash",
    --       nu = "nu",
    --       js = "javascript",
    --       ts = "typescript",
    --       py = "python",
    --       rb = "ruby",
    --       go = "go",
    --       rs = "rust",
    --       lua = "lua",
    --       json = "json",
    --       yaml = "yaml",
    --       yml = "yaml",
    --       toml = "toml",
    --       xml = "xml",
    --       html = "html",
    --       css = "css",
    --       scss = "scss",
    --       md = "markdown",
    --     }
    --     return ext_map[ext] or ext
    --   end
    --   -- Fallback to detecting by content or path patterns
    --   return nil
    -- end,
    --
  },
})

-- Override template filetype for chezmoi shell scripts
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = "template",
  callback = function()
    local filepath = vim.fn.expand("%:p")
    
    -- Map file extensions to compound filetypes for better template support
    if filepath:match("%.sh%.tmpl$") then
      vim.bo.filetype = "sh.chezmoitmpl"
    elseif filepath:match("%.bash%.tmpl$") then
      vim.bo.filetype = "bash.chezmoitmpl"
    elseif filepath:match("%.zsh%.tmpl$") then
      vim.bo.filetype = "zsh.chezmoitmpl"
    elseif filepath:match("%.py%.tmpl$") then
      vim.bo.filetype = "python.chezmoitmpl"
    elseif filepath:match("%.js%.tmpl$") then
      vim.bo.filetype = "javascript.chezmoitmpl"
    elseif filepath:match("%.ts%.tmpl$") then
      vim.bo.filetype = "typescript.chezmoitmpl"
    elseif filepath:match("%.lua%.tmpl$") then
      vim.bo.filetype = "lua.chezmoitmpl"
    elseif filepath:match("%.go%.tmpl$") then
      vim.bo.filetype = "go.chezmoitmpl"
    elseif filepath:match("%.rs%.tmpl$") then
      vim.bo.filetype = "rust.chezmoitmpl"
    elseif filepath:match("%.rb%.tmpl$") then
      vim.bo.filetype = "ruby.chezmoitmpl"
    elseif filepath:match("%.json%.tmpl$") then
      vim.bo.filetype = "json.chezmoitmpl"
    elseif filepath:match("%.yaml%.tmpl$") or filepath:match("%.yml%.tmpl$") then
      vim.bo.filetype = "yaml.chezmoitmpl"
    elseif filepath:match("%.toml%.tmpl$") then
      vim.bo.filetype = "toml.chezmoitmpl"
    end
  end,
})
