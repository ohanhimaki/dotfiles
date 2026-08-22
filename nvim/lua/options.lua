-------------------------------------- options ------------------------------------------

-- UI ------------------------------------------------------------------------
vim.o.laststatus = 3
vim.o.showmode = false
vim.o.splitkeep = "screen"
vim.o.confirm = true
vim.o.cursorline = true
vim.o.cursorlineopt = "both"
vim.opt.fillchars = { eob = " " }
vim.o.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.o.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"
vim.o.termguicolors = true
vim.o.winborder = "single"
vim.o.title = true
vim.o.titlestring = "nvim - %{fnamemodify(getcwd(), ':t')}"
-- disable nvim intro screen message
vim.opt.shortmess:append("sI")

vim.schedule(function()
	vim.o.clipboard = "unnamedplus"
end)

-- Numbers ---------------------------------------------------------------------
vim.o.number = true
vim.o.numberwidth = 2
vim.o.ruler = true
vim.o.relativenumber = true

-- Editing / Indenting -----------------------------------------------------
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.smartindent = true
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.autoindent = true
vim.o.wrap = false
vim.o.formatoptions = vim.o.formatoptions:gsub("[cro]", "")
-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
vim.opt.whichwrap:append("<>[]hl")

-- Search --------------------------------------------------------------------
vim.o.ignorecase = true
vim.o.smartcase = true

-- Windows / splits ------------------------------------------------------------
vim.o.signcolumn = "yes:1"
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.mouse = "a"
-- show rows after end of file
vim.o.scrolloff = 8

-- Folding ---------------------------------------------------------------------
vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true

-- Files / undo / backup --------------------------------------------------------
vim.o.undofile = true
vim.o.swapfile = false -- Estää .swp-tiedostojen luomisen, jotka kyykyttävät Defenderin
vim.o.updatetime = 250

-- Timeouts / terminal key handling ---------------------------------------------
vim.o.timeoutlen = 500 -- time to wait for a mapped key sequence
vim.o.ttimeout = true
vim.o.ttimeoutlen = 50 -- time to wait for a terminal keycode sequence

-- Diagnostics -------------------------------------------------------------
vim.diagnostic.config({
	virtual_text = true, -- Show diagnostics as virtual text at end of line
	virtual_lines = false,
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = { border = "rounded", source = "if_many" },
	jump = {
		on_jump = function(_, bufnr)
			vim.diagnostic.open_float({
				bufnr = bufnr,
				scope = "cursor",
				focus = false,
			})
		end,
	},
})

-- LSP -------------------------------------------------------------------------
vim.lsp.codelens.enable()

-- add binaries installed by mason.nvim to path
local is_windows = vim.fn.has("win32") ~= 0
local sep = is_windows and "\\" or "/"
local delim = is_windows and ";" or ":"
vim.env.PATH = table.concat({ vim.fn.stdpath("data"), "mason", "bin" }, sep) .. delim .. vim.env.PATH

-- Providers (disable unused built-in host providers, faster startup) --------
vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- Experimental / native UI message window (see :h vim.o._ui2) -----------------
require("vim._core.ui2").enable({
	enable = true, -- Whether to enable or disable the UI.
	msg = { -- Options related to the message module.
		---@type 'cmd'|'msg' Default message target, either in the
		---cmdline or in a separate ephemeral message window.
		---@type string|table<string, 'cmd'|'msg'|'pager'> Default message target
		---or table mapping |ui-messages| kinds and triggers to a target.
		targets = "cmd",
		cmd = { -- Options related to messages in the cmdline window.
			height = 0.5, -- Maximum height while expanded for messages beyond 'cmdheight'.
		},
		dialog = { -- Options related to dialog window.
			height = 0.5, -- Maximum height.
		},
		msg = { -- Options related to msg window.
			height = 0.5, -- Maximum height.
			timeout = 4000, -- Time a message is visible in the message window.
		},
		pager = { -- Options related to message window.
			height = 1, -- Maximum height.
		},
	},
})

-- Built-in packages -------------------------------------------------------
vim.cmd("packadd nvim.undotree")
vim.cmd("packadd nvim.difftool")

-- Filetypes -----------------------------------------------------------------
vim.filetype.add({
	extension = {
		razor = "razor",
		cshtml = "razor",
	},
})
