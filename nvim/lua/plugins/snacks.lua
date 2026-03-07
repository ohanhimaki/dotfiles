return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true },
      dashboard = {
        enabled = true,
        sections = {
          { section = "header" },
          {
            section = "keys",
            gap = 1,
            padding = 1,
          },
          {
            section = "recent_files",
            title = "Recent Files",
            limit = 8,
            padding = 1,
          },
          { section = "startup" },
        },
        preset = {
          keys = {
            { icon = " ", key = "e", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "o", desc = "Oil", action = ":Oil" },
            {
              icon = " ",
              key = "f",
              desc = "Find Files",
              action = function()
                Snacks.picker.git_files()
              end,
            },
            {
              icon = " ",
              key = "r",
              desc = "Recent Files",
              action = function()
                Snacks.picker.recent()
              end,
            },
            {
              icon = " ",
              key = "g",
              desc = "Grep",
              action = function()
                Snacks.picker.grep()
              end,
            },
            { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
      },
      explorer = { enabled = true },
      indent = { enabled = true },
      input = { enabled = true },
      lazygit = { enabled = true },
      picker = {
        enabled = true,
        layout = { preset = "ivy" },
        sources = {
          buffers = {
            layout = { preset = "vscode" },
          },
        },
      },
      notifier = { enabled = true },
      quickfile = { enabled = true },
      terminal = {
        enabled = true,
        win = {
          style = "terminal",
          border = "rounded",
          keys = {
            term_hide = { "<esc><esc>", "<C-\\><C-n>", mode = "t", desc = "Exit terminal mode" },
          },
        },
      },
      scope = { enabled = true },
      --scroll = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
    },
    keys = {
      -- Picker (replaces telescope)
      {
        "<leader>fk",
        function()
          Snacks.picker.keymaps()
        end,
        desc = "Keymaps",
      },
      {
        "<leader>fb",
        function()
          Snacks.picker.buffers()
        end,
        desc = "Buffers",
      },
      {
        "<leader>fh",
        function()
          Snacks.picker.help()
        end,
        desc = "Help",
      },
      {
        "<leader>fgg",
        function()
          Snacks.picker.git_status()
        end,
        desc = "Git status",
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
        "<leader>fo",
        function()
          Snacks.picker.recent()
        end,
        desc = "Recent files",
      },
      {
        "<leader>fz",
        function()
          Snacks.picker.lines()
        end,
        desc = "Lines in buffer",
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
        "<leader>fa",
        function()
          vim.cmd "Seeker files"
        end,
        desc = "Files (seeker)",
      },
      {
        "<leader>ff",
        function()
          vim.cmd "Seeker git_files"
        end,
        desc = "Git files (seeker)",
      },
      {
        "<leader>fw",
        function()
          vim.cmd "Seeker grep"
        end,
        desc = "Grep (seeker)",
      },
      {
        "<leader>fp",
        function()
          Snacks.picker.recent { filter = { cwd = true } }
        end,
        desc = "Recent files (cwd)",
      },
      {
        "<leader>fc",
        function()
          Snacks.picker.files { cwd = vim.fn.stdpath "config" }
        end,
        desc = "Nvim config files",
      },
      {
        "<leader>fl",
        function()
          Snacks.picker.files { cwd = vim.fn.stdpath "data" .. "/lazy" }
        end,
        desc = "Lazy plugin files",
      },
      -- Lazygit (replaces lazygit.nvim)
      {
        "<leader>gg",
        function()
          Snacks.lazygit()
        end,
        desc = "LazyGit",
      },
      {
        "<leader>gc",
        function()
          Snacks.lazygit.log_file()
        end,
        desc = "LazyGit current file",
      },
      -- Explorer (replaces nvim-tree <C-n>)
      {
        "<C-n>",
        function()
          Snacks.explorer()
        end,
        desc = "Explorer",
      },
      -- Terminal (replaces toggleterm, <C-g>)
      {
        "<C-g>",
        function()
          local shell = vim.fn.has "win32" == 1 and "pwsh.exe" or vim.o.shell
          Snacks.terminal.toggle(shell)
        end,
        mode = { "n", "t" },
        desc = "Toggle terminal float",
      },
    },
  },
}
