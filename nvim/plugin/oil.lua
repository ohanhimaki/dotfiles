vim.pack.add({ "https://github.com/stevearc/oil.nvim", "https://github.com/nvim-mini/mini.icons" })

require("mini.icons").setup({})

require("oil").setup({
	
      default_file_explorer = true,
      skip_confirm_for_simple_edits = true,
		keymaps = {
			["q"] = "actions.close",
			["m"] = "actions.select",

			["<Tab>"] = "actions.preview",
			["J"] = "actions.preview_scroll_down",
			["K"] = "actions.preview_scroll_up",
		},
		view_options = {
			-- Show files and directories that start with "."
			show_hidden = true,
		},
})

vim.keymap.set("n", "<leader>o", require("oil").open, { desc = "Open Oil" })
vim.keymap.set("n", "_", require("oil").open, { desc = "Open Oil" })
