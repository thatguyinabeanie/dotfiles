---
--- Overseer strategy: Run tasks in a persistent tmux window
---
--- The process runs in a dedicated tmux window that **survives Neovim exit**.
--- If you accidentally quit with :qa, your dev server keeps running.
---
--- Usage:
---   overseer.new_task({
---     name  = "npm dev",
---     cmd   = { "npm", "run", "dev" },
---     strategy = {
---       "tmux_window",
---       window_name   = "dev-server",  -- optional: name the tmux window
---       close_on_exit = false,          -- keep window open so you can see output
---     },
---   })
---
--- How it works:
---   1. Writes a small wrapper shell script to a temp file
---   2. Opens a new tmux window running that script
---   3. Polls (every second) for an exit-code file written by the wrapper
---   4. Reports exit code back to Overseer; does NOT kill the pane on VimLeave
---
--- Requirements: must be running inside a tmux session ($TMUX must be set).
---
--- @class overseer.TmuxWindowStrategy : overseer.Strategy
--- @field opts          overseer.TmuxWindowStrategyOpts
--- @field pane_id       string|nil   tmux pane ID (e.g. %42)
--- @field window_name   string|nil   tmux window name used
--- @field bufnr         integer|nil  info buffer shown by Overseer task list
--- @field _exit_file    string|nil   temp file the wrapper writes exit code to
--- @field _script_file  string|nil   temp shell script executed in the window
--- @field _timer        uv_timer_t|nil  libuv timer for polling
local TmuxWindowStrategy = {}

--- @class overseer.TmuxWindowStrategyOpts
--- @field window_name   string|nil   Custom tmux window name (default: "ov:<task-name>")
--- @field close_on_exit boolean|nil  Close window when task exits (default: false)
--- @field focus         boolean|nil  Switch tmux focus to the new window (default: false)

--- @param opts nil|overseer.TmuxWindowStrategyOpts
--- @return overseer.Strategy
function TmuxWindowStrategy.new(opts)
  opts = vim.tbl_extend("keep", opts or {}, {
    close_on_exit = false,
    focus = false,
  })
  return setmetatable({
    opts = opts,
    pane_id = nil,
    window_name = nil,
    bufnr = nil,
    _exit_file = nil,
    _script_file = nil,
    _timer = nil,
  }, { __index = TmuxWindowStrategy })
end

-- ─── helpers ──────────────────────────────────────────────────────────────────

local function safe_timer_stop(timer)
  if timer then
    timer:stop()
    pcall(function()
      timer:close()
    end)
  end
end

local function safe_buf_delete(bufnr)
  if bufnr and vim.api.nvim_buf_is_valid(bufnr) then
    pcall(vim.api.nvim_buf_delete, bufnr, { force = true })
  end
end

-- ─── strategy interface ───────────────────────────────────────────────────────

--- Called by Overseer when restarting a task (reset → start).
--- Kills the running pane and cleans up temp files.
function TmuxWindowStrategy:reset()
  safe_timer_stop(self._timer)
  self._timer = nil

  if self.pane_id then
    vim.fn.system({ "tmux", "kill-pane", "-t", self.pane_id })
    self.pane_id = nil
  end

  for _, field in ipairs({ "_exit_file", "_script_file" }) do
    if self[field] then
      vim.fn.delete(self[field])
      self[field] = nil
    end
  end

  safe_buf_delete(self.bufnr)
  self.bufnr = nil
end

--- Returns an info buffer shown in the Overseer task list.
--- The buffer explains where to find the output (tmux window) and
--- how to navigate there.
function TmuxWindowStrategy:get_bufnr()
  if not self.bufnr or not vim.api.nvim_buf_is_valid(self.bufnr) then
    self.bufnr = vim.api.nvim_create_buf(false, true)
    vim.bo[self.bufnr].buftype = "nofile"
    vim.bo[self.bufnr].filetype = "overseer_tmux_info"
    vim.bo[self.bufnr].modifiable = false
    self:_refresh_buffer()
  end
  return self.bufnr
end

function TmuxWindowStrategy:_refresh_buffer()
  if not self.bufnr or not vim.api.nvim_buf_is_valid(self.bufnr) then
    return
  end

  local lines
  if self.pane_id then
    lines = {
      "",
      "  🖥️  Task is running in a tmux window",
      "",
      "  Window : " .. (self.window_name or "?"),
      "  Pane   : " .. self.pane_id,
      "",
      "  To navigate there:",
      "    • Overseer action  → <CR> on this task → 'Go to tmux window'",
      "    • tmux command     → :!tmux select-pane -t " .. self.pane_id,
      "    • Shell            → tmux select-window -t '" .. (self.window_name or "?") .. "'",
      "",
      "  The process will keep running even if you quit Neovim.",
    }
  else
    lines = {
      "",
      "  ✅  Task has exited",
      "",
      "  Window : " .. (self.window_name or "?"),
      "",
      "  The tmux window may still be open with the output intact.",
      "  (close it with: tmux kill-window -t '" .. (self.window_name or "?") .. "')",
    }
  end

  vim.bo[self.bufnr].modifiable = true
  vim.api.nvim_buf_set_lines(self.bufnr, 0, -1, false, lines)
  vim.bo[self.bufnr].modifiable = false
  vim.bo[self.bufnr].modified = false
end

