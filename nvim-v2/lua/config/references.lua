local M = {}

local function normalize(path)
  return path:gsub("\\", "/")
end

local function relative_path(path)
  local root = vim.fs.root(path, ".git") or vim.fn.getcwd()
  return normalize(vim.fs.relpath(root, path) or path)
end

---@param opts? { visual?: boolean, prompt?: boolean }
function M.copy(opts)
  opts = opts or {}

  local path = vim.api.nvim_buf_get_name(0)
  if path == "" then
    vim.notify("Current buffer has no file path", vim.log.levels.WARN)
    return
  end

  local reference = relative_path(path)
  if opts.visual then
    local first = vim.fn.line("v")
    local last = vim.fn.line(".")
    if first > last then
      first, last = last, first
    end
    reference = ("%s:%d:%d"):format(reference, first, last)
  end

  if opts.prompt then
    local note = vim.fn.input("Prompt (optional): ")
    if note ~= "" then
      reference = reference .. " " .. note
    end
  end

  vim.fn.setreg("+", reference)
  vim.notify("Copied: " .. reference)
end

function M.setup()
  vim.keymap.set("n", "<leader>yp", function()
    local path = vim.api.nvim_buf_get_name(0)
    if path ~= "" then
      vim.fn.setreg("+", normalize(path))
      vim.notify("Copied: " .. normalize(path))
    end
  end, { desc = "Copy absolute file path" })

  vim.keymap.set("n", "<leader>yf", function()
    local name = vim.fn.expand("%:t")
    if name ~= "" then
      vim.fn.setreg("+", name)
      vim.notify("Copied: " .. name)
    end
  end, { desc = "Copy file name" })

  vim.keymap.set("n", "<leader>yr", function()
    M.copy({ prompt = true })
  end, { desc = "Copy file reference" })

  vim.keymap.set("x", "<leader>yr", function()
    M.copy({ visual = true, prompt = true })
  end, { desc = "Copy file reference with line range" })
end

return M
