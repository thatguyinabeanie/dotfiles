-- Get work environment from env var
local work_env = os.getenv("WORK_ENVIRONMENT")

-- Set default scratchpad contents based on environment
local default_contents = [[# API Requests

## Quick Test

```http
GET https://httpbin.org/get
```
]]

if work_env then
  default_contents = [[# Civis Analytics API Requests

## Notes

- Use the appropriate environment section
- Update @path and @id variables as needed
- Copy the HTTP block content to a .http file if kulala doesn't execute directly from markdown

## Production

```http
@baseUrl=https://api.civisanalytics.com
@civisApiKey = {{CIVIS_API_KEY_PRODUCTION}}
@path=code_clouds
@id=48

### POST
POST {{baseUrl}}/{{path}}
Authorization: Bearer {{civisApiKey}}
Content-Type: application/json
Accept: application/json
{ }

### LIST
GET {{baseUrl}}/{{path}}
Authorization: Bearer {{civisApiKey}}
Content-Type: application/json
Accept: application/json

### GET
GET {{baseUrl}}/{{path}}/{{id}}
Authorization: Bearer {{civisApiKey}}
Content-Type: application/json
Accept: application/json

### PATCH
PATCH {{baseUrl}}/{{path}}/{{id}}
Authorization: Bearer {{civisApiKey}}
Content-Type: application/json
Accept: application/json
{ }

```

## Staging

```http
@baseUrl=https://api-staging.civisanalytics.com
@civisApiKey={{CIVIS_API_KEY_STAGING}}
@path=code_clouds
@id=43

### POST
POST {{baseUrl}}/{{path}}
Authorization: Bearer {{civisApiKey}}
Content-Type: application/json
Accept: application/json
{ }

### LIST
GET {{baseUrl}}/{{path}}
Authorization: Bearer {{civisApiKey}}
Content-Type: application/json
Accept: application/json

### GET
GET {{baseUrl}}/{{path}}/{{id}}
Authorization: Bearer {{civisApiKey}}
Content-Type: application/json
Accept: application/json

### PATCH
PATCH {{baseUrl}}/{{path}}/{{id}}
Authorization: Bearer {{civisApiKey}}
Content-Type: application/json
Accept: application/json
{ }
```

## Local Development

```http
@baseUrl=https://platform.civis.test:3000
@civisApiKey={{CIVIS_API_KEY_LOCAL_CONSOLE}}
@path=code_clouds
@id=43

### POST
POST {{baseUrl}}/{{path}}
Authorization: Bearer {{civisApiKey}}
Content-Type: application/json
Accept: application/json
{ }

### LIST
GET {{baseUrl}}/{{path}}
Authorization: Bearer {{civisApiKey}}
Content-Type: application/json
Accept: application/json

### GET
GET {{baseUrl}}/{{path}}/{{id}}
Authorization: Bearer {{civisApiKey}}
Content-Type: application/json
Accept: application/json

### PATCH
PATCH {{baseUrl}}/{{path}}/{{id}}
Authorization: Bearer {{civisApiKey}}
Content-Type: application/json
Accept: application/json
]]
end

return {
  "mistweaverco/kulala.nvim",
  keys = {
    { "<leader>R", "", desc = "+Rest" },
    { "<leader>Rb", "<cmd>lua require('kulala').scratchpad()<cr>", desc = "Open scratchpad" },
    { "<leader>Rc", "<cmd>lua require('kulala').copy()<cr>", desc = "Copy as cURL" },
    { "<leader>RC", "<cmd>lua require('kulala').from_curl()<cr>", desc = "Paste from curl" },
    { "<leader>Ri", "<cmd>lua require('kulala').inspect()<cr>", desc = "Inspect current request" },
    { "<leader>Rn", "<cmd>lua require('kulala').jump_next()<cr>", desc = "Jump to next request" },
    { "<leader>Rp", "<cmd>lua require('kulala').jump_prev()<cr>", desc = "Jump to previous request" },
    { "<leader>Rq", "<cmd>lua require('kulala').close()<cr>", desc = "Close window" },
    { "<leader>Rr", "<cmd>lua require('kulala').replay()<cr>", desc = "Replay the last request" },
    { "<leader>Rs", "<cmd>lua require('kulala').run()<cr>", desc = "Send the request" },
    { "<leader>RS", "<cmd>lua require('kulala').show_stats()<cr>", desc = "Show stats" },
    { "<leader>Rt", "<cmd>lua require('kulala').toggle_view()<cr>", desc = "Toggle headers/body" },
    {
      "<leader>Rg",
      "<cmd>lua require('kulala').download_graphql_schema()<cr>",
      desc = "Download GraphQL schema",
    },
  },

  opts = {
    scratchpad_default_contents = vim.split(default_contents, "\n"),
    default_view = "body",
    debug = false,
    global_keymaps = true,
    global_keymaps_prefix = "<leader>R",
  },

  config = function(_, opts)
    -- Ensure kulala data directory exists
    local data_path = vim.fn.stdpath("data") .. "/kulala"
    vim.fn.mkdir(data_path, "p")

    require("kulala").setup(opts)

    -- Add autocmd to prevent buffer write issues with scratchpad
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "http", "rest" },

      callback = function(args)
        local bufname = vim.api.nvim_buf_get_name(args.buf)
        -- If this is a kulala scratchpad buffer (no file path), set it as not modifiable for saving
        if bufname == "" or bufname:match("kulala://scratchpad") then
          vim.bo[args.buf].buftype = "nofile"
          vim.bo[args.buf].bufhidden = "wipe"

          -- Set filetype to markdown for better experience
          vim.bo[args.buf].filetype = "markdown"

          -- Use vim.schedule to set window options after buffer is properly displayed
          vim.schedule(function()
            -- Find the window displaying this buffer
            local wins = vim.fn.win_findbuf(args.buf)
            if #wins > 0 then
              local win = wins[1]
              -- Enable word wrap for markdown
              vim.api.nvim_set_option_value("wrap", true, { win = win })
              vim.api.nvim_set_option_value("linebreak", true, { win = win })

              -- Enable spell checking for markdown content
              vim.api.nvim_set_option_value("spell", true, { win = win })

              -- Set conceallevel for markdown (hides markup)
              vim.api.nvim_set_option_value("conceallevel", 2, { win = win })

              -- Enable folding for markdown sections
              vim.api.nvim_set_option_value("foldmethod", "expr", { win = win })
              vim.api.nvim_set_option_value("foldexpr", "nvim_treesitter#foldexpr()", { win = win })
              vim.api.nvim_set_option_value("foldenable", true, { win = win })
            end
          end)
        end
      end,
    })
  end,
}
