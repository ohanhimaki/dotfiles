local git = require("git_repos.git")
local M = {}

function M.reason(item)
	if item.error then
		return "status unavailable"
	end
	if item.dirty then
		return "local changes"
	end
	if item.branch == "(detached)" then
		return "detached HEAD"
	end
	if not item.upstream then
		return "no upstream"
	end
	if item.ahead > 0 and item.behind > 0 then
		return "diverged"
	end
	if item.behind == 0 then
		return item.ahead > 0 and "ahead" or "up to date"
	end
end

-- Refresh remote state before planning; recheck the worktree immediately before each pull.
function M.run(state, items, done)
	local remaining = #items
	if remaining == 0 then
		return
	end
	local function plan()
		local eligible, skipped, lines = {}, 0, {}
		for _, item in ipairs(items) do
			local reason = item.fetch_error and "fetch failed" or M.reason(item)
			if reason then
				skipped = skipped + 1
				table.insert(lines, item.name .. ": skip — " .. reason)
			else
				table.insert(eligible, { item = item, branch = item.branch, upstream = item.upstream })
				table.insert(lines, item.name .. ": pull " .. item.branch .. " ← " .. item.upstream)
			end
		end
		if #eligible == 0 then
			vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO, { title = "Git pull: nothing to update" })
			done()
			return
		end
		require("git_repos.confirm").open(lines, #eligible, function(approved)
			if not approved then
				done()
				return
			end
			local succeeded, failures, index = 0, {}, 0
			local next_item
			next_item = function()
				index = index + 1
				local planned = eligible[index]
				local item = planned and planned.item
				if not item then
					vim.notify(
						string.format("%d updated, %d skipped, %d failed", succeeded, skipped, #failures)
							.. (#failures > 0 and "\n" .. table.concat(failures, "\n") or ""),
						#failures > 0 and vim.log.levels.WARN or vim.log.levels.INFO,
						{ title = "Git pull" }
					)
					done()
					return
				end
				state:refresh(item, function()
					local reason = M.reason(item)
					if item.branch ~= planned.branch or item.upstream ~= planned.upstream then
						reason = "branch or upstream changed"
					end
					if reason then
						skipped = skipped + 1
						next_item()
						return
					end
					item.pulling = true
					state.changed(item)
					git.git(item.root, {
						"-c",
						"merge.autostash=false",
						"-c",
						"rebase.autoStash=false",
						"pull",
						"--ff-only",
						"--no-rebase",
					}, function(result)
						item.pulling = false
						if result.code == 0 then
							succeeded = succeeded + 1
						else
							table.insert(failures, item.name .. ": " .. vim.trim(result.stderr or "pull failed"))
						end
						state:refresh(item, next_item)
					end, { timeout = 60000, env = { GCM_INTERACTIVE = "Never", GIT_TERMINAL_PROMPT = "0" } })
				end)
			end
			next_item()
		end)
	end
	for _, item in ipairs(items) do
		state:fetch(item, true, function()
			remaining = remaining - 1
			if remaining == 0 then
				plan()
			end
		end)
	end
end
return M
