-- Run from the repository root: nvim --headless -u NONE -i NONE -l nvim/tests/git_repos.lua
vim.opt.rtp:prepend(vim.fn.getcwd() .. "/nvim")
local git = require("git_repos.git")
local State = require("git_repos.state")
local Pull = require("git_repos.pull")
local temp = vim.fn.tempname()
vim.fn.mkdir(temp, "p")
local function command(args)
	local result = vim.system(args, { text = true }):wait()
	assert(result.code == 0, result.stderr)
	return vim.trim(result.stdout)
end
local function g(root, ...)
	return command(vim.list_extend({ "git", "-C", root }, { ... }))
end
local function await(start)
	local finished, value = false, nil
	start(function(v)
		finished, value = true, v
	end)
	assert(
		vim.wait(10000, function()
			return finished
		end, 10),
		"Timed out"
	)
	return value
end
local function write(root, name, content)
	vim.fn.writefile({ content }, root .. "/" .. name)
end
local notifications = {}
vim.notify = function(message)
	table.insert(notifications, message)
end
local original_select = vim.ui.select
local Confirm = require("git_repos.confirm")
local original_confirm = Confirm.open
local ok, err = xpcall(function()
	-- Ordinary children must not leak their parent repository into discovery.
	local parent = temp .. "/parent"
	command({ "git", "init", "--initial-branch=main", parent })
	vim.fn.mkdir(parent .. "/ordinary", "p")
	local nested = parent .. "/nested"
	command({ "git", "init", "--initial-branch=main", nested })
	local discovered = await(function(done)
		git.find_child_repositories(parent, done)
	end)
	assert(#discovered == 1 and discovered[1] == nested, "Discovery must exclude the parent repository")
	-- Symlink aliases are accepted and deduplicated by their real path.
	assert(vim.uv.fs_symlink(nested, parent .. "/alias", { dir = true }))
	discovered = await(function(done)
		git.find_child_repositories(parent, done)
	end)
	assert(#discovered == 1 and discovered[1] == nested)
	local worktree = parent .. "/worktree"
	g(
		parent,
		"-c",
		"user.name=Test",
		"-c",
		"user.email=test@example.invalid",
		"commit",
		"--allow-empty",
		"-m",
		"Initial"
	)
	g(parent, "worktree", "add", "-b", "worktree-test", worktree)
	discovered = await(function(done)
		git.find_child_repositories(parent, done)
	end)
	assert(#discovered == 2, "Worktrees must remain discoverable")
	-- With no child repositories, the public API falls back to the cwd repository.
	local fallback = temp .. "/fallback"
	command({ "git", "init", "--initial-branch=main", fallback })
	vim.fn.mkdir(fallback .. "/ordinary", "p")
	local fallback_repo = await(function(done)
		require("git_repos").open({ cwd = fallback, force_root = true, action = { label = "Capture", run = done } })
	end)
	assert(fallback_repo.root == fallback)
	-- Deferred simulated Git responses expose the maximum discovery concurrency.
	local original_dirs, original_root = git.child_directories, git.git_root
	local active, peak, completed = 0, 0, 0
	git.child_directories = function()
		local dirs = {}
		for i = 1, 200 do
			dirs[i] = temp .. "/simulated/" .. i
		end
		return dirs
	end
	git.git_root = function(_, callback)
		active = active + 1
		peak = math.max(peak, active)
		vim.schedule(function()
			active = active - 1
			completed = completed + 1
			callback(nil)
		end)
	end
	local simulation_ok, simulation_error = pcall(function()
		local result = await(function(done)
			git.find_child_repositories(temp, done)
		end)
		assert(#result == 0 and completed == 200 and active == 0)
		assert(peak <= 4 and peak > 1, "Discovery concurrency must be bounded")
	end)
	git.child_directories, git.git_root = original_dirs, original_root
	assert(simulation_ok, simulation_error)
	local remote, seed, workspace = temp .. "/remote.git", temp .. "/seed", temp .. "/workspace"
	command({ "git", "init", "--bare", "--initial-branch=main", remote })
	command({ "git", "clone", remote, seed })
	g(seed, "config", "user.email", "test@example.invalid")
	g(seed, "config", "user.name", "Test")
	write(seed, "file", "first")
	g(seed, "add", ".")
	g(seed, "commit", "-m", "Initial")
	g(seed, "push", "-u", "origin", "main")
	vim.fn.mkdir(workspace, "p")
	local clean, dirty, diverged = workspace .. "/clean", workspace .. "/dirty", workspace .. "/diverged"
	for _, root in ipairs({ clean, dirty, diverged }) do
		command({ "git", "clone", remote, root })
	end
	g(diverged, "config", "user.email", "test@example.invalid")
	g(diverged, "config", "user.name", "Test")
	write(diverged, "local", "local")
	g(diverged, "add", ".")
	g(diverged, "commit", "-m", "Local")
	write(dirty, "untracked", "keep me")
	write(seed, "file", "second")
	g(seed, "commit", "-am", "Remote update")
	g(seed, "push")
	local roots = await(function(done)
		git.find_child_repositories(workspace, done)
	end)
	assert(#roots == 3)
	local changes = 0
	local state = State.new(roots, function()
		changes = changes + 1
	end)
	for _, item in ipairs(state.items) do
		await(function(done)
			state:refresh(item, done)
		end)
		assert(item.behind == 0, "Before fetch must use old remote state")
		await(function(done)
			state:fetch(item, true, done)
		end)
		assert(item.behind == 1 and not item.fetching, "Fetch must refresh behind count")
	end
	assert(changes >= 9)
	local by_name = {}
	for _, item in ipairs(state.items) do
		by_name[item.name] = item
	end
	assert(not Pull.reason(by_name.clean))
	assert(Pull.reason(by_name.dirty) == "local changes")
	assert(Pull.reason(by_name.diverged) == "diverged")
	local prompts = 0
	Confirm.open = function(lines, count, callback)
		local plan = table.concat(lines, "\n")
		assert(count == 1)
		prompts = prompts + 1
		assert(plan:find("dirty: skip", 1, true))
		assert(plan:find("diverged: skip", 1, true))
		callback(true)
	end
	await(function(done)
		Pull.run(state, state.items, done)
	end)
	assert(prompts == 1)
	assert(g(clean, "rev-parse", "HEAD") == g(seed, "rev-parse", "HEAD"))
	assert(by_name.clean.behind == 0)
	assert(vim.fn.readfile(dirty .. "/untracked")[1] == "keep me")
	assert(by_name.diverged.ahead == 1 and by_name.diverged.behind == 1)
	assert(notifications[#notifications]:find("1 updated, 2 skipped, 0 failed", 1, true))
	-- Shared action objects work for direct mappings and the single-repository menu.
	local repos = require("git_repos")
	local action = { label = "Capture repository" }
	local captured = await(function(done)
		action.run = done
		repos.open({ cwd = clean, action = action, actions = { action } })
	end)
	assert(captured.root == clean)
	vim.ui.select = function(actions, _, callback)
		assert(actions[1] == action, "Action objects must keep their identity")
		callback(actions[1], 1)
	end
	captured = await(function(done)
		action.run = done
		repos.open({ cwd = clean, actions = { action } })
	end)
	assert(captured.root == clean)
	-- Cancel must leave the checked-out commit unchanged.
	write(seed, "file", "third")
	g(seed, "commit", "-am", "Another update")
	g(seed, "push")
	local before = g(clean, "rev-parse", "HEAD")
	Confirm.open = function(_, _, callback)
		callback(false)
	end
	await(function(done)
		Pull.run(state, { by_name.clean }, done)
	end)
	assert(g(clean, "rev-parse", "HEAD") == before)
	-- Failures remain visible and prevent pull.
	g(clean, "remote", "set-url", "origin", temp .. "/missing.git")
	await(function(done)
		state:fetch(by_name.clean, true, done)
	end)
	assert(by_name.clean.fetch_error and not by_name.clean.fetching)
	Confirm.open = function()
		error("Failed fetch must not offer pull")
	end
	await(function(done)
		Pull.run(state, { by_name.clean }, done)
	end)
	-- Detached and missing upstream are explicit skip reasons.
	assert(Pull.reason({ branch = "(detached)" }) == "detached HEAD")
	assert(Pull.reason({ branch = "main" }) == "no upstream")
	print("PASS: discovery, async fetch/status, clean pull, dirty/diverged skip, cancellation, fetch failure")
end, debug.traceback)
vim.ui.select = original_select
Confirm.open = original_confirm
vim.fn.delete(temp, "rf")
if not ok then
	error(err)
end
