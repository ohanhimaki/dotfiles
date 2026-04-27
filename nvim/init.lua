vim.loader.enable()
if vim.g.vscode then
	require("vscode")
	return
end

vim.g.mapleader = " "

require("options")
require("autocmds")
require("mappings")
require("commands")

vim.filetype.add({
	extension = {
		razor = "razor",
		cshtml = "razor",
	},
})
