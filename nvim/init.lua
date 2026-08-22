vim.loader.enable()
-- if vim.g.vscode then
-- 	require("vscode")
-- 	return
-- end

vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("options")
require("autocmds")
require("mappings")
require("commands")
