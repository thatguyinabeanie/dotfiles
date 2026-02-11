-- Mermaid diagram preview - render to PNG and display inline via image.nvim
-- Requires: mermaid-cli (mmdc)
return {
  dir = vim.fn.stdpath("config") .. "/lua/plugins/utilities", -- local config, no external plugin
  name = "mermaid-preview",
  ft = { "markdown" },
  keys = {
    {
      "<leader>mp",
      function()
        -- Find mermaid block at cursor
        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        local row = vim.api.nvim_win_get_cursor(0)[1]
        local start_line, end_line

        for i, line in ipairs(lines) do
          if line:match("^```mermaid") then
            start_line = i
          elseif start_line and line:match("^```%s*$") then
            end_line = i
            if row >= start_line and row <= end_line then
              break
            end
            start_line, end_line = nil, nil
          end
        end

        if not start_line then
          vim.notify("No mermaid block at cursor", vim.log.levels.WARN)
          return
        end

        -- Extract content and render
        local content = table.concat(vim.list_slice(lines, start_line + 1, end_line - 1), "\n")
        local tmp = vim.fn.stdpath("cache") .. "/mermaid"
        vim.fn.mkdir(tmp, "p")

        local input, output = tmp .. "/in.mmd", tmp .. "/out.png"
        vim.fn.writefile(vim.split(content, "\n"), input)

        vim.fn.jobstart({ "mmdc", "-i", input, "-o", output, "-b", "transparent", "-t", "dark" }, {
          on_exit = function(_, code)
            vim.schedule(function()
              if code == 0 then
                local ok, img = pcall(require, "image")
                if ok then
                  img.clear()
                  local i = img.from_file(output, { window = 0, buffer = 0, x = 0, y = end_line })
                  if i then
                    i:render()
                    return
                  end
                end
              end
              vim.fn.system({ "open", output }) -- fallback to Preview.app
            end)
          end,
        })
      end,
      desc = "Preview Mermaid",
    },
    {
      "<leader>mP",
      function()
        local ok, img = pcall(require, "image")
        if ok then
          img.clear()
        end
      end,
      desc = "Clear Mermaid preview",
    },
  },
}
