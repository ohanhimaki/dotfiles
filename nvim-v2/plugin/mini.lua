vim.pack.add({
	"https://github.com/nvim-mini/mini.nvim",
})

require("mini.ai").setup()
require("mini.pairs").setup()
require("mini.move").setup()
require("mini.surround").setup()

require("mini.diff").setup()
require("mini.git").setup()
require("mini.files").setup()
require("mini.jump").setup({
	delay = {
		highlight = 50,
		idle_stop = 5000,
	},
})
require("mini.jump2d").setup()

-- require("mini.statusline").setup() --todo: hl groupit git muutoksille, lsp nimet näkyviin, diagnostiikoille hl
require("mini.tabline").setup()
