vim.pack.add({
	"https://github.com/folke/persistence.nvim",
})

require("persistence").setup({})

-- Restore the session for the current directory
vim.keymap.set("n", "<leader>qs", function()
	require("persistence").load()
end, { desc = "Restore session" })

-- Restore the last session regardless of directory
vim.keymap.set("n", "<leader>ql", function()
	require("persistence").load({ last = true })
end, { desc = "Restore last session" })

-- Stop persistence => session won't be saved on exit
vim.keymap.set("n", "<leader>qd", function()
	require("persistence").stop()
end, { desc = "Don't save current session" })
