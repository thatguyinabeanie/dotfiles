-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")


--
-- AUTO CHANGE TO GIT ROOT DIRECTORY
--
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    -- Get the first argument
    local first_arg = vim.fn.argv(0)
    
    -- If we're opening a directory
    if first_arg ~= "" and vim.fn.isdirectory(first_arg) == 1 then
      -- Change to the specified directory (don't go to git root)
      vim.cmd("cd " .. vim.fn.fnameescape(first_arg))
      vim.notify("Working directory: " .. first_arg, vim.log.levels.INFO)
    end
  end,
})



--
-- BUFREAD< BUFNEWFILE
--
-- Chezmoi template file handling
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.tmpl" },
  callback = function()
    local filepath = vim.fn.expand("%:p")
    local filename = vim.fn.expand("%:t")
    
    -- Check if this is a chezmoi template (in chezmoi directory or has chezmoi patterns)
    local is_chezmoi = filepath:find("chezmoi") or filepath:find("%.chezmoitemplates/") or 
                      filename:find("^dot_") or filename:find("^private_") or 
                      filename:find("^run_") or filename:find("^modify_")
    
    if is_chezmoi then
      -- Extract base filetype from filename pattern like file.ext.tmpl
      local base_ft = filename:match("%.([%w-]+)%.tmpl$")
      
      if base_ft then
        -- Enhanced filetype mapping for chezmoi templates
        local filetype_map = {
          nu = "nu",
          lua = "lua", 
          sh = "bash",
          bash = "bash",
          zsh = "zsh",
          fish = "fish",
          toml = "toml",
          json = "json",
          yaml = "yaml",
          yml = "yaml",
          xml = "xml",
          html = "html",
          css = "css",
          js = "javascript",
          ts = "typescript",
          py = "python",
          rb = "ruby",
          go = "go",
          rs = "rust",
          vim = "vim",
          conf = "conf",
          config = "conf",
          gitignore = "gitignore",
          gitconfig = "gitconfig",
          dockerfile = "dockerfile",
        }
        
        local target_ft = filetype_map[base_ft] or base_ft
        vim.bo.filetype = target_ft
        
        -- Disable certain diagnostics for chezmoi templates
        vim.diagnostic.config({
          virtual_text = false,
          signs = false,
          underline = false,
          update_in_insert = false,
        }, vim.api.nvim_get_current_buf())
        
        -- Set up buffer-local settings for chezmoi templates
        vim.b.chezmoi_template = true
        
        -- Add template syntax patterns to be ignored
        vim.b.lsp_ignore_patterns = {
          "{{.*}}",           -- Chezmoi template expressions
          "{%-.*%-%}",        -- Chezmoi template blocks
          "{{-.*-}}",         -- Chezmoi template with whitespace control
        }
        
        -- Notify that this is a chezmoi template
        vim.notify("Chezmoi template detected: " .. target_ft .. " syntax with template support", vim.log.levels.INFO)
      end
    end
  end,
})

-- CodeQL files
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.ql", "*.qll" },
  callback = function()
    vim.opt_local.filetype = "ql"
  end,
})

-- Obsidian and Markdown files
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "markdown" },
  callback = function()
    -- Enable spell checking
    vim.opt_local.spell = true
    vim.opt_local.spelllang = "en_us"

    -- Enable soft wrapping for markdown files
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.breakindent = true

    -- Set tab settings for markdown
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true

    -- Set conceallevel for markdown
    vim.opt_local.conceallevel = 2

    -- Disable auto-pairs for markdown files to avoid issues with brackets in links
    -- vim.g.AutoPairsMapSpace = 0
  end,
})

-- Detect Obsidian vault files
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*/obsidian-vault/**/*.md", "*/obsidian-vault-work/**/*.md", "*/smart-notes/**/*.md", "*/bramses-highly-opinionated-vault-2023/**/*.md" },
  callback = function()
    -- Set filetype to markdown
    vim.opt_local.filetype = "markdown.obsidian"

    -- Enable Obsidian-specific settings
    vim.b.obsidian_file = true
  end,
})
