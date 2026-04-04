-- Toggle diffview: close if open, open if there are changes, notify otherwise.
local function toggle_diffview()
  local lib = require("diffview.lib")
  if lib.get_current_view() ~= nil then
    vim.cmd("DiffviewClose")
    return
  end

  -- Async git check — no blocking on the main loop
  vim.system({ "git", "status", "--porcelain" }, { text = true }, function(result)
    vim.schedule(function()
      if result.code == 0 and result.stdout and result.stdout ~= "" then
        vim.cmd("DiffviewOpen")
      else
        vim.notify("No git changes detected", vim.log.levels.INFO)
      end
    end)
  end)
end

return {
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
    keys = {
      { "<leader>gd", toggle_diffview, desc = "Git - Toggle Diffview" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "Git - File History" },
    },
    opts = {
      enhanced_diff_hl = true,
      view = {
        default = {
          layout = "diff2_horizontal",
        },
      },
    },
  },
}
