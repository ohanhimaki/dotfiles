local function find_project()
  local filename = vim.api.nvim_buf_get_name(0)
  local start = filename ~= "" and vim.fs.dirname(filename) or vim.fn.getcwd()
  return vim.fs.find(function(name)
    return name:match("%.csproj$") ~= nil
  end, { path = start, upward = true, type = "file" })[1]
end

local function newest_project_dll()
  local project = find_project()
  if not project then
    return nil
  end

  local project_dir = vim.fs.dirname(project)
  local project_name = vim.fs.basename(project):gsub("%.csproj$", "")
  local pattern = vim.fs.joinpath(project_dir, "bin", "Debug", "**", project_name .. ".dll")
  local candidates = vim.fn.glob(pattern, false, true)

  candidates = vim.tbl_filter(function(path)
    local normalized = vim.fs.normalize(path):gsub("\\", "/")
    return not normalized:match("/ref/") and not normalized:match("/publish/")
  end, candidates)

  table.sort(candidates, function(left, right)
    local left_stat = vim.uv.fs_stat(left)
    local right_stat = vim.uv.fs_stat(right)
    local left_time = left_stat and left_stat.mtime.sec or 0
    local right_time = right_stat and right_stat.mtime.sec or 0
    return left_time > right_time
  end)

  return candidates[1]
end

local function project_directory()
  local project = find_project()
  return project and vim.fs.dirname(project) or vim.fn.getcwd()
end

local function netcoredbg_command()
  local command = vim.fn.exepath("netcoredbg")
  if vim.fn.has("win32") == 1 then
    local mason_executable =
      vim.fs.joinpath(vim.fn.stdpath("data"), "mason", "packages", "netcoredbg", "netcoredbg", "netcoredbg.exe")
    if vim.fn.executable(mason_executable) == 1 then
      return mason_executable
    end
  end
  return command ~= "" and command or "netcoredbg"
end

return {
  {
    "mfussenegger/nvim-dap",
    lazy = false,
    config = function()
      local dap = require("dap")

      dap.adapters.coreclr = {
        type = "executable",
        command = netcoredbg_command(),
        args = { "--interpreter=vscode" },
      }

      dap.configurations.cs = {
        {
          type = "coreclr",
          name = "Launch .NET DLL",
          request = "launch",
          cwd = project_directory,
          program = function()
            local default = newest_project_dll()
              or vim.fs.joinpath(project_directory(), "bin", "Debug") .. package.config:sub(1, 1)
            return vim.fn.input("Path to DLL: ", default, "file")
          end,
        },
        {
          type = "coreclr",
          name = "Attach to .NET process",
          request = "attach",
          processId = require("dap.utils").pick_process,
        },
      }

      local map = vim.keymap.set
      map("n", "<F5>", dap.continue, { desc = "Debug: start or continue" })
      map("n", "<F8>", dap.step_out, { desc = "Debug: step out" })
      map("n", "<F9>", dap.toggle_breakpoint, { desc = "Debug: toggle breakpoint" })
      map("n", "<F10>", dap.step_over, { desc = "Debug: step over" })
      map("n", "<F11>", dap.step_into, { desc = "Debug: step into" })
      map("n", "<S-F11>", dap.step_out, { desc = "Debug: step out" })
      map("n", "<S-F5>", dap.terminate, { desc = "Debug: stop" })
      map("n", "<leader>dr", dap.repl.toggle, { desc = "Debug: toggle REPL" })
      map("n", "<leader>dl", dap.run_last, { desc = "Debug: run last" })
      map("n", "<leader>db", function()
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end, { desc = "Debug: conditional breakpoint" })
    end,
  },
  {
    "igorlfs/nvim-dap-view",
    version = "1.*",
    lazy = false,
    dependencies = { "mfussenegger/nvim-dap" },
    opts = {
      auto_toggle = true,
      switchbuf = "usevisible,usetab,newtab",
      virtual_text = {
        enabled = true,
      },
    },
    keys = {
      { "<leader>du", "<cmd>DapViewToggle<cr>", desc = "Debug: toggle view" },
    },
  },
}
