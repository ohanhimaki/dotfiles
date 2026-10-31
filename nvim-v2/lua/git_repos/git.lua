local M = {}

function M.normalize(path)
  local normalized = vim.fs.normalize(path)
  return vim.fn.has("win32") == 1 and normalized:lower() or normalized
end

function M.git(directory, args, callback, options)
  local command = { "git", "-C", directory }
  vim.list_extend(command, args)

  local system_options = vim.tbl_extend("force", { text = true }, options or {})
  local ok, error_message = pcall(vim.system, command, system_options, function(result)
    vim.schedule(function()
      callback(result)
    end)
  end)

  if not ok then
    vim.schedule(function()
      callback({ code = -1, stderr = tostring(error_message) })
    end)
  end
end

function M.git_root(directory, callback)
  M.git(directory, { "rev-parse", "--show-toplevel" }, function(result)
    if result.code ~= 0 then
      return callback(nil)
    end

    local root = vim.trim(result.stdout or "")
    callback(root ~= "" and vim.fs.normalize(root) or nil)
  end)
end

function M.current_directory()
  local file = vim.api.nvim_buf_get_name(0)
  if file ~= "" and vim.bo.buftype == "" then
    return vim.fs.dirname(vim.fs.normalize(file))
  end

  return vim.fn.getcwd()
end

function M.child_directories(directory)
  local directories = {}
  local ok, error_message = pcall(function()
    for name, entry_type in vim.fs.dir(directory) do
      local path = vim.fs.joinpath(directory, name)
      local stat = entry_type == "link" and vim.uv.fs_stat(path) or nil
      if entry_type == "directory" or (stat and stat.type == "directory") then
        table.insert(directories, path)
      end
    end
  end)

  if not ok then
    vim.notify("Could not read " .. directory .. ": " .. tostring(error_message), vim.log.levels.ERROR)
    return {}
  end

  return directories
end

function M.find_child_repositories(directory, callback)
  local directories = M.child_directories(directory)
  if #directories == 0 then
    return callback({})
  end

  local repositories = {}
  local seen = {}
  local remaining = #directories
  local next_index = 0

  local function canonical(path)
    return M.normalize(vim.uv.fs_realpath(path) or vim.fn.fnamemodify(path, ":p"))
  end

  local function worker()
    next_index = next_index + 1
    local child = directories[next_index]
    if not child then
      return
    end

    M.git_root(child, function(root)
      if root and canonical(root) == canonical(child) then
        local key = canonical(root)
        if not seen[key] then
          seen[key] = true
          table.insert(repositories, root)
        end
      end

      remaining = remaining - 1
      if remaining == 0 then
        table.sort(repositories, function(left, right)
          return left:lower() < right:lower()
        end)
        callback(repositories)
      else
        worker()
      end
    end)
  end

  for _ = 1, math.min(4, #directories) do
    worker()
  end
end

return M
