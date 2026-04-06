vim.pack.add({
	"https://github.com/tpope/vim-dadbod",
	"https://github.com/kristijanhusak/vim-dadbod-ui",
	"https://github.com/kristijanhusak/vim-dadbod-completion",
})
vim.g.db_ui_use_nerd_fonts = 1
vim.g.db_ui_save_location = vim.fn.stdpath("data") .. "/db_ui"

vim.g.db_ui_table_helpers = {
	duckdb = {
		List = "SELECT table_schema, table_name FROM information_schema.tables ORDER BY 1, 2",
		Describe = "DESCRIBE {schema}.{table}",
		Count = "SELECT COUNT(*) FROM {schema}.{table}",
		Sample = "SELECT * FROM {schema}.{table} LIMIT 200",
	},
}
