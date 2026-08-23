--snacks
vim.pack.add({
	"https://github.com/folke/snacks.nvim",
	"https://github.com/2kabhishek/seeker.nvim",
})

local onshowpickerdefault = function()
	vim.cmd.stopinsert()
end

local getsnacksterminalshell = function()
	return vim.fn.has("win32") == 1 and "pwsh.exe" or vim.o.shell
end

local getsnacksterminalinfo = function(term)
	local info = vim.b[term.buf].snacks_terminal or {}
	local title = vim.b[term.buf].term_title
	local cmd = info.cmd
	local label = title

	if label == nil or label == "" then
		if type(cmd) == "table" then
			label = table.concat(cmd, " ")
		else
			label = cmd
		end
	end

	if label == nil or label == "" then
		label = getsnacksterminalshell()
	end

	return {
		count = tonumber(info.id) or 1,
		cwd = info.cwd or vim.fn.getcwd(),
		label = label,
		term = term,
	}
end

local getsnacksterminals = function()
	local terminals = vim.tbl_map(getsnacksterminalinfo, Snacks.terminal.list())
	table.sort(terminals, function(left, right)
		return left.count < right.count
	end)
	return terminals
end

local getsnacksnextterminalcount = function()
	local next_count = 1
	local used_counts = {}

	for _, terminal in ipairs(getsnacksterminals()) do
		used_counts[terminal.count] = true
	end

	while used_counts[next_count] do
		next_count = next_count + 1
	end

	return next_count
end

local showsnacksdefaultterminal = function()
	Snacks.terminal.toggle(getsnacksterminalshell(), { count = 1 })
end

local opensnacksnewterminal = function()
	Snacks.terminal.toggle(getsnacksterminalshell(), { count = getsnacksnextterminalcount() })
end

local showsnacksterminalpicker = function(terminals)
	Snacks.picker.select(terminals, {
		prompt = "Select terminal",
		format_item = function(item)
			return string.format("[%d] %s (%s)", item.count, item.label, item.cwd)
		end,
		snacks = {
			layout = { preset = "select" },
			preview = "none",
			on_show = onshowpickerdefault,
		},
	}, function(choice)
		if choice then
			choice.term:show()
		end
	end)
