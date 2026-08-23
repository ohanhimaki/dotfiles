vim.pack.add({ {
	src = "https://github.com/stevearc/conform.nvim",
} })

if vim.g.autoformat == nil then
	vim.g.autoformat = true
end

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		javascript = { "prettier" },
		javascriptreact = { "prettier" },
		typescript = { "prettier" },
		typescriptreact = { "prettier" },
		json = { "prettier" },
		jsonc = { "prettier" },
		css = { "prettier" },
		html = { "prettier" },
		markdown = { "prettier" },
	},
	format_on_save = function(bufnr)
		if not vim.g.autoformat then
			return nil
		end
		return {
			timeout_ms = 500,
			lsp_format = "fallback",
		}
	end,
})

vim.keymap.set("n", "<leader>tf", function()
	vim.g.autoformat = not vim.g.autoformat
	vim.notify("Autoformat " .. (vim.g.autoformat and "enabled" or "disabled"))
end, { desc = "Toggle autoformat on save" })
