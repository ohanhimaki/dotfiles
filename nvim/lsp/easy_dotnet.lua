---@type vim.lsp.Config
-- GUI launches may bypass .bashrc; enable watching only with a sufficient limit.
local nofile = vim.fn.has("linux") == 1 and tonumber(vim.fn.system({ "sh", "-c", "ulimit -n" })) or nil
local can_watch = vim.fn.has("linux") == 0 or (nofile ~= nil and nofile >= 8192)
return {
	capabilities = {
		workspace = { didChangeWatchedFiles = { dynamicRegistration = can_watch } },
	},
	settings = {
		["csharp|code_lens"] = {
			dotnet_enable_tests_code_lens = true,
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
		razor = {
			language_server = {
				cohosting_enabled = false,
			},
		},
	},
}
