local function stop_insert()
  vim.cmd.stopinsert()
end

local git_repos = require("git_repos")
local repo_actions = require("config.repo_actions")

local function dashboard_file(item, ctx)
  local cwd = vim.fn.getcwd()
  local absolute = vim.fn.fnamemodify(item.file, ":p")
  local cwd_normalized = cwd:lower():gsub("\\", "/"):gsub("/?$", "/")
  local absolute_normalized = absolute:lower():gsub("\\", "/")
  local in_cwd = vim.startswith(absolute_normalized, cwd_normalized)
  local filename = in_cwd and absolute:sub(#cwd + 2):gsub("\\", "/") or vim.fn.fnamemodify(absolute, ":~")

  if ctx.width and #filename > ctx.width then
    filename = vim.fn.pathshorten(filename)
  end

  local directory, file = filename:match("^(.*)/(.+)$")
  if in_cwd then
    return directory and { { directory .. "/", hl = "SnacksDashboardDir" }, { file, hl = "SnacksDashboardSpecial" } }
      or { { filename, hl = "SnacksDashboardSpecial" } }
  end

  return directory and { { directory .. "/", hl = "SnacksDashboardDir" }, { file, hl = "SnacksDashboardKey" } }
    or { { filename, hl = "SnacksDashboardKey" } }
end

return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "moon",
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd.colorscheme("tokyonight")
    end,
  },
  {
    "folke/snacks.nvim",
    lazy = false,
    priority = 900,
    opts = {
      bigfile = { enabled = true },
      dashboard = {
        enabled = true,
        formats = {
          file = dashboard_file,
        },
        sections = {
          { section = "header" },
          { section = "keys", gap = 0, padding = 1 },
          {
            section = "recent_files",
            title = "Recent Files - cwd",
            limit = 5,
            padding = 1,
            cwd = true,
          },
          {
            section = "recent_files",
            title = "Recent Files - all",
            limit = 5,
            padding = 1,
          },
          { section = "startup" },
        },
        preset = {
          header = [[
          _              _                     _
__      _( )_ __   _ __ | |_   _ __  _ __ ___ | |__  _ __ ___
\ \ /\ / //| '__| | '_ \| __| | '_ \| '_ ` _ \| '_ \| '__/ __|
 \ V  V /  | |    | | | | |_  | | | | | | | | | |_) | |  \__ \
  \_/\_/   |_|    |_| |_|\__| |_| |_|_| |_| |_|_.__/|_|  |___/
]],
          keys = {
            { icon = " ", key = "e", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
      },
      explorer = { enabled = true },
      lazygit = { enabled = true },
      notifier = { enabled = true },
      picker = {
        enabled = true,
        sources = {
          buffers = {
            layout = { preset = "vscode" },
          },
        },
      },
      quickfile = { enabled = true },
      terminal = { enabled = true },
    },
    keys = {
      {
        "<leader>,",
        function()
          Snacks.picker.buffers({ on_show = stop_insert })
        end,
        desc = "Buffers",
      },
      {
        "<leader>fb",
        function()
          Snacks.picker.buffers({ on_show = stop_insert })
        end,
        desc = "Buffers",
      },
      {
        "<leader>fa",
        function()
          Snacks.picker.files()
        end,
        desc = "Files",
      },
      {
        "<leader>fA",
        function()
          Snacks.picker.files({ ignored = true })
        end,
        desc = "Files (ignored)",
      },
      {
        "<leader>ff",
        function()
          Snacks.picker.git_files()
        end,
        desc = "Git files",
      },
      {
        "<leader>f?",
        function()
          Snacks.picker.pick()
        end,
        desc = "All pickers",
      },
      {
        "<leader>fw",
        function()
          Snacks.picker.grep()
        end,
        desc = "Grep",
      },
      {
        "<leader>fw",
        function()
          Snacks.picker.grep_word()
        end,
        mode = "x",
        desc = "Grep selection",
      },
      {
        "<leader>fh",
        function()
          Snacks.picker.help()
        end,
        desc = "Help",
      },
      {
        "<leader>fk",
        function()
          Snacks.picker.keymaps()
        end,
        desc = "Keymaps",
      },
      {
        "<leader>fd",
        function()
          Snacks.picker.diagnostics()
        end,
        desc = "Diagnostics",
      },
      {
        "<leader>fo",
        function()
          Snacks.picker.recent()
        end,
        desc = "Recent files",
      },
      {
        "<leader>fp",
        function()
          Snacks.picker.recent({ filter = { cwd = true }, on_show = stop_insert })
        end,
        desc = "Recent files (cwd)",
      },
      {
        "<leader>fc",
        function()
          Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
        end,
        desc = "Config files",
      },
      {
        "<leader>fl",
        function()
          Snacks.picker.files({ cwd = vim.fn.stdpath("data") .. "/lazy" })
        end,
        desc = "Lazy plugin files",
      },
      {
        "<leader>fn",
        function()
          Snacks.picker.notifications({ on_show = stop_insert })
        end,
        desc = "Notifications",
      },
      {
        "<leader>fz",
        function()
          Snacks.picker.lines()
        end,
        desc = "Buffer lines",
      },
      {
        "<leader>fgo",
        function()
          Snacks.picker.grep({ cwd = vim.fn.expand("~/ohanhimaki") })
        end,
        desc = "Grep (~/ohanhimaki)",
      },
      {
        "<leader>fgr",
        function()
          Snacks.picker.git_log_file()
        end,
        desc = "Git log file",
      },
      {
        "<leader>ma",
        function()
          Snacks.picker.marks()
        end,
        desc = "Marks",
      },
      {
        "<leader>cm",
        function()
          Snacks.picker.git_log()
        end,
        desc = "Git commits",
      },
      {
        "<leader>gt",
        function()
          Snacks.picker.git_status()
        end,
        desc = "Git status",
      },
      {
        "<leader>fgg",
        function()
          git_repos.open({ actions = repo_actions.defaults, action = repo_actions.changes })
        end,
        desc = "Git status",
      },
      {
        "<leader>fgG",
        function()
          git_repos.open({
            actions = repo_actions.defaults,
            action = repo_actions.changes,
            force_root = true,
            force_picker = true,
          })
        end,
        desc = "Git status (choose repository)",
      },
      {
        "<leader>e",
        function()
          Snacks.picker.explorer()
        end,
        desc = "Explorer",
      },
      {
        "<leader>gg",
        function()
          git_repos.open({ actions = repo_actions.defaults, action = repo_actions.lazygit })
        end,
        desc = "LazyGit",
      },
      {
        "<leader>gG",
        function()
          git_repos.open({
            actions = repo_actions.defaults,
            action = repo_actions.lazygit,
            force_root = true,
            force_picker = true,
          })
        end,
        desc = "LazyGit (choose repository)",
      },
      {
        "<leader>gr",
        function()
          git_repos.open({
            actions = repo_actions.defaults,
            force_root = true,
            force_picker = true,
          })
        end,
        desc = "Git repositories",
      },
      {
        "<leader>gc",
        function()
          Snacks.lazygit.log_file()
        end,
        desc = "LazyGit current file",
      },
      {
        "<C-g>",
        function()
          Snacks.terminal()
        end,
        mode = { "n", "t" },
        desc = "Terminal",
      },
      {
        "<leader>bd",
        function()
          Snacks.bufdelete()
        end,
        desc = "Delete buffer",
      },
      {
        "<leader>bo",
        function()
          Snacks.bufdelete.other()
        end,
        desc = "Delete other buffers",
      },
    },
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "helix",
      sort = { "local", "order", "group", "desc", "alphanum", "mod" },
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer keymaps",
      },
    },
  },
}
