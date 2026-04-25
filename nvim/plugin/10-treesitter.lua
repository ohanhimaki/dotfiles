vim.pack.add({
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/nvim-treesitter/nvim-treesitter-context",
	"https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
	"https://github.com/HiPhish/rainbow-delimiters.nvim",
})
local parser_path = vim.fs.normalize(vim.fn.stdpath("data") .. "/site")
vim.opt.runtimepath:prepend(parser_path)
vim.env.CC = "gcc"

vim.api.nvim_create_user_command("TSInstallAll", function()
	local parsers = {
		"python",
		"hyprlang",
		"vim",
		"lua",
		"luadoc",
		"printf",
		"vimdoc",
		"html",
		"css",
		"c_sharp",
		"razor",
		"javascript",
		"typescript",
		"tsx",
	}

	local ts = require("nvim-treesitter")

	print("Installing/updating Treesitter parsers...")
	ts.install(parsers)
end, {})

local treesitter = require("nvim-treesitter")
treesitter.setup({
	install_dir = parser_path,
	auto_install = true,
	indent = { enable = true },
	highlight = {
		enable = true,
	},
})

vim.keymap.set({ "x", "o" }, "am", function()
	require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "im", function()
	require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "ac", function()
	require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "ic", function()
	require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
end)
-- You can also use captures from other query groups like `locals.scm`
vim.keymap.set({ "x", "o" }, "as", function()
	require("nvim-treesitter-textobjects.select").select_textobject("@local.scope", "locals")
end)

local rainbow = require("rainbow-delimiters")
require("rainbow-delimiters.setup").setup({
	strategy = {
		[""] = rainbow.strategy["global"],
	},
	query = {
		[""] = "rainbow-delimiters",
		lua = "rainbow-blocks",
	},
	highlight = {
		"RainbowDelimiterRed",
		"RainbowDelimiterYellow",
		"RainbowDelimiterBlue",
		"RainbowDelimiterOrange",
		"RainbowDelimiterGreen",
		"RainbowDelimiterViolet",
		"RainbowDelimiterCyan",
	},
})
require("treesitter-context").setup()
