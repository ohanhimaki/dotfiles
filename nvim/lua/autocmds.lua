local autocmd = vim.api.nvim_create_autocmd

-- Fires a synthetic "User FilePost" event once, right after the UI is up and a
-- real file buffer has been opened (not e.g. a "nofile" scratch buffer). Also
-- re-fires FileType (so plugins that hook FileType lazily still trigger) and
-- runs editorconfig for that buffer if enabled.
autocmd({ "UIEnter", "BufReadPost", "BufNewFile" }, {
	group = vim.api.nvim_create_augroup("NvFilePost", { clear = true }),
	callback = function(args)
		local file = vim.api.nvim_buf_get_name(args.buf)
		local buftype = vim.api.nvim_get_option_value("buftype", { buf = args.buf })

		if not vim.g.ui_entered and args.event == "UIEnter" then
			vim.g.ui_entered = true
		end

		if file ~= "" and buftype ~= "nofile" and vim.g.ui_entered then
			vim.api.nvim_exec_autocmds("User", { pattern = "FilePost", modeline = false })
			vim.api.nvim_del_augroup_by_name("NvFilePost")

			vim.schedule(function()
				vim.api.nvim_exec_autocmds("FileType", {})

				if vim.g.editorconfig then
					require("editorconfig").config(args.buf)
				end
			end)
		end
	end,
})

-- Start treesitter highlighting/parsing for every filetype that has a parser
-- (pcall so filetypes without a parser don't error out).
vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function()
		pcall(vim.treesitter.start)
	end,
})

-- Enable Kitty keyboard protocol (disambiguate escape codes) while nvim runs,
-- and restore the terminal's default mode on exit.
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		io.stdout:write("\027[>1u")
	end,
})

vim.api.nvim_create_autocmd("VimLeavePre", {
	callback = function()
		io.stdout:write("\027[<1u")
	end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank({ timeout = 150 })
	end,
})
