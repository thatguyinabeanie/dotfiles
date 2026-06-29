-- obsidian.nvim — Obsidian vault commands (daily notes, templates, switcher, backlinks).
-- Integration decisions (see plan):
--   * Inside a vault, obsidian-ls (the built-in LSP) owns completion/references/rename.
--     LSP arbitration in lua/config/autocmds.lua keeps markdown-oxide/marksman out of vaults
--     (and keeps obsidian-ls out of non-vault markdown).
--   * render-markdown.nvim owns rendering/concealment → obsidian ui disabled.
-- Uses the actively-maintained community fork (obsidian-nvim), not the dormant epwalsh repo.

-- Walk upward from `dir` looking for a `.obsidian/` marker; return the vault root if found.
local function find_vault_root(dir)
  local marker = vim.fs.find(".obsidian", { path = dir, upward = true, type = "directory" })[1]
  if marker then
    return vim.fn.fnamemodify(marker, ":h")
  end
end

-- Directory of the current buffer, falling back to the working directory.
local function context_dir()
  local bufname = vim.api.nvim_buf_get_name(0)
  if bufname ~= "" then
    return vim.fn.fnamemodify(bufname, ":p:h")
  end
  return vim.uv.cwd()
end

-- Build the workspace list dynamically:
--   1. the vault containing the current file/dir (any folder with a .obsidian marker)
--   2. the personal vault from $OBSIDIAN_VAULT (or its dotfiles default), if it exists
-- Nonexistent paths are skipped so obsidian.nvim never errors on a missing vault.
local function build_workspaces()
  local workspaces = {}
  local seen = {}
  local function add(name, path)
    if not path or path == "" then
      return
    end
    path = vim.fn.fnamemodify(path, ":p"):gsub("/$", "")
    if vim.fn.isdirectory(path) == 1 and not seen[path] then
      seen[path] = true
      table.insert(workspaces, { name = name, path = path })
    end
  end

  local vault = find_vault_root(context_dir())
  if vault then
    add(vim.fn.fnamemodify(vault, ":t"), vault)
  end

  add("personal", os.getenv("OBSIDIAN_VAULT") or vim.fn.expand("~/.local/share/obsidian"))

  return workspaces
end

return {
  {
    "obsidian-nvim/obsidian.nvim",
    ft = "markdown",
    cmd = "Obsidian",
    opts = function()
      return {
        legacy_commands = false,
        workspaces = build_workspaces(),
        -- render-markdown.nvim owns rendering; avoid double concealment
        ui = { enable = false },
      }
    end,
    config = function(_, opts)
      -- No valid workspace (not in a vault and personal vault absent) → skip setup
      -- so obsidian.nvim never errors; markdown LSPs still serve markdown elsewhere.
      if vim.tbl_isempty(opts.workspaces) then
        return
      end
      require("obsidian").setup(opts)
    end,
    keys = {
      { "<leader>O", "", desc = "+obsidian" },
      { "<leader>Ot", "<cmd>Obsidian today<cr>", desc = "Obsidian: today's daily note" },
      { "<leader>Oy", "<cmd>Obsidian yesterday<cr>", desc = "Obsidian: yesterday's note" },
      { "<leader>On", "<cmd>Obsidian new<cr>", desc = "Obsidian: new note" },
      { "<leader>Oo", "<cmd>Obsidian quick_switch<cr>", desc = "Obsidian: quick switch" },
      { "<leader>Os", "<cmd>Obsidian search<cr>", desc = "Obsidian: search notes" },
      { "<leader>Ob", "<cmd>Obsidian backlinks<cr>", desc = "Obsidian: backlinks" },
      { "<leader>Og", "<cmd>Obsidian tags<cr>", desc = "Obsidian: tags" },
      { "<leader>OT", "<cmd>Obsidian template<cr>", desc = "Obsidian: insert template" },
      { "<leader>Op", "<cmd>Obsidian paste_img<cr>", desc = "Obsidian: paste image" },
    },
  },
}
