return {

  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    build = ":TSUpdate | TSInstallAll",
    opts = function()
      pcall(function()
        dofile(vim.g.base46_cache .. "syntax")
        dofile(vim.g.base46_cache .. "treesitter")
      end)

      local base_opts = { }
      base_opts.ensure_installed = {
        "hyprlang",
        "vim",
        "lua",
        "luadoc",
        "printf",
        "vimdoc",
        "html",
        "css",
        "c_sharp",
        "razor",
        "javascript",
        "typescript",
        "tsx",
      }
      return base_opts
    end,
  },
  {
    "GustavEikaas/easy-dotnet.nvim",
    -- 'nvim-telescope/telescope.nvim' or 'ibhagwan/fzf-lua' or 'folke/snacks.nvim'
    -- are highly recommended for a better experience
    lazy = false,
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
    config = function()
      local dotnet = require "easy-dotnet"
      -- Options are not required
      dotnet.setup {
        lsp = {
          enabled = false, -- roslyn.nvim kaytossa, koska tukee myös blazor
          roslynator_enabled = false, -- Automatically enable roslynator analyzer
          analyzer_assemblies = {}, -- Any additional roslyn analyzers you might use like SonarAnalyzer.CSharp
          config = {},
        },
        debugger = {
          -- Path to custom coreclr DAP adapter
          -- easy-dotnet-server falls back to its own netcoredbg binary if bin_path is nil
          bin_path = nil,
          apply_value_converters = true,
          auto_register_dap = true,
          mappings = {
            open_variable_viewer = { lhs = "T", desc = "open variable viewer" },
          },
        },
        ---@type TestRunnerOptions
        test_runner = {
          ---@type "split" | "vsplit" | "float" | "buf"
          viewmode = "float",
          ---@type number|nil
          vsplit_width = nil,
          ---@type string|nil "topleft" | "topright"
          vsplit_pos = nil,
          enable_buffer_test_execution = true, --Experimental, run tests directly from buffer
          noBuild = true,
          icons = {
            passed = "",
            skipped = "",
            failed = "",
            success = "",
            reload = "",
            test = "",
            sln = "󰘐",
            project = "󰘐",
            dir = "",
            package = "",
          },
          mappings = {
            run_test_from_buffer = { lhs = "<leader>r", desc = "easydotnet: run test from buffer" },
            run_all_tests_from_buffer = { lhs = "<leader>t", desc = "easydotnet: run all tests from buffer" },
            peek_stack_trace_from_buffer = { lhs = "<leader>p", desc = "easydotnet: peek stack trace from buffer" },
            filter_failed_tests = { lhs = "<leader>fe", desc = "easydotnet: filter failed tests" },
            debug_test = { lhs = "<leader>d", desc = "easydotnet: debug test" },
            go_to_file = { lhs = "g", desc = "easydotnet: go to file" },
            run_all = { lhs = "<leader>R", desc = "easydotnet: run all tests" },
            run = { lhs = "<leader>r", desc = "easydotnet: run test" },
            peek_stacktrace = { lhs = "<leader>p", desc = "easydotnet: peek stacktrace of failed test" },
            expand = { lhs = "o", desc = "easydotnet: expand" },
            expand_node = { lhs = "E", desc = "easydotnet: expand node" },
            expand_all = { lhs = "-", desc = "easydotnet: expand all" },
            collapse_all = { lhs = "W", desc = "easydotnet: collapse all" },
            close = { lhs = "q", desc = "easydotnet: close testrunner" },
            refresh_testrunner = { lhs = "<C-r>", desc = "easydotnet: refresh testrunner" },
          },
          --- Optional table of extra args e.g "--blame crash"
          additional_args = {},
        },
        new = {
          project = {
            prefix = "sln", -- "sln" | "none"
          },
        },
        ---@param action "test" | "restore" | "build" | "run"
        terminal = function(path, action, args)
          args = args or ""
          local commands = {
            run = function()
              return string.format("dotnet run --project %s %s", path, args)
            end,
            test = function()
              return string.format("dotnet test %s %s", path, args)
            end,
            restore = function()
              return string.format("dotnet restore %s %s", path, args)
            end,
            build = function()
              return string.format("dotnet build %s %s", path, args)
            end,
            watch = function()
              return string.format("dotnet watch --project %s %s", path, args)
            end,
          }
          local command = commands[action]()
          if require("easy-dotnet.extensions").isWindows() == true then
            command = command .. "\r"
          end
          vim.cmd "vsplit"
          vim.cmd("term " .. command)
        end,
        csproj_mappings = true,
        fsproj_mappings = true,
        auto_bootstrap_namespace = {
          --block_scoped, file_scoped
          type = "block_scoped",
          enabled = true,
          use_clipboard_json = {
            behavior = "prompt", --'auto' | 'prompt' | 'never',
            register = "+", -- which register to check
          },
        },
        server = {
          ---@type nil | "Off" | "Critical" | "Error" | "Warning" | "Information" | "Verbose" | "All"
          log_level = nil,
        },
        -- choose which picker to use with the plugin
        -- possible values are "telescope" | "fzf" | "snacks" | "basic"
        -- if no picker is specified, the plugin will determine
        -- the available one automatically with this priority:
        -- telescope -> fzf -> snacks ->  basic
        picker = "telescope",
        background_scanning = true,
        notifications = {
          --Set this to false if you have configured lualine to avoid double logging
          handler = function(start_event)
            local spinner = require("easy-dotnet.ui-modules.spinner").new()
            spinner:start_spinner(start_event.job.name)
            ---@param finished_event JobEvent
            return function(finished_event)
              spinner:stop_spinner(finished_event.result.msg, finished_event.result.level)
            end
          end,
        },
        diagnostics = {
          default_severity = "error",
          setqflist = false,
        },
      }

      -- Example command
      vim.api.nvim_create_user_command("Secrets", function()
        dotnet.secrets()
      end, {})

      -- Example keybinding
      vim.keymap.set("n", "<C-p>", function()
        dotnet.run_project()
      end)
    end,
  },
  {
    "seblyng/roslyn.nvim",
    lazy = false,
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      broad_search = true,
      filewatching = "roslyn",
    },
    config = function()
      vim.lsp.config("roslyn", {
        settings = {
          ["csharp|inlay_hints"] = {
            csharp_enable_inlay_hints_for_implicit_object_creation = true,
            csharp_enable_inlay_hints_for_implicit_variable_types = true,

            csharp_enable_inlay_hints_for_lambda_parameter_types = true,
            csharp_enable_inlay_hints_for_types = true,
            dotnet_enable_inlay_hints_for_indexer_parameters = true,
            dotnet_enable_inlay_hints_for_literal_parameters = true,
            dotnet_enable_inlay_hints_for_object_creation_parameters = true,
            dotnet_enable_inlay_hints_for_other_parameters = true,
            dotnet_enable_inlay_hints_for_parameters = true,
            dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
            dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
            dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
          },
          ["csharp|code_lens"] = {
            dotnet_enable_references_code_lens = true,
          },
          ["csharp|completion"] = {
            dotnet_provide_regex_completions = true,
            dotnet_show_name_completion_suggestions = true,
            dotnet_show_completion_items_from_unimported_namespaces = true,
          },
          ["csharp|formatting"] = {
            dotnet_organize_imports_on_format = true,
          },
          ["csharp|background_analysis"] = {
            background_analysis = {
              dotnet_analyzer_diagnostics_scope = "fullSolution",
              dotnet_compiler_diagnostics_scope = "fullSolution",
            },
          },
        },
      })
      vim.lsp.enable "roslyn"
    end,
  },
  {
    "neovim/nvim-lspconfig",
    event = "User FilePost",
    config = function()
      require("configs.lspconfig").defaults()
    end,
  },
  {
    "mason-org/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUpdate" },
    opts = function()
      local base_opts = require "configs.mason"
      base_opts.registries = {
        "github:mason-org/mason-registry",
        "github:Crashdummyy/mason-registry",
      }
      base_opts.ensure_installed = {
        "lua-language-server",
        "xmlformatter",
        "csharpier",
        "prettier",
        "stylua",
        "bicep-lsp",
        "html-lsp",
        "css-lsp",
        "eslint-lsp",
        "typescript-language-server",
        "json-lsp",
        "rust-analyzer",
        "roslyn",
        "netcoredbg",
        -- Python tools
        "pyright",
        "debugpy",
        "ruff",
      }
      return base_opts
    end,
  },
}
