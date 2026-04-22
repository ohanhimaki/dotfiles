vim.pack.add({ {
	src = "https://github.com/stevearc/conform.nvim",
} })

vim.api.nvim_create_autocmd("BufWritePre", {
	once = true,
	callback = function(args)
		local status, conform = pcall(require, "conform")
		if status then
			conform.setup({
				formatters_by_ft = {
					lua = { "stylua" },
				},
				format_on_save = {
					timeout_ms = 500,
					lsp_format = "fallback",
				},
			})

			conform.format({ bufnr = args.buf, lsp_format = "fallback" })
		end
	end,
})
