vim.pack.add({
	"https://github.com/sindrets/diffview.nvim",
})

require("diffview").setup({})

vim.keymap.set("n", "<leader>gD", "<cmd>DiffviewOpen<cr>", { desc = "Diffview open" })
vim.keymap.set("n", "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", { desc = "Diffview file history (current file)" })
vim.keymap.set("n", "<leader>gH", "<cmd>DiffviewFileHistory<cr>", { desc = "Diffview file history (branch)" })
vim.keymap.set("n", "<leader>gq", "<cmd>DiffviewClose<cr>", { desc = "Diffview close" })
