if vim.g.vscode then
	require("vscode")
	return
end

vim.g.mapleader = " "

require("options")
require("autocmds")
require("mappings")

vim.filetype.add({
	extension = {
		razor = "razor",
		cshtml = "razor",
	},
})
