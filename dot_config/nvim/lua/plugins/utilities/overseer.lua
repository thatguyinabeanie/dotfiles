-- Overseer task-runner configuration
--
-- Extends the LazyVim overseer extra with:
--   • tmux_window strategy  – run background services in a tmux window that
--     survives `:qa` (the process keeps running even after Neovim exits)
--   • Pre-built templates   – npm dev, npm build, vite, etc.
--   • "Go to tmux window"   – action visible in the task list for tmux tasks
--
-- Keymaps (provided by LazyVim extra, not redefined here):
--   <leader>oo  OverseerRun     – pick and run a task
--   <leader>ot  OverseerTaskAction – run action on task
--   <leader>ow  OverseerToggle  – show/hide task list
return {
  {
    "stevearc/overseer.nvim",
    -- LazyVim already sets up overseer; we layer our opts on top
    opts = function(_, opts)
      -- ── custom action: navigate to the tmux window ───────────────────────
      opts.actions = opts.actions or {}
      opts.actions["Go to tmux window"] = {
        desc = "Switch tmux focus to the window running this task",
        condition = function(task)
          return task.metadata and task.metadata.tmux_pane_id ~= nil
        end,
        run = function(task)
          local pane = task.metadata.tmux_pane_id
          if pane then
            vim.fn.system({ "tmux", "select-pane", "-t", pane })
          end
        end,
      }

      -- ── component alias for long-running background tasks ─────────────────
      -- Use this as `components = { "background" }` in templates below.
      -- Differences from "default":
      --   • no auto-dispose (background tasks should stick around)
      --   • notify only when status changes (not on every completion)
      opts.component_aliases = vim.tbl_extend("force", opts.component_aliases or {}, {
        background = {
          "on_exit_set_status",
          { "on_complete_notify", on_change = true },
          { "unique", replace = false },
        },
      })

      return opts
    end,

    config = function(_, opts)
      local overseer = require("overseer")
      overseer.setup(opts)

      -- ──────────────────────────────────────────────────────────────────────
      -- BUILT-IN BACKGROUND TASK TEMPLATES
      --
      -- These show up in :OverseerRun under the "background" tag.
      -- All use the tmux_window strategy so they survive :qa.
      -- ──────────────────────────────────────────────────────────────────────

      -- Helper: build a standard background task definition
      local function bg_task(name, cmd, extra)
        return vim.tbl_extend("force", {
          name = name,
          cmd = cmd,
          strategy = {
            "tmux_window",
            window_name = name:gsub("[^%w%-_]", "-"):sub(1, 25),
            close_on_exit = false,
          },
          components = { "background" },
        }, extra or {})
      end

      -- ── npm / node ────────────────────────────────────────────────────────
      overseer.register_template({
        name = "npm: run dev (tmux)",
        tags = { "background", "npm", "dev" },
        condition = {
          callback = function(search)
            return vim.fn.filereadable(search.dir .. "/package.json") == 1
          end,
        },
        builder = function()
          return bg_task("npm-dev", { "npm", "run", "dev" })
        end,
      })

      overseer.register_template({
        name = "npm: run start (tmux)",
        tags = { "background", "npm" },
        condition = {
          callback = function(search)
            return vim.fn.filereadable(search.dir .. "/package.json") == 1
          end,
        },
        builder = function()
          return bg_task("npm-start", { "npm", "run", "start" })
        end,
      })

      overseer.register_template({
        name = "npm: run build:watch (tmux)",
        tags = { "background", "npm", "watch" },
        condition = {
          callback = function(search)
            return vim.fn.filereadable(search.dir .. "/package.json") == 1
          end,
        },
        builder = function()
          return bg_task("npm-watch", { "npm", "run", "build", "--", "--watch" })
        end,
      })

      -- ── vite ──────────────────────────────────────────────────────────────
      overseer.register_template({
        name = "vite: dev (tmux)",
        tags = { "background", "vite", "dev" },
        condition = {
          callback = function(search)
            return vim.fn.filereadable(search.dir .. "/vite.config.ts") == 1
              or vim.fn.filereadable(search.dir .. "/vite.config.js") == 1
          end,
        },
        builder = function()
          return bg_task("vite-dev", { "npx", "vite" })
        end,
      })

      -- ── generic background shell command ─────────────────────────────────
      -- Prompts for the command. Useful for one-off servers.
      overseer.register_template({
        name = "run in tmux window",
        tags = { "background" },
        params = {
          cmd = {
            type = "string",
            name = "Command",
            desc = "Shell command to run in a persistent tmux window",
          },
          name = {
            type = "string",
            name = "Window name",
            desc = "Name for the tmux window (optional)",
            optional = true,
            default = "bg-task",
          },
        },
        builder = function(params)
          return {
            name = params.name or "bg-task",
            cmd = { "sh", "-c", params.cmd },
            strategy = {
              "tmux_window",
              window_name = params.name or "bg-task",
              close_on_exit = false,
            },
            components = { "background" },
          }
        end,
      })

      -- ── additional keymap: <leader>ob → run a background task ─────────────
      vim.keymap.set("n", "<leader>ob", function()
        overseer.run_task({ tags = { "background" } })
      end, { desc = "Overseer: run background task (tmux)" })

      -- ── additional keymap: <leader>og → go to tmux window ─────────────────
      vim.keymap.set("n", "<leader>og", function()
        local tasks = overseer.list_tasks({ status = "RUNNING" })
        local tmux_tasks = vim.tbl_filter(function(t)
          return t.metadata and t.metadata.tmux_pane_id ~= nil
        end, tasks)

        if #tmux_tasks == 0 then
          vim.notify("No running tmux tasks", vim.log.levels.WARN)
          return
        end

        if #tmux_tasks == 1 then
          vim.fn.system({ "tmux", "select-pane", "-t", tmux_tasks[1].metadata.tmux_pane_id })
          return
        end

        -- More than one: let the user pick
        vim.ui.select(tmux_tasks, {
          prompt = "Go to tmux task:",
          format_item = function(t)
            return t.name .. " → " .. t.metadata.tmux_window_name
          end,
        }, function(task)
          if task then
            vim.fn.system({ "tmux", "select-pane", "-t", task.metadata.tmux_pane_id })
          end
        end)
      end, { desc = "Overseer: go to tmux window of running task" })
    end,
  },
}
