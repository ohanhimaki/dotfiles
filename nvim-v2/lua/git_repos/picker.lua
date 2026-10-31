local M = {}

function M.open(state, opts)
  local picker
  local busy = false

  local function refresh()
    if picker and not picker.closed then
      picker.list:update({ force = true })
    end
  end

  state.changed = refresh
  local context = {}

  function context.refresh(repo)
    state:refresh(repo)
  end

  function context.pull(items)
    if busy then
      return
    end
    busy = true
    require("git_repos.pull").run(state, items, function()
      busy = false
      refresh()
    end)
  end

  local function execute(action, repo)
    if not repo or busy then
      return
    end
    if action.enabled then
      local enabled, reason = action.enabled(repo)
      if not enabled then
        vim.notify(reason or "Action unavailable", vim.log.levels.WARN)
        return
      end
    end
    if not action.keep_open then
      picker:close()
    end
    action.run(repo, context)
  end

  local function menu(repo)
    vim.ui.select(opts.actions, {
      prompt = repo.name .. ": action",
      format_item = function(action)
        return (action.key and action.key .. "  " or "") .. action.label
      end,
    }, function(action)
      if action then
        execute(action, repo)
      end
    end)
  end

  local input_keys, list_keys = {}, {}
  local used = { r = true, P = true, q = true, i = true, ["<CR>"] = true, ["<Esc>"] = true, ["<Tab>"] = true }

  local function bind(key, fn, label)
    input_keys[key] = { fn, mode = "n", desc = label, nowait = true }
    list_keys[key] = { fn, mode = "n", desc = label, nowait = true }
  end

  for _, action in ipairs(opts.actions) do
    if action.key then
      if used[action.key] then
        error("Duplicate or reserved repository action key: " .. action.key)
      end
      used[action.key] = true
      bind(action.key, function()
        execute(action, picker:current())
      end, action.label)
    end
  end

  -- Avoid waiting for Snacks' default gg mapping when g is an action.
  if used.g then
    input_keys.gg, list_keys.gg = false, false
  end

  bind("r", function()
    if busy then
      return
    end
    for _, item in ipairs(state.items) do
      state:fetch(item, true)
    end
  end, "Fetch all repositories")

  bind("P", function()
    local selected, items = picker:selected(), {}
    local roots = {}
    for _, item in ipairs(selected) do
      roots[item.root] = true
    end
    for _, item in ipairs(state.items) do
      if #selected == 0 or roots[item.root] then
        table.insert(items, item)
      end
    end
    context.pull(items)
  end, "Pull selected or all repositories")

  picker = Snacks.picker({
    title = "Git repositories · Enter: "
      .. (opts.action and opts.action.label or "actions")
      .. " · P: pull batch · r: fetch · ?: help",
    items = state.items,
    auto_close = false,
    layout = { preset = "select" },
    preview = "none",
    format = function(item)
      local tracking = item.upstream and ("↑" .. item.ahead .. " ↓" .. item.behind) or "no upstream"
      local activity = item.pulling and " · pulling"
        or item.fetching and " · fetching"
        or item.fetch_error and " · fetch failed"
        or ""
      return {
        { item.dirty and "● " or "✓ ", item.dirty and "DiagnosticWarn" or "DiagnosticOk" },
        { item.name, "Directory" },
        { " [" .. item.branch .. "] " .. tracking .. " · " .. item.summary .. activity },
      }
    end,
    confirm = function(_, item)
      if not item or busy then
        return
      end
      if opts.action then
        execute(opts.action, item)
      else
        menu(item)
      end
    end,
    win = { input = { keys = input_keys }, list = { keys = list_keys } },
    on_show = function(current_picker)
      vim.cmd.stopinsert()
      -- Refresh after returning from a terminal or another picker.
      local group = vim.api.nvim_create_augroup("GitRepos" .. current_picker.input.win.buf, { clear = true })
      vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "TermClose" }, {
        group = group,
        callback = function()
          if current_picker.closed then
            return
          end
          if
            vim.api.nvim_get_current_buf() == current_picker.input.win.buf
            or vim.api.nvim_get_current_buf() == current_picker.list.win.buf
          then
            for _, item in ipairs(state.items) do
              state:refresh(item)
            end
          end
        end,
      })
      vim.api.nvim_create_autocmd("BufWipeout", {
        buffer = current_picker.input.win.buf,
        once = true,
        callback = function()
          pcall(vim.api.nvim_del_augroup_by_id, group)
        end,
      })
    end,
  })

  for _, item in ipairs(state.items) do
    state:refresh(item)
    state:fetch(item)
  end

  return picker
end

return M
