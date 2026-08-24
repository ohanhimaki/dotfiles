vim.pack.add({
	"https://github.com/esmuellert/codediff.nvim",
})
require("codediff").setup({
	diff_tool = "diff", -- or "git", "diffview", etc.
	explorer = {
		focus_on_select = true,
		view_mode = "list",
	},
})
