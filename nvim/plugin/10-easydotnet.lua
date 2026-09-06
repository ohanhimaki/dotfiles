-- easy-dotnet.nvim pulls in a lot of its own modules on require/setup, and
-- most of its features (test runner UI, secrets, run_project) are opt-in, so
-- defer it until after the first screen renders (same pattern used for
-- mason in 10-lsp.lua). csproj/fsproj file mappings still register in time,
-- since nvim's own autocmds.lua re-fires FileType shortly after startup.
vim.schedule(function()
	vim.pack.add({
		"https://github.com/nvim-lua/plenary.nvim",
		"https://github.com/GustavEikaas/easy-dotnet.nvim",
	})

	local dotnet = require("easy-dotnet")
	-- Options are not required
	dotnet.setup({
		lsp = {
			enabled = true, -- roslyn.nvim kaytossa, koska tukee myös blazor
			roslynator_enabled = false, -- Automatically enable roslynator analyzer
			analyzer_assemblies = {}, -- Any additional roslyn analyzers you might use like SonarAnalyzer.CSharp
			razor = {
				enabled = true,
				html = {
					enabled = true,
					cmd = nil,
					request_timeout = 5000,
				},
			},
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
				passed = "",
				skipped = "",
				failed = "",
				success = "",
				reload = "",
				test = "",
				sln = "󰘐",
				project = "󰘐",
				dir = "",
				package = "",
			},
			mappings = {
				-- Buffer test execution (when in C# test file)
				run_test_from_buffer = { lhs = "<leader>tr", desc = "test: run from buffer" },
				run_all_tests_from_buffer = { lhs = "<leader>ta", desc = "test: run all from buffer" },
				peek_stack_trace_from_buffer = { lhs = "<leader>tp", desc = "test: peek stack trace" },
				debug_test = { lhs = "<leader>td", desc = "test: debug" },

				-- Test runner UI mappings (when test runner window is open)
				run = { lhs = "<leader>tr", desc = "test: run selected" },
				run_all = { lhs = "<leader>tR", desc = "test: run all" },
				peek_stacktrace = { lhs = "<leader>tp", desc = "test: peek stacktrace" },
				filter_failed_tests = { lhs = "<leader>tf", desc = "test: filter failed" },
				go_to_file = { lhs = "g", desc = "test: go to file" },
				expand = { lhs = "o", desc = "test: expand" },
				expand_node = { lhs = "E", desc = "test: expand node" },
				expand_all = { lhs = "-", desc = "test: expand all" },
				collapse_all = { lhs = "W", desc = "test: collapse all" },
				close = { lhs = "q", desc = "test: close" },
				refresh_testrunner = { lhs = "<C-r>", desc = "test: refresh" },
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
			vim.cmd("vsplit")
			vim.cmd("term " .. command)
		end,
		csproj_mappings = true,
		fsproj_mappings = true,
		auto_bootstrap_namespace = {
			--block_scoped, file_scoped
			type = "file_scoped",
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
		picker = "snacks",
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
	})

	-- Example command
	vim.api.nvim_create_user_command("Secrets", function()
		dotnet.secrets()
	end, {})

	-- Example keybinding
	vim.keymap.set("n", "<C-p>", function()
		dotnet.run_project()
	end)
end)
