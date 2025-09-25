--[[
Treewalker.nvim - Fast Tree-sitter Based Navigation

OVERVIEW:
Treewalker provides fast, predictable movement through your code using Tree-sitter's
syntax tree structure. Instead of moving by lines or words, it moves by logical
code constructs (functions, blocks, statements, etc.).

KEYBINDINGS:
The plugin doesn't set default keybindings. You need to map the commands yourself.
Common mappings in your keymaps:

  vim.keymap.set('n', '<C-j>', '<cmd>Treewalker Down<cr>', { silent = true })
  vim.keymap.set('n', '<C-k>', '<cmd>Treewalker Up<cr>', { silent = true })
  vim.keymap.set('n', '<C-h>', '<cmd>Treewalker Left<cr>', { silent = true })
  vim.keymap.set('n', '<C-l>', '<cmd>Treewalker Right<cr>', { silent = true })

COMMANDS:
  :Treewalker Up      - Move up the syntax tree (to parent node)
  :Treewalker Down    - Move down the syntax tree (to first child)
  :Treewalker Left    - Move to previous sibling node
  :Treewalker Right   - Move to next sibling node

USAGE EXAMPLES:
- In a function: Down moves into the function body, Up moves to function definition
- In an if statement: Left/Right moves between if/else/elseif blocks
- In arrays/objects: Left/Right moves between elements
- In method chains: Up/Down navigates the chain hierarchy

WHY USE TREEWALKER:
- Faster than traditional navigation for code structure
- Consistent behavior across different file types
- Respects code semantics rather than just text layout
- Great for refactoring and code exploration

NOTE: Requires Tree-sitter parsers for your languages to work effectively.
--]]

return {
  {
    "aaronik/treewalker.nvim",

    -- The following options are the defaults.
    -- Treewalker aims for sane defaults, so these are each individually optional,
    -- and setup() does not need to be called, so the whole opts block is optional as well.
    opts = {
        -- Whether to briefly highlight the node after jumping to it
        highlight = true,

        -- How long should above highlight last (in ms)
        highlight_duration = 250,

        -- The color of the above highlight. Must be a valid vim highlight group.
        -- (see :h highlight-group for options)
        highlight_group = "CursorLine",

        -- Whether to create a visual selection after a movement to a node.
        -- If true, highlight is disabled and a visual selection is made in
        -- its place.
        select = false,

        -- Whether the plugin adds movements to the jumplist -- true | false | 'left'
        --  true: All movements more than 1 line are added to the jumplist. This is the default,
        --        and is meant to cover most use cases. It's modeled on how { and } natively add
        --        to the jumplist.
        --  false: Treewalker does not add to the jumplist at all
        --  "left": Treewalker only adds :Treewalker Left to the jumplist. This is usually the most
        --          likely one to be confusing, so it has its own mode.
        jumplist = true
    }
  },
}
