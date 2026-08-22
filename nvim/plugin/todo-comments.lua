vim.pack.add({
	"https://github.com/folke/todo-comments.nvim",
})

require("todo-comments").setup({})

vim.keymap.set("n", "]t", function()
	require("todo-comments").jump_next()
end, { desc = "Next todo comment" })
vim.keymap.set("n", "[t", function()
	require("todo-comments").jump_prev()
end, { desc = "Previous todo comment" })
vim.keymap.set("n", "<leader>xt", "<cmd>TodoTrouble<cr>", { desc = "Todo (Trouble)" })
vim.keymap.set("n", "<leader>ft", function()
	Snacks.picker.grep({
		search = "TODO|FIXME|HACK|WARN|PERF|NOTE|TEST",
		regex = true,
	})
end, { desc = "Todo comments (grep)" })
