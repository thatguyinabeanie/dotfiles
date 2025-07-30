-- Custom filetype detection for template files
-- Extends the chezmoi filetype detection to handle shell templates properly

vim.filetype.add({
  pattern = {
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

    -- Special chezmoi patterns in template directories
    [".*/%.chezmoitemplates/.*/.*%.tmpl"] = function(path, bufnr)
      -- Extract the base filename without .tmpl extension
      local basename = vim.fn.fnamemodify(path, ":t:r")

      -- If the basename has an extension, use that for filetype
      local ext = vim.fn.fnamemodify(basename, ":e")
      if ext ~= "" then
        -- Map common extensions to filetypes
        local ext_map = {
          sh = "sh",
          zsh = "zsh",
          bash = "bash",
          nu = "nu",
          js = "javascript",
          ts = "typescript",
          py = "python",
          rb = "ruby",
          go = "go",
          rs = "rust",
          lua = "lua",
          json = "json",
          yaml = "yaml",
          yml = "yaml",
          toml = "toml",
          xml = "xml",
          html = "html",
          css = "css",
          scss = "scss",
          md = "markdown",
        }
        return ext_map[ext] or ext
      end

      -- Fallback to detecting by content or path patterns
      return nil
    end,
  },
})
