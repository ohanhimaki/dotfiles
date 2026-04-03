vim.pack.add({
	"https://github.com/rafamadriz/friendly-snippets",
	{ src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.x") },
})

require("blink.cmp").setup({
	keymap = { preset = "enter" },
	appearance = { nerd_font_variant = "mono" },
	completion = {
		documentation = {
			auto_show = true,
			auto_show_delay_ms = 500,
		},
	},
	sources = {
		default = {
			-- "lazydev" ,
			"lsp",
			"path",
			"snippets",
			"buffer",
			-- , "dadbod"
		},
		providers = {
			-- lazydev = {
			--   name = "LazyDev",
			--   module = "lazydev.integrations.blink",
			--   score_offset = 100,
			-- },
			-- dadbod = {
			--   name = "Dadbod",
			--   module = "vim_dadbod_completion.blink",
			--   score_offset = 85,
			-- },
		},
	},
	fuzzy = { implementation = "lua" },
	signature = { enabled = true },
})

vim.lsp.config["*"] = {
	capabilities = require("blink.cmp").get_lsp_capabilities(),
}
