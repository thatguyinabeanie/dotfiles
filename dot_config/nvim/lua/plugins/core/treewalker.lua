--[[
Treewalker.nvim - Fast Tree-sitter Based Navigation

OVERVIEW:
Treewalker provides fast, predictable movement through your code using Tree-sitter's
syntax tree structure. Instead of moving by lines or words, it moves by logical
code constructs (functions, blocks, statements, etc.).

KEYBINDINGS:
This configuration uses Alt+hjkl for tree navigation:

  TREE NAVIGATION (Normal + Visual):
    Alt+h  →  Move to previous sibling node (Treewalker Left)
    Alt+j  →  Move to child node (Treewalker Down)
    Alt+k  →  Move to parent node (Treewalker Up)
    Alt+l  →  Move to next sibling node (Treewalker Right)

  NODE SWAPPING (Normal only):
    Alt+Shift+h  →  Swap node with previous sibling (Swap Left)
    Alt+Shift+j  →  Swap node downward (Swap Down)
    Alt+Shift+k  →  Swap node upward (Swap Up)
    Alt+Shift+l  →  Swap node with next sibling (Swap Right)

MODIFIER HIERARCHY:
  Ctrl+hjkl       →  Pane navigation (vim-tmux-navigator) - UNTOUCHABLE
  Alt+hjkl        →  Tree navigation (Treewalker)
  Alt+Shift+hjkl  →  Node swapping (Treewalker)
  Alt+Ctrl+jk     →  Line operations (move line up/down)
  Alt+Ctrl+hl     →  Line operations (indent/dedent)

COMMANDS:
  :Treewalker Up      - Move up the syntax tree (to parent node)
  :Treewalker Down    - Move down the syntax tree (to first child)
  :Treewalker Left    - Move to previous sibling node
  :Treewalker Right   - Move to next sibling node
  :Treewalker SwapUp/SwapDown/SwapLeft/SwapRight - Swap nodes

USAGE EXAMPLES:
- In a function: Down moves into the function body, Up moves to function definition
- In an if statement: Left/Right moves between if/else/elseif blocks
- In arrays/objects: Left/Right moves between elements
- In method chains: Up/Down navigates the chain hierarchy
- Swapping: Reorder function arguments, array elements, or sibling statements

WHY USE TREEWALKER:
- Faster than traditional navigation for code structure
- Consistent behavior across different file types
- Respects code semantics rather than just text layout
- Great for refactoring and code exploration
- Integrates with jumplist (Ctrl+o/Ctrl+i)

NOTE: Requires Tree-sitter parsers for your languages to work effectively.

DOCUMENTATION: See .docs/treewalker-integration.md for comprehensive integration guide.
--]]

return {
  {
    "aaronik/treewalker.nvim",

    -- Load on VeryLazy to ensure it's available when needed
    event = "VeryLazy",

    -- Config function runs after plugin is loaded
    config = function()
      -- Setup plugin with options
      require("treewalker").setup({
        highlight = true,
        highlight_duration = 250,
        highlight_group = "CursorLine",
        select = false,
        jumplist = true,
      })

      -- Use vim.schedule to defer keymap setting until after all VeryLazy events complete
      -- This ensures we override LazyVim's default Alt+j/k keymaps
      vim.schedule(function()
        local map = vim.keymap.set

        -- Tree navigation (normal + visual mode)
        map({ "n", "v" }, "<M-h>", "<cmd>Treewalker Left<cr>", { desc = "Treewalker Left", silent = true })
        map({ "n", "v" }, "<M-j>", "<cmd>Treewalker Down<cr>", { desc = "Treewalker Down", silent = true })
        map({ "n", "v" }, "<M-k>", "<cmd>Treewalker Up<cr>", { desc = "Treewalker Up", silent = true })
        map({ "n", "v" }, "<M-l>", "<cmd>Treewalker Right<cr>", { desc = "Treewalker Right", silent = true })

        -- Node swapping (normal mode only)
        map("n", "<M-S-h>", "<cmd>Treewalker SwapLeft<cr>", { desc = "Treewalker Swap Left", silent = true })
        map("n", "<M-S-j>", "<cmd>Treewalker SwapDown<cr>", { desc = "Treewalker Swap Down", silent = true })
        map("n", "<M-S-k>", "<cmd>Treewalker SwapUp<cr>", { desc = "Treewalker Swap Up", silent = true })
        map("n", "<M-S-l>", "<cmd>Treewalker SwapRight<cr>", { desc = "Treewalker Swap Right", silent = true })
      end)
    end,
  },
}
