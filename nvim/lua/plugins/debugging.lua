return {
  {
    -- Debug Framework
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "mfussenegger/nvim-dap-python",
    },
    config = function()
      local dap = require "dap"

      local mason_path = vim.fn.stdpath "data" .. "/mason/packages/netcoredbg/netcoredbg/netcoredbg"

      local netcoredbg_adapter = {
        type = "executable",
        command = mason_path,
        args = { "--interpreter=vscode" },
      }

      dap.adapters.netcoredbg = netcoredbg_adapter -- needed for normal debugging
      dap.adapters.coreclr = netcoredbg_adapter -- needed for unit test debugging
      require("dap-python").setup "~/.virtualenvs/debugpy/Scripts/python"
      dap.configurations.cs = {
        {
          type = "coreclr",
          name = "launch - netcoredbg",
          request = "launch",
          program = function()
            -- return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/src/", "file")
            return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/bin/Debug/net9.0/", "file")
          end,

          -- justMyCode = false,
          -- stopAtEntry = false,
          -- -- program = function()
          -- --   -- todo: request input from ui
          -- --   return "/path/to/your.dll"
          -- -- end,
          -- env = {
          --   ASPNETCORE_ENVIRONMENT = function()
          --     -- todo: request input from ui
          --     return "Development"
          --   end,
          --   ASPNETCORE_URLS = function()
          --     -- todo: request input from ui
          --     return "http://localhost:5050"
          --   end,
          -- },
          -- cwd = function()
          --   -- todo: request input from ui
          --   return vim.fn.getcwd()
          -- end,
        },
      }

      local map = vim.keymap.set

      map("n", "<F10>", "<cmd>lua require('dap').step_over()<CR>", { desc = "Debug Step Over" })
      map("n", "<F11>", "<cmd>lua require('dap').step_into()<CR>", { desc = "Debug Step Into" })
      map("n", "<F5>", "<cmd>lua require('dap').continue()<CR>", { desc = "Debug Continue/Start" })
      map("n", "<F6>", "<Cmd>lua require('neotest').run.run({strategy = 'dap'})<CR>", { desc = "Debug neotest dap" })
      map("n", "<F8>", "<Cmd>lua require'dap'.step_out()<CR>", { desc = "Debug Step Out" })
      map("n", "<F9>", "<cmd>lua require('dap').toggle_breakpoint()<CR>", { desc = "Toggle Breakpoint" })
      map("n", "<S-F11>", "<cmd>lua require('dap').step_out()<CR>", { desc = "Debug Step Out" })
      map("n", "<S-F5>", "<cmd>lua require('dap').terminate()<CR>", { desc = "Debug Stop" })
      -- map("n", "<F12>", "<Cmd>lua require'dap'.step_out()<CR>", opts)
      map("n", "<leader>dr", "<Cmd>lua require'dap'.repl.open()<CR>", { desc = "Debug repl open" })
      map("n", "<leader>dl", "<Cmd>lua require'dap'.run_last()<CR>", { desc = "Debug show last run" })
      map(
        "n",
        "<leader>dt",
        "<Cmd>lua require('neotest').run.run({strategy = 'dap'})<CR>",
        { noremap = true, silent = true, desc = "debug nearest test" }
      )

      -- Evaluoi muuttuja ja vie uuteen bufferiin
      map("n", "<leader>dv", function()
        local var = vim.fn.input "Variable name: "
        if var == "" then
          return
        end

        local success, result = pcall(function()
          return require("dap").session():evaluate(var)
        end)

        if success and result then
          -- Luo uusi vertical split ja kirjoita arvo sinne
          vim.cmd "vnew"
          local lines = vim.split(vim.inspect(result), "\n")
          vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
          vim.bo.buftype = "nofile"
          vim.bo.bufhidden = "wipe"
          vim.bo.filetype = "lua"
          vim.bo.swapfile = false
          print("Exported variable: " .. var)
        else
          print("Could not evaluate: " .. var)
        end
      end, { noremap = true, silent = true, desc = "Debug Evaluate and export to buffer" })

      -- Evaluoi muuttuja ja kopioi leikepöydälle
      map("n", "<leader>dy", function()
        local var = vim.fn.input "Variable name: "
        if var == "" then
          return
        end

        local success, result = pcall(function()
          return require("dap").session():evaluate(var)
        end)

        if success and result then
          local value_str = vim.inspect(result)
          vim.fn.setreg("+", value_str)
          print("Copied to clipboard: " .. var)
        else
          print("Could not evaluate: " .. var)
        end
      end, { noremap = true, silent = true, desc = "Evaluate and copy to clipboard" })
    end,
    event = "VeryLazy",
  },
  {
    "jayp0521/mason-nvim-dap.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "mfussenegger/nvim-dap",
    },
    config = function()
      require("mason-nvim-dap").setup {
        ensure_installed = { "netcoredbg" },
        automatic_installation = { exclude = { "python" } },
        handlers = {},
      }
    end,
    event = "VeryLazy",
  },
  { "nvim-neotest/nvim-nio" },
  {
    -- UI for debugging
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    config = function()
      local dapui = require "dapui"
      local dap = require "dap"

      --- open ui immediately when debugging starts
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- default configuration
      dapui.setup()
    end,
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "Issafalcon/neotest-dotnet",
    },
    config = function()
      require("neotest").setup {
        adapters = {
          require "neotest-dotnet",
        },
      }
    end,
  },
  {
    "Vigemus/iron.nvim",
    event = "VeryLazy",
    config = function()
      require("iron.core").setup {
        config = {
          scratch_repl = true,
          repl_definition = {
            python = {
              command = { "python", "-i" },
            },
            cs = {
              command = { "dotnet", "fsi" },
            },
          },
          repl_open_cmd = require("iron.view").split.vertical.botright(0.4),
        },
        keymaps = {

          toggle_repl = "<space>rr", -- toggles the repl open and closed.
          visual_send = "<space>sc",
          exit = "<space>sq",
          clear = "<space>cl",
        },
      }
    end,
  },
}
