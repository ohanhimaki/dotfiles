local servers = {
	"html",
	"cssls",
	"pyright",
	"likec4",
	markdown_oxide = {
		-- Ensure that dynamicRegistration is enabled! This allows the LS to take into account actions like the
		-- Create Unresolved File code action, resolving completions for unindexed code blocks, ...
		capabilities = {
			textDocument = {
				completion = {
					completionItem = {
						insertReplaceSupport = true,
					},
				},
			},
		},
		on_attach = function(client, bufnr)
			vim.api.nvim_create_user_command("Daily", function(args)
				-- if args empty then "today"
				local input = args.args
				if input == "" then
					input = "today"
				end
				client:exec_cmd({ command = "jump", arguments = { input } })
			end, { desc = "Open daily note", nargs = "*" })
		end,
	},
	lua_ls = {
		settings = {
			Lua = {
				runtime = { version = "LuaJIT" },
				diagnostics = {
					globals = { "vim", "require" },
				},
				workspace = {
					checkThirdParty = false,
					library = { vim.env.VIMRUNTIME },
				},
				telemetry = {
					enable = false,
				},
			},
			root_markers = { ".git", ".hg", "nvim-pack-lock.json" },
		},
	},
	roslyn_ls = {
		filetypes = { "cs", "razor" },
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
					dotnet_analyzer_diagnostics_scope = "openFiles",
					dotnet_compiler_diagnostics_scope = "openFiles",
				},
			},
			["razor|completion"] = {
				dotnet_show_completion_items_from_unimported_namespaces = true,
			},
			["razor|inlay_hints"] = {
				dotnet_enable_inlay_hints_for_parameters = true,
				dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
				dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
			},
			["razor|formatting"] = {
				dotnet_organize_imports_on_format = true,
			},
		},
		on_attach = function(client, bufnr)
			-- Poistetaan semanttiset tokenit (treesitter hoitaa highlight)
			client.server_capabilities.semanticTokensProvider = nil --{}
			client.server_capabilities.documentHighlightProvider = false
		end,
	},
	-- TypeScript / JavaScript (React)
	ts_ls = {
		filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
		settings = {
			typescript = {
				inlayHints = {
					includeInlayParameterNameHints = "all",
					includeInlayFunctionParameterTypeHints = true,
					includeInlayVariableTypeHints = true,
					includeInlayFunctionLikeReturnTypeHints = true,
					includeInlayPropertyDeclarationTypeHints = true,
				},
			},
			javascript = {
				inlayHints = {
					includeInlayParameterNameHints = "all",
					includeInlayFunctionParameterTypeHints = true,
					includeInlayVariableTypeHints = true,
					includeInlayFunctionLikeReturnTypeHints = true,
					includeInlayPropertyDeclarationTypeHints = true,
				},
			},
		},
	},
	-- Lints JS/TS/React against your project's eslint config
	eslint = {
		on_attach = function(client, bufnr)
			vim.api.nvim_create_autocmd("BufWritePre", {
				buffer = bufnr,
				command = "EslintFixAll",
			})
		end,
	},
	jsonls = {},
	-- Tailwind CSS class completion/hover (React + css/html)
	tailwindcss = {},
}

--add all lsp packages using vim.pack.add. use mason
vim.pack.add({
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/mason-org/mason-lspconfig.nvim",
	"https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
	"https://github.com/likec4/likec4.nvim",
})
--
require("mason").setup({
	registries = {
		"github:mason-org/mason-registry",
		"github:Crashdummyy/mason-registry",
	},
})
require("mason-lspconfig").setup()
require("mason-tool-installer").setup({
	ensure_installed = {
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
		"tailwindcss-language-server",
		"rust-analyzer",
		"netcoredbg",
		-- Python tools
		"pyright",
		-- "debugpy",
		"ruff",
		"markdown-oxide",
	},
})

-- Configure LSP
---@type lsp.ClientCapabilities
local base_capabilities = vim.lsp.protocol.make_client_capabilities()

local default_on_attach = function(client, bufnr)
	local map = function(keys, func, desc, mode)
		vim.keymap.set(mode or "n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
	end

	map("<leader>lsr", function()
		vim.notify("Restarting LSP client: " .. client.name)
		vim.cmd("LspRestart " .. client.name)
	end, "Restart")
end

for server, config in pairs(servers) do
	if type(server) == "number" then
		server = config
		config = {}
	end
	-- print("Configuring LSP server: " .. server)
	if config.capabilities then
		config.capabilities = vim.tbl_deep_extend("force", base_capabilities, config.capabilities)
	else
		config.capabilities = base_capabilities
	end

	local custom_on_attach = config.on_attach

	config.on_attach = function(client, bufnr)
		default_on_attach(client, bufnr)

		if custom_on_attach then
			custom_on_attach(client, bufnr)
		end
	end

	vim.lsp.config(server, config)
	vim.lsp.enable(server)
end
