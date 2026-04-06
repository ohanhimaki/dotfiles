vim.pack.add({
	"https://github.com/3rd/image.nvim",
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
if vim.fn.has("win32") == 1 then
	--check os
	return
end
require("image").setup({
	backend = "sixel",
	integrations = {
		markdown = {
			enabled = true,
			clear_in_insert_mode = true,
			download_remote_images = true,
			only_render_image_at_cursor = true,
			only_render_image_at_cursor_mode = "popup",
			filetypes = { "markdown", "vimwiki" }, -- markdown extensions (ie. quarto) can go here
		},
		neorg = {
			enabled = true,
			clear_in_insert_mode = true,
			download_remote_images = true,
			only_render_image_at_cursor = true,
			only_render_image_at_cursor_mode = "popup",
			filetypes = { "norg" },
		},
	},
	-- max_width = nil,
	-- max_height = nil,
	-- max_width_window_percentage = nil,
	-- max_height_window_percentage = 50,
	-- kitty_method = "normal",
})
