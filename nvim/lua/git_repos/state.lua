local git = require("git_repos.git")
local M = {}
local queue, running, cache = {}, 0, {}
local pump

function M.new(roots, changed)
	local self = { items = {}, changed = changed or function() end }
	for _, root in ipairs(roots) do
		table.insert(self.items, {
			root = root,
			name = vim.fs.basename(root),
			text = vim.fs.basename(root),
			summary = "loading",
			branch = "…",
		})
	end
	function self:refresh(item, done)
		git.git(item.root, { "status", "--porcelain=v2", "--branch", "--untracked-files=normal" }, function(result)
			item.error = result.code ~= 0 and vim.trim(result.stderr or "Git status failed") or nil
			item.dirty, item.ahead, item.behind, item.upstream = false, 0, 0, nil
			local staged, modified, untracked = 0, 0, 0
			for line in (result.stdout or ""):gmatch("[^\r\n]+") do
				if line:match("^# branch.head ") then
					item.branch = line:sub(15)
				elseif line:match("^# branch.upstream ") then
					item.upstream = line:sub(19)
				elseif line:match("^# branch.ab ") then
					local a, b = line:match("%+(%d+) %-(%d+)")
					item.ahead, item.behind = tonumber(a) or 0, tonumber(b) or 0
				elseif line:sub(1, 1) ~= "#" then
					item.dirty = true
					if line:sub(1, 1) == "?" then
						untracked = untracked + 1
					else
						local xy = line:sub(3, 4)
						if xy:sub(1, 1) ~= "." then
							staged = staged + 1
						end
						if xy:sub(2, 2) ~= "." then
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
			item.summary = item.error and "status unavailable" or (#parts == 0 and "clean" or table.concat(parts, ", "))
			self.changed(item)
			if done then
				done(item)
			end
		end)
	end
	function self:fetch(item, force, done)
		local key = git.normalize(item.root)
		local entry = cache[key]
		if entry and entry.pending then
			item.fetching = true
			table.insert(entry.waiters, function(err)
				item.fetching, item.fetch_error = false, err
				self:refresh(item, done)
			end)
			self.changed(item)
			return
		end
		if not force and entry and os.time() - entry.time < 600 then
			item.fetch_error = entry.error
			self:refresh(item, done)
			return
		end
		entry = { pending = true, waiters = {}, time = os.time() }
		cache[key] = entry
		item.fetching = true
		self.changed(item)
		table.insert(entry.waiters, function(err)
			item.fetching, item.fetch_error = false, err
			self:refresh(item, done)
		end)
		table.insert(queue, { root = item.root, entry = entry })
		pump()
	end
	return self
end

pump = function()
	while running < 3 and #queue > 0 do
		local job = table.remove(queue, 1)
		running = running + 1
		git.git(job.root, { "fetch", "--all", "--prune", "--quiet" }, function(result)
			local err = result.code ~= 0
					and (result.code == 124 and "fetch timed out" or vim.trim(result.stderr or "fetch failed"))
				or nil
			job.entry.pending, job.entry.error = false, err
			for _, waiter in ipairs(job.entry.waiters) do
				waiter(err)
			end
			job.entry.waiters = {}
			running = running - 1
			pump()
		end, { timeout = 15000, env = { GCM_INTERACTIVE = "Never", GIT_TERMINAL_PROMPT = "0" } })
	end
end

return M
