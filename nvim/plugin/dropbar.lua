-- Breadcrumbs (winbar) via dropbar.nvim, as an alternative to treesitter's
-- sticky "drilling" context lines (nvim-treesitter-context, set up in
-- 10-treesitter.lua). Only one (or neither) is shown at a time, toggled with
-- <leader>tb which cycles: breadcrumbs -> context -> off -> breadcrumbs.
vim.pack.add({
	"https://github.com/Bekaboo/dropbar.nvim",
})

-- "breadcrumbs" | "context" | "off"
vim.g.code_context_mode = "breadcrumbs"

require("dropbar").setup({
	bar = {
		enable = function(buf, win, _)
			if vim.g.code_context_mode ~= "breadcrumbs" then
				return false
			end

			buf = buf or vim.api.nvim_win_get_buf(win)
			if
				not vim.api.nvim_buf_is_valid(buf)
				or not vim.api.nvim_win_is_valid(win)
				or vim.fn.win_gettype(win) ~= ""
				or vim.bo[buf].ft == "help"
			then
				return false
			end

			local stat = vim.uv.fs_stat(vim.api.nvim_buf_get_name(buf))
			if stat and stat.size > 1024 * 1024 then
				return false
			end

			return vim.bo[buf].ft == "markdown"
				or pcall(vim.treesitter.get_parser, buf)
				or not vim.tbl_isempty(vim.lsp.get_clients({ bufnr = buf, method = "textDocument/documentSymbol" }))
		end,
	},
})

local dropbar_api = require("dropbar.api")
vim.keymap.set("n", "<leader>;", dropbar_api.pick, { desc = "Pick symbol in breadcrumbs" })
vim.keymap.set("n", "[;", dropbar_api.goto_context_start, { desc = "Go to start of current context" })
vim.keymap.set("n", "];", dropbar_api.select_next_context, { desc = "Select next context" })

-- Disable treesitter-context by default since breadcrumbs is the default mode.
vim.schedule(function()
	local ok, tsc = pcall(require, "treesitter-context")
	if ok then
		tsc.disable()
	end
end)

--- Switch to a specific code-context mode and refresh the winbar/context
--- immediately (instead of waiting for the next autocmd trigger).
---@param mode "breadcrumbs"|"context"|"off"
local function set_code_context_mode(mode)
	vim.g.code_context_mode = mode

	local ok, tsc = pcall(require, "treesitter-context")
	if ok then
		if mode == "context" then
			tsc.enable()
		else
			tsc.disable()
		end
	end

	-- Force dropbar to re-evaluate `bar.enable` for every window right away:
	-- clear the winbar, then re-fire the event dropbar attaches on.
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		if vim.api.nvim_win_is_valid(win) then
			vim.wo[win].winbar = ""
			local buf = vim.api.nvim_win_get_buf(win)
			vim.api.nvim_win_call(win, function()
				vim.api.nvim_exec_autocmds("BufWinEnter", { buffer = buf })
			end)
		end
	end
end

vim.keymap.set("n", "<leader>tb", function()
	local modes = { "breadcrumbs", "context", "off" }
	local idx = 1
	for i, m in ipairs(modes) do
		if m == vim.g.code_context_mode then
			idx = i
			break
		end
	end
	local next_mode = modes[(idx % #modes) + 1]
	set_code_context_mode(next_mode)
	vim.notify("Code context: " .. next_mode)
end, { desc = "Toggle breadcrumbs/context/off" })
