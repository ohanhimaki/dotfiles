local M = {}

local FETCH_CONCURRENCY = 3
local FETCH_TIMEOUT_MS = 15 * 1000
local FETCH_TTL_SECONDS = 10 * 60

local fetch_attempts = {}
local fetch_queue = {}
local fetch_running = 0

local function notify(message, level)
	vim.notify(message, level or vim.log.levels.INFO, { title = "Git repositories" })
end

local function normalize(path)
	local normalized = vim.fs.normalize(path)
	return vim.fn.has("win32") == 1 and normalized:lower() or normalized
end

local function git(directory, args, callback, options)
	local command = { "git", "-C", directory }
	vim.list_extend(command, args)

	local system_options = vim.tbl_extend("force", { text = true }, options or {})
	local ok, error_message = pcall(vim.system, command, system_options, function(result)
		vim.schedule(function()
			callback(result)
		end)
	end)

	if not ok then
		vim.schedule(function()
			callback({ code = -1, stderr = tostring(error_message) })
		end)
	end
end

local run_fetch_queue

local function finish_fetch(job, result)
	local batch = job.batch
	batch.completed = batch.completed + 1

	if result.code == 0 then
		batch.succeeded = batch.succeeded + 1
	else
		batch.failed = batch.failed + 1
		table.insert(batch.failed_repositories, vim.fs.basename(job.root))
		if result.code == 124 then
			batch.timed_out = batch.timed_out + 1
		end
	end

	if batch.completed == batch.total then
		if batch.failed == 0 then
			if batch.total == 1 then
				notify("Fetch finished for " .. batch.repositories[1])
			else
				notify(string.format("Fetch finished for %d repositories", batch.total))
			end
		else
			table.sort(batch.failed_repositories)
			local message = string.format(
				"Fetch finished: %d succeeded, %d failed (%s)",
				batch.succeeded,
				batch.failed,
				table.concat(batch.failed_repositories, ", ")
			)
			if batch.timed_out > 0 then
				message = message .. string.format("; %d timed out", batch.timed_out)
			end
			notify(message, vim.log.levels.WARN)
		end
	end

	fetch_running = fetch_running - 1
	run_fetch_queue()
end

run_fetch_queue = function()
	while fetch_running < FETCH_CONCURRENCY and #fetch_queue > 0 do
		local job = table.remove(fetch_queue, 1)
		fetch_running = fetch_running + 1

		git(job.root, { "fetch", "--all", "--prune", "--quiet" }, function(result)
			finish_fetch(job, result)
		end, {
			env = {
				GCM_INTERACTIVE = "Never",
				GIT_TERMINAL_PROMPT = "0",
			},
			timeout = FETCH_TIMEOUT_MS,
		})
	end
end

local function fetch_repositories(repositories)
	local now = os.time()
	local due = {}

	for _, root in ipairs(repositories) do
		local key = normalize(root)
		local last_attempt = fetch_attempts[key]
		if not last_attempt or now - last_attempt >= FETCH_TTL_SECONDS then
			fetch_attempts[key] = now
			table.insert(due, root)
		end
	end

	if #due == 0 then
		return
	end

	local batch = {
		completed = 0,
		failed = 0,
		failed_repositories = {},
		repositories = vim.tbl_map(vim.fs.basename, due),
		succeeded = 0,
		timed_out = 0,
		total = #due,
	}

	for _, root in ipairs(due) do
		table.insert(fetch_queue, { batch = batch, root = root })
	end

	run_fetch_queue()
end

local function git_root(directory, callback)
	git(directory, { "rev-parse", "--show-toplevel" }, function(result)
		if result.code ~= 0 then
			return callback(nil)
		end

		local root = vim.trim(result.stdout or "")
		callback(root ~= "" and vim.fs.normalize(root) or nil)
	end)
end

local function current_directory()
	local file = vim.api.nvim_buf_get_name(0)
	if file ~= "" and vim.bo.buftype == "" then
		return vim.fs.dirname(vim.fs.normalize(file))
	end

	return vim.fn.getcwd()
end

local function child_directories(directory)
	local directories = {}
	local ok, error_message = pcall(function()
		for name, entry_type in vim.fs.dir(directory) do
			local path = vim.fs.joinpath(directory, name)
			local stat = entry_type == "link" and vim.uv.fs_stat(path) or nil
			if entry_type == "directory" or (stat and stat.type == "directory") then
				table.insert(directories, path)
			end
		end
	end)

	if not ok then
		notify("Could not read " .. directory .. ": " .. tostring(error_message), vim.log.levels.ERROR)
		return {}
	end

	return directories
end

