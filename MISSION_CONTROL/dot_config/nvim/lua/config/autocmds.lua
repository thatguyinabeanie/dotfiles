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
      vim.cmd("cd " .. vim.fn.fnameescape(tostring(first_arg)))
      vim.notify("Working directory: " .. tostring(first_arg), vim.log.levels.INFO)
    end
  end,
})

--
-- BUFREAD< BUFNEWFILE
--
-- Chezmoi template file handling
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.tmpl", "*.gotmpl" },
  callback = function()
    local filepath = vim.fn.expand("%:p")
    local filename = vim.fn.expand("%:t")

    -- Check if this is a chezmoi template (in chezmoi directory or has chezmoi patterns)
    local is_chezmoi = filepath:find("chezmoi")
      or filepath:find("%.chezmoitemplates/")
      or filename:find("^dot_")
      or filename:find("^private_")
      or filename:find("^run_")
      or filename:find("^modify_")

    if is_chezmoi then
      local base_ft = nil

      -- Handle .gotmpl files and template files in .chezmoitemplates
      if filename:match("%.gotmpl$") or filepath:find("%.chezmoitemplates/") then
        -- For files in .chezmoitemplates directory, try to detect target language from path
        if filepath:find("%.chezmoitemplates/") then
          -- Extract target language from directory structure or filename
          local template_path = filepath:match("%.chezmoitemplates/(.+)")
          if template_path then
            -- Check for language-specific subdirectories
            if template_path:find("^neovim/") and template_path:find("%.lua") then
              base_ft = "lua"
            elseif template_path:find("^lua/") then
              base_ft = "lua"
            elseif template_path:find("^shell/") or template_path:find("^bash/") then
              base_ft = "bash"
            elseif template_path:find("^nushell/") or template_path:find("^nu/") then
              base_ft = "nu"
            elseif template_path:find("^python/") then
              base_ft = "python"
            else
              -- Try to extract from filename extension in template path
              base_ft = template_path:match("%.([%w-]+)%.tmpl$")
            end
          end
        end
        -- Fallback for other .gotmpl files
        if not base_ft then
          base_ft = "bash"
        end
      else
        -- Extract base filetype from filename pattern like file.ext.tmpl
        base_ft = filename:match("%.([%w-]+)%.tmpl$")

        -- If no extension found (no dot before .tmpl), check for shebang
        if not base_ft then
          local first_line = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1] or ""
          if first_line:match("^#!") then
            -- Extract interpreter from shebang
            local full_path = first_line:match("^#!/(.+)$")
            local interpreter = nil

            if full_path then
              -- Extract just the binary name from the path
              interpreter = full_path:match("/?([%w%-_]+)%s*$") or full_path:match("([%w%-_]+)$")
            end

            if interpreter then
              -- Map common interpreters to filetypes
              local shebang_map = {
                sh = "bash",
                bash = "bash",
                zsh = "zsh",
                fish = "fish",
                nu = "nu",
                python = "python",
                python3 = "python",
                node = "javascript",
                ruby = "ruby",
                perl = "perl",
                lua = "lua",
                php = "php",
              }
              base_ft = shebang_map[interpreter] or interpreter
            end
          end
        end
      end

      if base_ft then -- Enhanced filetype mapping for chezmoi templates
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

        -- Custom diagnostic filter for chezmoi templates
        local function filter_template_diagnostics(diagnostics)
          local filtered = {}
          for _, diagnostic in ipairs(diagnostics) do
            local line_text = vim.api.nvim_buf_get_lines(0, diagnostic.lnum, diagnostic.lnum + 1, false)[1] or ""

            -- Skip diagnostics that are likely template-related
            local is_template_error = line_text:match("{{.-}}")
              or line_text:match("{{%-.-%-}}")
              or line_text:match("{{%-.-}}")
              or line_text:match("{{.-%-}}")
              or line_text:match("{{/%*.*%*/}}")  -- Go template comments
              or line_text:match("{{/%*")         -- Start of multiline Go template comment
              or line_text:match("%*/}}")         -- End of multiline Go template comment

            if not is_template_error then
              table.insert(filtered, diagnostic)
            end
          end
          return filtered
        end

        -- Apply custom diagnostic filtering
        vim.diagnostic.config({
          virtual_text = {
            format = function(diagnostic)
              return diagnostic.message
            end,
          },
          signs = true,
          underline = true,
          update_in_insert = false,
        })

        -- Set up diagnostic filtering for this buffer
        local filtering_in_progress = false
        vim.api.nvim_create_autocmd("DiagnosticChanged", {
          buffer = vim.api.nvim_get_current_buf(),
          callback = function()
            -- Prevent infinite loop
            if filtering_in_progress then
              return
            end

            filtering_in_progress = true

            vim.schedule(function()
              local diagnostics = vim.diagnostic.get(vim.api.nvim_get_current_buf())
              local filtered = filter_template_diagnostics(diagnostics)

              -- Only update if we actually filtered something
              if #filtered ~= #diagnostics then
                -- Get all namespaces and clear/set for each one
                local ns_ids = vim.diagnostic.get_namespaces()
                for ns_id, _ in pairs(ns_ids) do
                  local ns_diagnostics = vim.diagnostic.get(vim.api.nvim_get_current_buf(), { namespace = ns_id })
                  if #ns_diagnostics > 0 then
                    local ns_filtered = filter_template_diagnostics(ns_diagnostics)
                    vim.diagnostic.reset(ns_id, vim.api.nvim_get_current_buf())
                    if #ns_filtered > 0 then
                      vim.diagnostic.set(ns_id, vim.api.nvim_get_current_buf(), ns_filtered)
                    end
                  end
                end
              end

              filtering_in_progress = false
            end)
          end,
        })

        -- Set up buffer-local settings for chezmoi templates
        vim.b.chezmoi_template = true
        vim.b.template_diagnostic_filter = true
      end
    end
  end,
})

-- Enhanced syntax highlighting for chezmoi templates
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.gotmpl" },
  callback = function()
    local filepath = vim.fn.expand("%:p")
    if filepath:find("chezmoi") or filepath:find("%.chezmoitemplates/") then
      -- Set up syntax highlighting that treats template blocks differently
      vim.cmd([[
        syntax match ChezmoiTemplateDelim /{{[{-]*/ contained
        syntax match ChezmoiTemplateDelim /[}-]*}}/ contained
        syntax region ChezmoiTemplate start=/{{[{-]*/ end=/[}-]*}}/ contains=ChezmoiTemplateDelim
        highlight link ChezmoiTemplateDelim Delimiter
        highlight link ChezmoiTemplate Comment
      ]])
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
  pattern = {
    "*/obsidian-vault/**/*.md",
    "*/obsidian-vault-work/**/*.md",
    "*/smart-notes/**/*.md",
    "*/bramses-highly-opinionated-vault-2023/**/*.md",
  },
  callback = function()
    -- Set filetype to markdown
    vim.opt_local.filetype = "markdown.obsidian"

    -- Enable Obsidian-specific settings
    vim.b.obsidian_file = true
  end,
})
