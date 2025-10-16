-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Disable diagnostics for Markdown files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.diagnostic.enable(false)
  end,
})

-- Optional: Notification when a file is reloaded
vim.api.nvim_create_autocmd("FileChangedShellPost", {
  pattern = "*",
  callback = function()
    vim.notify("File changed on disk. Buffer reloaded.", vim.log.levels.INFO)
  end,
})

-- Custom filetype detection and configuration
-- Unified template file handling:
-- - Chezmoi .tmpl files → <basetype>.chezmoitmpl
-- - Non-chezmoi .tmpl files → <basetype>.tmpl
vim.filetype.add({
  extension = {
    tmpl = function(path, bufnr)
      -- Extract base name without .tmpl extension
      local base_name = vim.fn.fnamemodify(path, ":t:r")
      local base_ext = vim.fn.fnamemodify(base_name, ":e")

      -- Check if file is in chezmoi directory
      if path:match("/%.local/share/chezmoi/") then
        -- If base has an extension, use it with .chezmoitmpl suffix
        if base_ext ~= "" then
          return base_ext .. ".chezmoitmpl"
        end
        -- No extension: let filename patterns handle specific cases (dot_bashrc, etc.)
        return nil
      end

      -- For non-chezmoi .tmpl files (e.g., ~/source/popsicle/test.toml.tmpl)
      if base_ext ~= "" then
        return base_ext .. ".tmpl"
      end
      return "tmpl"
    end,
    ["yml.erb"] = "yaml.erb",
  },

  filename = {
    [".chezmoiignore"] = "gitignore",
    [".chezmoiexternal"] = "toml",
    [".chezmoiexternal.toml"] = "toml",
    ["dot_profile.tmpl"] = "bash.chezmoitmpl",
    ["dot_bashrc.tmpl"] = "bash.chezmoitmpl",
    ["dot_zshenv.tmpl"] = "zsh.chezmoitmpl",
    ["dot_zshrc.tmpl"] = "zsh.chezmoitmpl",
  },
})
