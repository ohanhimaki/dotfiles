---@type vim.lsp.Config
return {
	on_attach = function() end,
	settings = {
		["csharp|code_lens"] = {
			dotnet_enable_tests_code_lens = true,
		},
		["csharp|formatting"] = {
			dotnet_organize_imports_on_format = true,
		},
		razor = {
			language_server = {
				cohosting_enabled = false,
			},
		},
	},
}
