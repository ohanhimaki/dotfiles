vim.pack.add({
	"https://github.com/nvim-mini/mini.nvim",
})

require("mini.ai").setup()
require("mini.pairs").setup()
require("mini.move").setup()
require("mini.surround").setup()
require("mini.diff").setup({
	view = {
		style = "sign",
		signs = {
			added = "▎",
			deleted = "▎",
			changed = "▎",
			top = "▔",
			bottom = "▁",
		},
	},
})
require("mini.git").setup()
require("mini.files").setup({
	mappings = {
		go_in_plus = "<CR>",
		synchronize = "s",
	},
})

require("mini.jump").setup({
	delay = {
		highlight = 50,
		idle_stop = 5000,
	},
})

-- Statuslinen värit (gruvbox-paletti)
vim.api.nvim_set_hl(0, "MiniStatuslineModeNormal", { bg = "#458588", fg = "#282828", bold = true })
vim.api.nvim_set_hl(0, "MiniStatuslineModeInsert", { bg = "#98971a", fg = "#282828", bold = true })
vim.api.nvim_set_hl(0, "MiniStatuslineModeVisual", { bg = "#d79921", fg = "#282828", bold = true })
vim.api.nvim_set_hl(0, "MiniStatuslineModeReplace", { bg = "#cc241d", fg = "#ebdbb2", bold = true })
vim.api.nvim_set_hl(0, "MiniStatuslineModeCommand", { bg = "#b16286", fg = "#282828", bold = true })
vim.api.nvim_set_hl(0, "MiniStatuslineModeOther", { bg = "#689d6a", fg = "#282828", bold = true })
vim.api.nvim_set_hl(0, "MiniStatuslineDevinfo", { bg = "#3c3836", fg = "#a89984" })
vim.api.nvim_set_hl(0, "MiniStatuslineFilename", { bg = "#504945", fg = "#ebdbb2" })
vim.api.nvim_set_hl(0, "MiniStatuslineFileinfo", { bg = "#3c3836", fg = "#a89984" })
vim.api.nvim_set_hl(0, "MiniStatuslineInactive", { bg = "#282828", fg = "#504945" })
-- Git diff -värit (sama tausta kuin devinfo, eri tekstiväri)
vim.api.nvim_set_hl(0, "MiniStatuslineGitAdded", { bg = "#3c3836", fg = "#b8bb26" }) -- vihreä
vim.api.nvim_set_hl(0, "MiniStatuslineGitChanged", { bg = "#3c3836", fg = "#fabd2f" }) -- keltainen
vim.api.nvim_set_hl(0, "MiniStatuslineGitDeleted", { bg = "#3c3836", fg = "#fb4934" }) -- punainen
-- Diagnostiikkavärit
vim.api.nvim_set_hl(0, "MiniStatuslineDiagError", { bg = "#1c1a19", fg = "#fb4934" }) -- punainen
vim.api.nvim_set_hl(0, "MiniStatuslineDiagWarn", { bg = "#1c1a19", fg = "#fabd2f" }) -- keltainen
vim.api.nvim_set_hl(0, "MiniStatuslineDiagInfo", { bg = "#1c1a19", fg = "#83a598" }) -- sininen
vim.api.nvim_set_hl(0, "MiniStatuslineDiagHint", { bg = "#1c1a19", fg = "#b8bb26" }) -- vihreä

require("mini.statusline").setup({
	content = {
		active = function()
			local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
			local git = MiniStatusline.section_git({ trunc_width = 75 })
			local lsp = MiniStatusline.section_lsp({ trunc_width = 75 })
			-- Tiedostonimi suhteessa cwd:hen (esim. src/main.cs eikä /home/user/.../main.cs)
			local filename = (function()
				local fname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":.")
				if fname == "" then
					fname = "[No Name]"
				end
				if vim.bo.modified then
					fname = fname .. " [+]"
				end
				if not vim.bo.modifiable then
					fname = fname .. " [-]"
				end
				return vim.fn.fnamemodify(vim.fn.getcwd(), ":t") .. "  " .. fname
			end)()
			local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
			local location = MiniStatusline.section_location({ trunc_width = 75 })
			local search = MiniStatusline.section_searchcount({ trunc_width = 75 })

			-- Värilliset git diff -luvut mini.diffistä
			local n_ranges, diff_add, diff_change, diff_delete = "", "", "", ""
			local ok, data = pcall(MiniDiff.get_buf_data, 0)
			if ok and data and data.summary then
				local s = data.summary
				if (s.n_ranges or 0) > 0 then
					n_ranges = "#" .. s.n_ranges
				end
				if (s.add or 0) > 0 then
					diff_add = "+" .. s.add
				end
				if (s.change or 0) > 0 then
					diff_change = "~" .. s.change
				end
				if (s.delete or 0) > 0 then
					diff_delete = "-" .. s.delete
				end
			end

			-- Värilliset diagnostiikat
			local diag_e, diag_w, diag_i, diag_h = "", "", "", ""
			local counts = vim.diagnostic.count(0)
			local E = vim.diagnostic.severity.ERROR
			local W = vim.diagnostic.severity.WARN
			local I = vim.diagnostic.severity.INFO
			local H = vim.diagnostic.severity.HINT

			if (counts[E] or 0) > 0 then
				diag_e = tostring(counts[E]) .. "E"
			end
			if (counts[W] or 0) > 0 then
				diag_w = tostring(counts[W]) .. "W"
			end
			if (counts[I] or 0) > 0 then
				diag_i = tostring(counts[I]) .. "I"
			end
			if (counts[H] or 0) > 0 then
				diag_h = tostring(counts[H]) .. "H"
			end

			return MiniStatusline.combine_groups({
				{ hl = mode_hl, strings = { mode } },
				{ hl = "MiniStatuslineDevinfo", strings = { git } },
				{ hl = "MiniStatuslineDevinfo", strings = { n_ranges } },
				{ hl = "MiniStatuslineGitAdded", strings = { diff_add } },
				{ hl = "MiniStatuslineGitChanged", strings = { diff_change } },
				{ hl = "MiniStatuslineGitDeleted", strings = { diff_delete } },
				"%<",
				{ hl = "MiniStatuslineFilename", strings = { filename } },
				"%=",
				{ hl = "MiniStatuslineDiagError", strings = { diag_e } },
				{ hl = "MiniStatuslineDiagWarn", strings = { diag_w } },
				{ hl = "MiniStatuslineDiagInfo", strings = { diag_i } },
				{ hl = "MiniStatuslineDiagHint", strings = { diag_h } },
				{ hl = "MiniStatuslineDevinfo", strings = { lsp } },
				{ hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
				{ hl = mode_hl, strings = { search, location } },
			})
		end,
	},
})

require("mini.tabline").setup()