local function find_child_repositories(directory, callback)
	local directories = child_directories(directory)
	if #directories == 0 then
		return callback({})
	end

	local repositories = {}
	local seen = {}
	local remaining = #directories

	for _, child in ipairs(directories) do
		git_root(child, function(root)
			if root then
				local key = normalize(root)
				if not seen[key] then
					seen[key] = true
					table.insert(repositories, root)
				end
			end

			remaining = remaining - 1
			if remaining == 0 then
				table.sort(repositories, function(left, right)
					return left:lower() < right:lower()
				end)
				callback(repositories)
			end
		end)
	end
end

local function status_summary(output)
	local branch = "unknown"
	local tracking
	local staged = 0
	local modified = 0
	local untracked = 0

	for line in output:gmatch("[^\r\n]+") do
		local branch_status = line:match("^## (.+)$")
		if branch_status then
			local ahead = tonumber(branch_status:match("ahead (%d+)")) or 0
			local behind = tonumber(branch_status:match("behind (%d+)")) or 0
			if branch_status:find("...", 1, true) then
				local parts = {}
				if ahead > 0 then
					table.insert(parts, "↑" .. ahead)
				end
				if behind > 0 then
					table.insert(parts, "↓" .. behind)
				end
				if branch_status:find("[gone]", 1, true) then
					tracking = "gone"
				else
					tracking = #parts > 0 and table.concat(parts, " ") or "="
				end
			end

			branch = branch_status:match("^No commits yet on (.+)$")
				or branch_status:match("^Initial commit on (.+)$")
				or branch_status:match("^(.-)%.%.%.")
				or branch_status:match("^([^ ]+)")
				or branch
			if branch == "HEAD" then
				branch = "detached"
			end
		else
			local index_status = line:sub(1, 1)
			local worktree_status = line:sub(2, 2)

			if index_status == "?" and worktree_status == "?" then
				untracked = untracked + 1
			elseif index_status ~= "!" then
				if index_status ~= " " then
					staged = staged + 1
				end
				if worktree_status ~= " " then
					modified = modified + 1
				end
			end
		end
	end

	local parts = {}
	if staged > 0 then
		table.insert(parts, staged .. " staged")
	end
	if modified > 0 then
		table.insert(parts, modified .. " modified")
	end
	if untracked > 0 then
		table.insert(parts, untracked .. " untracked")
	end

	return #parts == 0 and "clean" or table.concat(parts, ", "), branch, tracking
end

local function add_statuses(repositories, callback)
	if #repositories == 0 then
		return callback({})
	end

	local items = {}
	local remaining = #repositories

	for _, root in ipairs(repositories) do
		git(root, { "status", "--porcelain=v1", "--branch" }, function(result)
			local summary = "status unavailable"
			local branch = "unknown"
			local tracking
			if result.code == 0 then
				summary, branch, tracking = status_summary(result.stdout or "")
			end

			table.insert(items, {
				branch = branch,
				name = vim.fs.basename(root),
				root = root,
				summary = summary,
				dirty = summary ~= "clean",
				tracking = tracking,
			})

			remaining = remaining - 1
			if remaining == 0 then
				table.sort(items, function(left, right)
					return left.name:lower() < right.name:lower()
				end)
				callback(items)
			end
		end)
	end
end

local function select_repository(directory, callback)
	find_child_repositories(directory, function(repositories)
		fetch_repositories(repositories)

		add_statuses(repositories, function(items)
			if #items == 0 then
				notify("No Git repositories found directly under " .. directory, vim.log.levels.WARN)
				return
			end

			Snacks.picker.select(items, {
				prompt = "Select Git repository",
				format_item = function(item)
					local icon = item.dirty and "●" or "✓"
					local branch = item.tracking and item.branch .. " " .. item.tracking or item.branch
					return string.format("%s %s [%s] (%s)", icon, item.name, branch, item.summary)
				end,
				snacks = {
					layout = { preset = "select" },
					preview = "none",
					on_show = function()
						vim.cmd.stopinsert()
					end,
				},
			}, function(choice)
				if choice then
					callback(choice.root)
				end
			end)
		end)
	end)
end

function M.run(callback)
	if vim.fn.executable("git") ~= 1 then
		notify("Git executable was not found", vim.log.levels.ERROR)
		return
	end

	local directory = current_directory()
	local cwd = vim.fn.getcwd()

	git_root(directory, function(root)
		if root then
			fetch_repositories({ root })
			callback(root)
			return
		end

		if normalize(directory) == normalize(cwd) then
			select_repository(cwd, callback)
			return
		end

		git_root(cwd, function(cwd_root)
			if cwd_root then
				fetch_repositories({ cwd_root })
				callback(cwd_root)
				return
			end

			select_repository(cwd, callback)
		end)
	end)
end

return M
