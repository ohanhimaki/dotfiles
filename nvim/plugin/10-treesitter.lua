vim.pack.add({
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/nvim-treesitter/nvim-treesitter-context",
	"https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
	"https://github.com/HiPhish/rainbow-delimiters.nvim",
})
local parser_path = vim.fs.normalize(vim.fn.stdpath("data") .. "/site")
vim.opt.runtimepath:prepend(parser_path)
vim.env.CC = "gcc"

local parsers = {
	"python", "hyprlang", "vim", "lua", "luadoc", "printf", "vimdoc",
	"html", "css", "c_sharp", "razor", "javascript", "typescript", "tsx",
	"yaml", "regex", "markdown", "markdown_inline", "json", "bash",
}

local treesitter = require("nvim-treesitter")
treesitter.setup({ install_dir = parser_path })

local function install_missing()
	local installed = treesitter.get_installed("parsers")
	local missing = vim.tbl_filter(function(parser)
		return not vim.list_contains(installed, parser)
	end, parsers)
	if #missing == 0 then
		return
	end
	for _, tool in ipairs({ "gcc", "tree-sitter", "curl", "tar" }) do
		if vim.fn.executable(tool) == 0 then
			vim.notify("Treesitter: missing " .. tool .. ". Run bootstrap, then :TSInstallAll", vim.log.levels.WARN)
			return
		end
	end
	treesitter.install(missing):await(function(err)
		if err then
			vim.schedule(function()
				vim.notify("Treesitter installation failed: " .. tostring(err), vim.log.levels.ERROR)
			end)
			return
		end
		-- FileType may have fired before the first parser installation finished.
		vim.schedule(function()
			for _, buf in ipairs(vim.api.nvim_list_bufs()) do
				if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].filetype ~= "" then
					pcall(vim.treesitter.start, buf)
				end
			end
		end)
	end)
end

vim.api.nvim_create_user_command("TSInstallAll", install_missing, {
	desc = "Install missing configured Treesitter parsers",
})
vim.schedule(install_missing)

-- C# keeps its existing built-in indentation.

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
