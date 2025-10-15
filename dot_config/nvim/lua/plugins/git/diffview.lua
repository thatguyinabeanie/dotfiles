-- Function to check if there are git changes
local function has_git_changes()
  local handle = io.popen("git status --porcelain 2>/dev/null")
  if not handle then
    return false
  end
  local result = handle:read("*a")
  handle:close()
  return result and result ~= ""
end

-- Function to check if diffview is currently open
local function is_diffview_open()
  local lib = require("diffview.lib")
  return lib.get_current_view() ~= nil
end

-- Smart diffview toggle function
local function smart_diffview_toggle()
  if is_diffview_open() then
    vim.cmd("DiffviewClose")
  elseif has_git_changes() then
    vim.cmd("DiffviewOpen")
  else
    vim.notify("No git changes detected", vim.log.levels.INFO)
  end
end

-- Set up dynamic keybinding
local function setup_dynamic_keybind()
  if has_git_changes() or is_diffview_open() then
    vim.keymap.set("n", "<leader>gd", smart_diffview_toggle, {
      desc = is_diffview_open() and "Git - Close Diffview" or "Git - Open Diffview",
      silent = true,
    })
  else
    -- Remove the keybinding if no changes
    pcall(vim.keymap.del, "n", "<leader>gd")
  end
end

return {
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
    keys = {
      { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "Git - File History" },
    },
    config = function()
      require("diffview").setup({
        enhanced_diff_hl = true,
        view = {
          default = {
            layout = "diff2_horizontal",
          },
        },
        hooks = {
          view_opened = function()
            setup_dynamic_keybind()
          end,
          view_closed = function()
            setup_dynamic_keybind()
          end,
        },
      })

      -- Setup initial keybinding
      setup_dynamic_keybind()

      -- Update keybinding when entering/leaving diffview
      local group = vim.api.nvim_create_augroup("DiffviewDynamic", { clear = true })

      vim.api.nvim_create_autocmd({ "User" }, {
        pattern = { "DiffviewViewOpened", "DiffviewViewClosed" },
        group = group,
        callback = setup_dynamic_keybind,
      })

      -- Update keybinding on git status changes (when files are saved)
      vim.api.nvim_create_autocmd({ "BufWritePost", "FocusGained" }, {
        group = group,
        callback = function()
          vim.defer_fn(setup_dynamic_keybind, 100)
        end,
      })
    end,
  },
}
