vim.pack.add({
	"https://github.com/HakonHarnes/img-clip.nvim",
})

require("img-clip").setup({
	default = {
		dir_path = "images", -- kuvat tähän kansioon
		file_name = "%Y%m%d-%H%M%S",
		use_absolute_path = false,
	},
})
vim.keymap.set("n", "<leader>p", function()
	require("img-clip").paste_image()
end, { desc = "Paste image from clipboard" })