end
local snacks_config = {
	bigfile = { enabled = true },
	dashboard = {
		enabled = true,
		formats = {
			file = function(item, ctx)
				local cwd = vim.fn.getcwd()
				local abs = vim.fn.fnamemodify(item.file, ":p")
				local cwd_norm = cwd:lower():gsub("\\", "/"):gsub("/?$", "/")
				local abs_norm = abs:lower():gsub("\\", "/")
				local in_cwd = vim.startswith(abs_norm, cwd_norm)
				local fname
				if in_cwd then
					fname = abs:sub(#cwd + 2):gsub("\\", "/")
					if ctx.width and #fname > ctx.width then
						fname = vim.fn.pathshorten(fname)
					end
				else
					fname = vim.fn.fnamemodify(abs, ":~")
					if ctx.width and #fname > ctx.width then
						fname = vim.fn.pathshorten(fname)
					end
				end
				local dir, file = fname:match("^(.*)/(.+)$")
				if in_cwd then
					return dir
							and { { dir .. "/", hl = "SnacksDashboardDir" }, { file, hl = "SnacksDashboardSpecial" } }
						or { { fname, hl = "SnacksDashboardSpecial" } }
				else
					return dir and { { dir .. "/", hl = "SnacksDashboardDir" }, { file, hl = "SnacksDashboardKey" } }
						or { { fname, hl = "SnacksDashboardKey" } }
				end
			end,
		},
		sections = {
			-- { section = "header" },
			{
				pane = 2,
				section = "keys",
				gap = 0,
				padding = 1,
			},
			{
				section = "recent_files",
				title = "Recent Files - cwd",
				limit = 5,
				padding = 1,
				cwd = true,
			},
			{
				section = "recent_files",
				title = "Recent Files - all",
				limit = 5,
				padding = 1,
			},
			{
				title = "Projects",
				pane = 2,
				section = "projects",
			},
			-- { section = "startup" },
		},
		preset = {
			header = {
				[[
          _              _                     _
__      _( )_ __   _ __ | |_   _ __  _ __ ___ | |__  _ __ ___
\ \ /\ / //| '__| | '_ \| __| | '_ \| '_ ` _ \| '_ \| '__/ __|
 \ V  V /  | |    | | | | |_  | | | | | | | | | |_) | |  \__ \
  \_/\_/   |_|    |_| |_|\__| |_| |_|_| |_| |_|_.__/|_|  |___/
    ]],
			},
			keys = {
				{ icon = " ", key = "e", desc = "New File", action = ":ene | startinsert" },
				{ icon = " ", key = "o", desc = "Oil", action = ":Oil" },
				{
					icon = " ",
					key = "f",
					desc = "Find Files",
					action = function()
						Snacks.picker.git_files()
					end,
				},
				{
					icon = " ",
					key = "r",
					desc = "Recent Files",
					action = function()
						Snacks.picker.recent()
					end,
				},
				{
					icon = " ",
					key = "g",
					desc = "Grep",
					action = function()
						Snacks.picker.grep()
					end,
				},
				{ icon = " ", key = "d", desc = "CodeDiff", action = ":CodeDiff" },
				{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
			},
		},
	},
	indent = {
		enabled = true,
		indent = {
			priority = 1,
			hl = {
				"SnacksIndent1",
				"SnacksIndent",
			},
		},
		animate = { enabled = false },
		scope = { enabled = true },
	},
	picker = {
		enabled = true,
		layout = { preset = "ivy" },
		sources = {
			buffers = {
				layout = { preset = "vscode" },
			},
		},
	},
	lazygit = { enabled = true },
	terminal = {
		enabled = true,
		win = {
			style = "terminal",
			border = "rounded",
			keys = {
				term_hide = { "<esc><esc>", "<C-\\><C-n>", mode = "t", desc = "Exit terminal mode" },
			},
		},
	},
	explorer = { enabled = true },
	notifier = { enabled = true },
	quickfile = { enabled = true },
	scope = { enabled = true },
	--scroll = { enabled = true },
	statuscolumn = { enabled = true, folds = {
		open = true,
	} },
	words = { enabled = true },
}

require("snacks").setup(snacks_config)

local keys = {
	-- Picker (replaces telescope)
	{
		"<leader>fk",
		function()
			Snacks.picker.keymaps()
		end,
		desc = "Keymaps",
	},
	{
		"<leader>fb",
		function()
			Snacks.picker.buffers({ on_show = onshowpickerdefault })
		end,
		desc = "Buffers",
	},
	{
		"<leader>,",
		function()
			Snacks.picker.buffers({ on_show = onshowpickerdefault })
		end,
		desc = "Buffers",
	},
	{
		"<leader>fh",
		function()
			Snacks.picker.help()
		end,
		desc = "Help",
	},
	{
		"<leader>fd",
		function()
			Snacks.picker.diagnostics()
		end,
		desc = "Diagnostics",
	},
	{
		"<leader>fgg",
		function()
			Snacks.picker.git_status({
				on_show = onshowpickerdefault,
			})
		end,
		desc = "Git status",
	},
	{
		"<leader>fgr",
		function()
			Snacks.picker.git_log_file()
		end,
		desc = "Git log file",
	},
	{
		"<leader>ma",
		function()
			Snacks.picker.marks()
		end,
		desc = "Marks",
	},
	{
		"<leader>fo",
		function()
			Snacks.picker.recent()
		end,
		desc = "Recent files",
	},
	{
		"<leader>fz",
		function()
			Snacks.picker.lines()
		end,
		desc = "Lines in buffer",
	},
	{
		"<leader>cm",
		function()
			Snacks.picker.git_log()
		end,
		desc = "Git commits",
	},
	{
		"<leader>gt",
		function()
			Snacks.picker.git_status()
		end,
		desc = "Git status",
	},
	{
		"<leader>fa",
		function()
			vim.cmd("Seeker files")
		end,
		desc = "Files (seeker)",
	},
	{
		"<leader>fA",
		function()
			Snacks.picker.files({ ignored = true })
		end,
		desc = "Files (seeker)",
	},
	{
		"<leader>ff",
		function()
			vim.cmd("Seeker git_files")
		end,
		desc = "Git files (seeker)",
	},
	{
		"<leader>f?",
		function()
			Snacks.picker.pick()
		end,
		desc = "Snack pick (all pickers)",
	},
	{
		"<leader>fw",
		function()
			vim.cmd("Seeker grep")
		end,
		desc = "Grep (seeker)",
	},
	{
		"<leader>fgo",
		function()
			Snacks.picker.grep({ cwd = vim.fn.expand("~/ohanhimaki") })
		end,
		desc = "Grep (~/ohanhimaki)",
	},
	{
		"<leader>fp",
		function()
			Snacks.picker.recent({ filter = { cwd = true }, on_show = onshowpickerdefault })
		end,
		desc = "Recent files (cwd)",
	},
	{
		"<leader>fc",
		function()
			Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
		end,
		desc = "Nvim config files",
	},
	{
		"<leader>fl",
		function()
			Snacks.picker.files({ cwd = vim.fn.stdpath("data") .. "/site/pack" })
		end,
		desc = "Pack plugin files",
	},
	{
		"<leader>fn",
		function()
			Snacks.picker.notifications({ on_show = onshowpickerdefault })
		end,
		desc = "Show notifications",
	},
	-- Lazygit (replaces lazygit.nvim)
	{
		"<leader>gg",
		function()
			Snacks.lazygit()
		end,
		desc = "LazyGit",
	},
	{
		"<leader>gc",
		function()
			Snacks.lazygit.log_file()
		end,
		desc = "LazyGit current file",
	},
	-- Terminal (replaces toggleterm, <C-g>)
	{
		"<C-g>",
		function()
			showsnacksdefaultterminal()
		end,
		mode = { "n", "t" },
		desc = "Toggle default terminal float",
	},
	{
		"<leader>tn",
		function()
			opensnacksnewterminal()
		end,
		desc = "New terminal float",
	},
	{
		"<leader>tt",
		function()
			local terminals = getsnacksterminals()
			if #terminals == 0 then
				return showsnacksdefaultterminal()
			end
			showsnacksterminalpicker(terminals)
		end,
		desc = "Pick terminal float",
	},
}

for _, key in ipairs(keys) do
	vim.keymap.set(key.mode or "n", key[1], key[2], { desc = key.desc })
end

require("seeker").setup({
	picker_provider = "snacks",
})

-- Show LSP $/progress messages (e.g. "Loading workspace...") as snacks
-- notifications, with a spinner while in progress and per-client lines.
---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
local lsp_progress = vim.defaulttable()
vim.api.nvim_create_autocmd("LspProgress", {
	---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
		if not client or type(value) ~= "table" then
			return
		end
		local p = lsp_progress[client.id]

		for i = 1, #p + 1 do
			if i == #p + 1 or p[i].token == ev.data.params.token then
				p[i] = {
					token = ev.data.params.token,
					msg = ("[%3d%%] %s%s"):format(
						value.kind == "end" and 100 or value.percentage or 100,
						value.title or "",
						value.message and (" **%s**"):format(value.message) or ""
					),
					done = value.kind == "end",
				}
				break
			end
		end

		local msg = {} ---@type string[]
		lsp_progress[client.id] = vim.tbl_filter(function(v)
			return table.insert(msg, v.msg) or not v.done
		end, p)

		local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
		vim.notify(table.concat(msg, "\n"), "info", {
			id = "lsp_progress",
			title = client.name,
			opts = function(notif)
				notif.icon = #lsp_progress[client.id] == 0 and " "
					or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
			end,
		})
	end,
})
