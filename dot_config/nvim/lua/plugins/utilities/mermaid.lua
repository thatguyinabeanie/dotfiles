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

        -- Ensure the fenced block is properly closed before rendering
        if not end_line or end_line <= start_line then
          vim.notify("Mermaid block at cursor is not properly closed (missing closing ```)", vim.log.levels.WARN)
          return
        end

        -- Extract content and render
        local content = table.concat(vim.list_slice(lines, start_line + 1, end_line - 1), "\n")
        local tmp = vim.fn.stdpath("cache") .. "/mermaid"
        vim.fn.mkdir(tmp, "p")

        -- Use unique filenames per invocation to avoid preview races
        local bufnr = vim.api.nvim_get_current_buf()
        local hrtime = (vim.uv and vim.uv.hrtime and vim.uv.hrtime())
          or (vim.loop and vim.loop.hrtime and vim.loop.hrtime())
          or os.time()
        local base = string.format("%s/preview_%d_%d", tmp, bufnr, hrtime)
        local input, output = base .. ".mmd", base .. ".png"
        vim.fn.writefile(vim.split(content, "\n"), input)

        -- Open the rendered image without blocking Neovim
        local function open_output(path)
          if vim.ui and vim.ui.open then
            vim.ui.open(path)
            return
          end

          local opener
          if vim.fn.has("mac") == 1 then
            opener = { "open", path }
          elseif vim.fn.has("win32") == 1 then
            opener = { "cmd", "/c", "start", "", path }
          elseif vim.fn.executable("xdg-open") == 1 then
            opener = { "xdg-open", path }
          end

          if opener then
            vim.fn.jobstart(opener, { detach = true })
          else
            vim.notify("No system opener available for Mermaid preview output", vim.log.levels.WARN)
          end
        end

        -- Collect stderr so we can report failures clearly
        local stderr = {}

        vim.fn.jobstart({ "mmdc", "-i", input, "-o", output, "-b", "transparent", "-t", "dark" }, {
          stderr_buffered = true,
          on_stderr = function(_, data)
            if not data then
              return
            end
            for _, line in ipairs(data) do
              if line ~= "" then
                table.insert(stderr, line)
              end
            end
          end,
          on_exit = function(_, code)
            vim.schedule(function()
              if code ~= 0 or vim.fn.filereadable(output) == 0 then
                local message = "Mermaid render failed"
                if #stderr > 0 then
                  message = message .. ": " .. table.concat(stderr, " ")
                end
                vim.notify(message, vim.log.levels.ERROR)
                return
              end

              local ok, img = pcall(require, "image")
              if ok then
                img.clear()
                local i = img.from_file(output, { window = 0, buffer = 0, x = 0, y = end_line })
                if i then
                  i:render()
                  return
                end
              end

              open_output(output)
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
