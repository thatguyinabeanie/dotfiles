-- TreeSitter configuration - extends LazyVim's treesitter setup
-- LazyVim handles the new treesitter API, we just add customizations

-- Map of special case filetypes to parsers
local parser_map = {
  sh = "bash",
  zsh = "bash",
}

return {
  -- Extend LazyVim's treesitter config (don't override config function!)
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = { "RRethy/nvim-treesitter-endwise" },
    opts = {
      -- Add additional parsers to LazyVim's ensure_installed
      ensure_installed = {
        "ruby",
      },
    },
    init = function()
      -- Register yaml.jinja2 filetype to use YAML parser
      vim.treesitter.language.register("yaml", "yaml.jinja2")

      -- Handle template filetypes for chezmoi
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "*",
        callback = function(args)
          local buf = args.buf
          local ft = vim.bo[buf].filetype

          -- Automatically register template filetypes to their base parser
          local base_lang = ft:match("^(.+)%.tmpl$") or ft:match("^(.+)%.chezmoitmpl$")
          if base_lang then
            local parser = parser_map[base_lang] or base_lang
            vim.treesitter.language.register(parser, ft)
          end
        end,
      })
    end,
  },

  -- nvim-treesitter-endwise
  {
    "RRethy/nvim-treesitter-endwise",
    event = "InsertEnter",
  },
}
