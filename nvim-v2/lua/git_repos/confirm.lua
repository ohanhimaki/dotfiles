local M = {}

-- Keep the complete plan in a normal, scrollable buffer, not in a picker title.
function M.open(lines, count, callback)
  local buffer = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buffer, 0, -1, false, lines)
  vim.bo[buffer].modifiable = false
  vim.bo[buffer].bufhidden = "wipe"

  local width = math.max(1, math.min(100, vim.o.columns - 4))
  local height = math.max(1, math.min(#lines, vim.o.lines - 6))
  -- Native floats default to zindex 50; Snacks pickers can sit above that.
  local zindex = 50
  for _, existing in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    zindex = math.max(zindex, (vim.api.nvim_win_get_config(existing).zindex or 0) + 1)
  end

  local window = vim.api.nvim_open_win(buffer, true, {
    zindex = zindex,
    relative = "editor",
    border = "rounded",
    style = "minimal",
    width = width,
    height = height,
    row = math.max(0, math.floor((vim.o.lines - height - 2) / 2)),
    col = math.max(0, math.floor((vim.o.columns - width - 2) / 2)),
    title = " Git pull: " .. count .. " to update ",
    footer = " y: approve · q/Esc: cancel · j/k/Ctrl-d/Ctrl-u: scroll ",
  })

  vim.wo[window].wrap = true
  vim.cmd.stopinsert()
  local finished = false

  local function finish(approved)
    if finished then
      return
    end
    finished = true
    if vim.api.nvim_win_is_valid(window) then
      vim.api.nvim_win_close(window, true)
    end
    callback(approved)
  end

  for _, key in ipairs({ "q", "<Esc>", "<C-c>" }) do
    vim.keymap.set("n", key, function()
      finish(false)
    end, { buffer = buffer, nowait = true })
  end
  vim.keymap.set("n", "y", function()
    finish(true)
  end, { buffer = buffer, nowait = true })

  vim.api.nvim_create_autocmd("BufWipeout", {
    buffer = buffer,
    once = true,
    callback = function()
      if finished then
        return
      end
      finished = true
      vim.schedule(function()
        callback(false)
      end)
    end,
  })

  return { buffer = buffer, window = window }
end

return M