--- Start the task.
--- @param task overseer.Task
function TmuxWindowStrategy:start(task)
  -- ── sanity check ──────────────────────────────────────────────────────────
  if not os.getenv("TMUX") then
    vim.notify(
      "[overseer] tmux_window: not inside a tmux session – cannot create window.\n"
        .. "Start Neovim from within tmux, or use a different strategy.",
      vim.log.levels.ERROR
    )
    task:on_exit(1)
    return
  end

  -- ── window name ───────────────────────────────────────────────────────────
  self.window_name = self.opts.window_name
    or ("ov:" .. task.name:gsub("[^%w%-_]", "-"):sub(1, 25))

  -- ── temp files ────────────────────────────────────────────────────────────
  self._exit_file = vim.fn.tempname()
  self._script_file = vim.fn.tempname() .. ".sh"

  -- ── build wrapper script ─────────────────────────────────────────────────
  local script_lines = { "#!/bin/sh" }

  if task.cwd then
    table.insert(script_lines, "cd " .. vim.fn.shellescape(task.cwd))
  end

  if task.env then
    for k, v in pairs(task.env) do
      table.insert(script_lines, string.format("export %s=%s", k, vim.fn.shellescape(tostring(v))))
    end
  end

  -- Build the command string (safe shell quoting)
  local cmd_parts = type(task.cmd) == "table" and task.cmd or { "sh", "-c", task.cmd }
  local cmd_str = table.concat(
    vim.tbl_map(function(s)
      return vim.fn.shellescape(tostring(s))
    end, cmd_parts),
    " "
  )

  table.insert(script_lines, cmd_str)
  -- Capture exit code and write to file
  table.insert(script_lines, "__ec=$?")
  table.insert(script_lines, "printf '%d' $__ec > " .. vim.fn.shellescape(self._exit_file))

  if not self.opts.close_on_exit then
    -- Keep window open with a pause so the user can read output
    table.insert(script_lines, 'printf "\\n\\n[Process exited %d — press Enter to close]\\n" $__ec')
    table.insert(script_lines, "read -r _")
  end

  vim.fn.writefile(script_lines, self._script_file)
  vim.fn.setfperm(self._script_file, "rwxr-xr-x")

  -- ── launch tmux window ────────────────────────────────────────────────────
  local tmux_args = { "tmux", "new-window", "-P", "-F", "#{pane_id}" }
  if not self.opts.focus then
    table.insert(tmux_args, "-d") -- don't steal focus
  end
  table.insert(tmux_args, "-n")
  table.insert(tmux_args, self.window_name)
  table.insert(tmux_args, self._script_file)

  local result = vim.fn.system(tmux_args)
  if vim.v.shell_error ~= 0 then
    vim.notify(
      string.format("[overseer] tmux_window: failed to open window:\n%s", result),
      vim.log.levels.ERROR
    )
    task:on_exit(1)
    return
  end

  self.pane_id = vim.trim(result)
  -- Store pane info in task metadata so actions can access it
  task.metadata.tmux_pane_id = self.pane_id
  task.metadata.tmux_window_name = self.window_name

  self:_refresh_buffer()

  vim.notify(
    string.format(
      "[overseer] '%s' → tmux window '%s' (pane %s)",
      task.name,
      self.window_name,
      self.pane_id
    ),
    vim.log.levels.INFO
  )

  -- ── poll for exit ─────────────────────────────────────────────────────────
  -- We capture the files by value so stale closures from reset() are harmless
  local exit_file = self._exit_file
  local pane_id = self.pane_id

  self._timer = vim.uv.new_timer()
  self._timer:start(
    500, -- initial delay ms
    1000, -- repeat interval ms
    vim.schedule_wrap(function()
      -- Don't run callbacks while Neovim is shutting down
      if vim.v.exiting ~= vim.NIL then
        return
      end

      -- Guard: this timer may have been superseded by reset()
      if self.pane_id ~= pane_id then
        return
      end

      -- Check whether the wrapper wrote the exit code yet
      if vim.fn.filereadable(exit_file) ~= 1 then
        return
      end

      -- Read exit code
      local lines = vim.fn.readfile(exit_file)
      local exit_code = tonumber(lines[1] or "1") or 1
      vim.fn.delete(exit_file)

      -- Tear down timer
      safe_timer_stop(self._timer)
      self._timer = nil

      -- Clear pane tracking (process is done)
      self.pane_id = nil
      if self._exit_file == exit_file then
        self._exit_file = nil
      end

      self:_refresh_buffer()
      task:on_exit(exit_code)
    end)
  )
end

--- Stop and kill the task (explicit user action from Overseer).
--- Does NOT fire on Neovim quit — that's intentional (process survives).
function TmuxWindowStrategy:stop()
  safe_timer_stop(self._timer)
  self._timer = nil

  if self.pane_id then
    vim.fn.system({ "tmux", "kill-pane", "-t", self.pane_id })
    self.pane_id = nil
  end

  for _, field in ipairs({ "_exit_file", "_script_file" }) do
    if self[field] then
      vim.fn.delete(self[field])
      self[field] = nil
    end
  end

  self:_refresh_buffer()
end

--- Full cleanup (called by Overseer when the task is disposed).
function TmuxWindowStrategy:dispose()
  self:stop()
  safe_buf_delete(self.bufnr)
  self.bufnr = nil
end

return TmuxWindowStrategy
