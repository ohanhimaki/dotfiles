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

      local base_opts = {}
      base_opts.ensure_installed = {
        "python",
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
          enabled = false,            -- roslyn.nvim kaytossa, koska tukee myös blazor
          roslynator_enabled = false, -- Automatically enable roslynator analyzer
          analyzer_assemblies = {},   -- Any additional roslyn analyzers you might use like SonarAnalyzer.CSharp
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
          -- if require("easy-dotnet.extensions").isWindows() == true then
          --   command = command .. "\r"
          -- end
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
            register = "+",      -- which register to check
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
        background_scanning = false, -- Disable to prevent duplicate scanning with roslyn.nvim
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
    dependencies = {
      -- mason-lspconfig:
      -- - Bridges the gap between LSP config names (e.g. "lua_ls") and actual Mason package names (e.g. "lua-language-server").
      -- - Used here only to allow specifying language servers by their LSP name (like "lua_ls") in `ensure_installed`.
      -- - It does not auto-configure servers — we use vim.lsp.config() + vim.lsp.enable() explicitly for full control.
      "mason-org/mason-lspconfig.nvim",
      -- mason-tool-installer:
      -- - Installs LSPs, linters, formatters, etc. by their Mason package name.
      -- - We use it to ensure all desired tools are present.
      -- - The `ensure_installed` list works with mason-lspconfig to resolve LSP names like "lua_ls".
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
      local M = {}
      local map = vim.keymap.set

      -- export on_attach & capabilities
      M.on_attach = function(_, bufnr)
        local function opts(desc)
          return { buffer = bufnr, desc = "LSP " .. desc }
        end

        map("n", "gD", vim.lsp.buf.declaration, opts "Go to declaration")
        map("n", "gd", vim.lsp.buf.definition, opts "Go to definition")
        map("n", "gt", vim.lsp.buf.type_definition, opts "Go to type definition")
        map("n", "gi", vim.lsp.buf.implementation, opts "Go to implementation")

        map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts "Add workspace folder")
        map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts "Remove workspace folder")

        map("n", "<leader>wl", function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts "List workspace folders")

        map("n", "<leader>D", vim.lsp.buf.type_definition, opts "Go to type definition")
        map("n", "<leader>ra", vim.lsp.buf.rename, opts "Rename")
      end

      -- disable semanticTokens
      M.on_init = function(client, _)
        if vim.fn.has "nvim-0.11" ~= 1 then
          if client:supports_method "textDocument/semanticTokens" then
            client.server_capabilities.semanticTokensProvider = nil
          end
        else
          if client:supports_method "textDocument/semanticTokens" then
            client.server_capabilities.semanticTokensProvider = nil
          end
        end
      end

      M.capabilities = vim.lsp.protocol.make_client_capabilities()

      M.capabilities.textDocument.completion.completionItem = {
        documentationFormat = { "markdown", "plaintext" },
        snippetSupport = true,
        preselectSupport = true,
        insertReplaceSupport = true,
        labelDetailsSupport = true,
        deprecatedSupport = true,
        commitCharactersSupport = true,
        tagSupport = { valueSet = { 1 } },
        resolveSupport = {
          properties = {
            "documentation",
            "detail",
            "additionalTextEdits",
          },
        },
      }

      M.defaults = function()
        dofile(vim.g.base46_cache .. "lsp")

        vim.api.nvim_create_autocmd("LspAttach", {
          callback = function(args)
            M.on_attach(_, args.buf)
          end,
        })

        local lua_lsp_settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            workspace = {
              library = {
                vim.fn.expand "$VIMRUNTIME/lua",
                vim.fn.stdpath "data" .. "/lazy/ui/nvchad_types",
                vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy",
                "${3rd}/luv/library",
              },
            },
          },
        }

        -- Use new vim.lsp.config API for Neovim 0.11+
        vim.lsp.config("*", { capabilities = M.capabilities, on_init = M.on_init })
        vim.lsp.config("lua_ls", { settings = lua_lsp_settings })
        vim.lsp.enable "lua_ls"

        local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

        vim.lsp.config("markdown_oxide",{
            -- Ensure that dynamicRegistration is enabled! This allows the LS to take into account actions like the
            -- Create Unresolved File code action, resolving completions for unindexed code blocks, ...
            capabilities = vim.tbl_deep_extend(
                'force',
                capabilities,
                {
                    workspace = {
                        didChangeWatchedFiles = {
                            dynamicRegistration = true,
                        },
                    },
                }
            ),
            on_attach = on_attach -- configure your on attach config
        })

        local servers = { "html", "cssls", "pyright", "markdown_oxide"  }
        vim.lsp.enable(servers)
        -- vim.lsp.config("roslyn", {})
      end

      -- read :h vim.lsp.config for changing options of lsp servers

      M.defaults()
    end,
  },
  {
    "mason-org/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUpdate" },
    opts = function()
      dofile(vim.g.base46_cache .. "mason")
      local base_opts = {
        PATH = "skip",

        ui = {
          icons = {
            package_pending = " ",
            package_installed = " ",
            package_uninstalled = " ",
          },
        },

        max_concurrent_installers = 10,
      }
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
        -- "debugpy",
        "ruff",
        "markdown-oxide"
      }
      return base_opts
    end,
  },
}
