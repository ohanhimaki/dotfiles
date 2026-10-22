local git = require("git_repos.git")
local M = {}

local function discover(opts, callback)
	local cwd = opts.cwd or vim.fn.getcwd()
	git.git_root(opts.cwd or git.current_directory(), function(root)
		if root and not opts.force_root then
			callback({ root })
			return
		end
		git.find_child_repositories(cwd, function(roots)
			if #roots > 0 then
				callback(roots)
			else
				git.git_root(cwd, function(cwd_root)
					callback(cwd_root and { cwd_root } or {})
				end)
			end
		end)
	end)
end

--- Open a repository dashboard or select a repository for a supplied action object.
--- Actions: {label, key?, run(repo, context), enabled?(repo), keep_open?}.
--- Options: {actions?, action?, cwd?, force_root?, force_picker?}.
--- force_root searches the cwd's children even when the current buffer belongs to a repo.
function M.open(opts)
	opts = vim.tbl_extend("force", { actions = {} }, opts or {})
	if vim.fn.executable("git") ~= 1 then
		vim.notify("Git executable was not found", vim.log.levels.ERROR)
		return
	end
	discover(opts, function(roots)
		if #roots == 0 then
			vim.notify("No Git repositories found", vim.log.levels.WARN)
			return
		end
		local state = require("git_repos.state").new(roots)
		if #roots == 1 and not opts.force_picker then
			state:refresh(state.items[1], function(repo)
				local context = {
					refresh = function()
						state:refresh(repo)
					end,
					pull = function(items)
						require("git_repos.pull").run(state, items, function() end)
					end,
				}
				local function run(action)
					if not action then
						return
					end
					if action.enabled then
						local enabled, reason = action.enabled(repo)
						if not enabled then
							vim.notify(reason or "Action unavailable", vim.log.levels.WARN)
							return
						end
					end
					action.run(repo, context)
				end
				state:fetch(repo)
				if opts.action then
					run(opts.action)
				else
					vim.ui.select(opts.actions, {
						prompt = repo.name .. ": action",
						format_item = function(a)
							return a.label
						end,
					}, run)
				end
			end)
		else
			require("git_repos.picker").open(state, opts)
		end
	end)
end

-- Compatibility for existing callback-based mappings.
function M.run(callback, force_root)
	M.open({
		action = {
			label = "Open repository",
			run = function(repo)
				callback(repo.root)
			end,
		},
		force_root = force_root,
		force_picker = force_root,
	})
end
return M
