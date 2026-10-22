-- Run from the repository root: nvim --headless -u NONE -i NONE -l nvim/tests/git_repos_picker.lua
vim.opt.rtp:prepend(vim.fn.getcwd() .. "/nvim")
local snacks = vim.fn.glob(vim.fn.stdpath("data") .. "/site/pack/*/opt/snacks.nvim", false, true)[1]
assert(snacks, "Install snacks.nvim before running the picker integration test")
vim.opt.rtp:prepend(snacks)
local temp = vim.fn.tempname() .. "/dotfiles"
vim.fn.mkdir(temp, "p")
assert(vim.system({ "git", "init", "--initial-branch=main", temp }):wait().code == 0)
require("snacks").setup({ picker = { enabled = true } })
local State = require("git_repos.state")
local state = State.new({ temp })
local picker = require("git_repos.picker").open(state, { actions = require("config.repo_actions").defaults })
assert(vim.wait(5000, function()
	return picker.shown and state.items[1].summary ~= "loading"
end, 10))
assert(not picker.closed)
local buf = picker.input.win.buf
local keys = vim.api.nvim_buf_get_keymap(buf, "n")
local found = {}
for _, key in ipairs(keys) do
	found[key.lhs] = key
end
assert(found.g and found.f and found.p and found.P)
assert(not found.gg)
-- Status redraw must preserve the input, current item, selection and scroll position.
picker.input:set("dot")
vim.wait(100)
picker.list:select(state.items[1])
local current = picker:current()
local cursor, top = picker.list.cursor, picker.list.top
state.items[1].behind = 42
state.items[1].upstream = "origin/main"
state.changed(state.items[1])
assert(picker.input:get() == "dot")
assert(picker:current() == current)
assert(#picker:selected() == 1)
assert(picker.list.cursor == cursor and picker.list.top == top)
local text = table.concat(vim.api.nvim_buf_get_lines(picker.list.win.buf, 0, -1, false), "\n")
assert(text:find("↓42", 1, true), "Status change must render immediately")
-- Nested action menu must not close the repository picker.
picker.opts.confirm(picker, state.items[1])
vim.wait(100)
assert(not picker.closed)
for _, child in ipairs(Snacks.picker.get()) do
	if child ~= picker then
		child:close()
	end
end
-- Selecting an action through Enter must close the dashboard before execution.
local original_select = vim.ui.select
local ran = false
local action = {
	label = "Capture",
	run = function(repo)
		assert(picker.closed, "Dashboard must close before executing the action")
		assert(repo.root == temp)
		ran = true
	end,
}
picker:close()
picker = require("git_repos.picker").open(state, { actions = { action }, action = action })
picker.opts.confirm(picker, state.items[1])
assert(ran and picker.closed)
-- The action-menu route uses the same close behavior.
picker = require("git_repos.picker").open(state, { actions = { action } })
vim.ui.select = function(items, _, callback)
	callback(items[1], 1)
end
ran = false
picker.opts.confirm(picker, state.items[1])
assert(ran and picker.closed)
vim.ui.select = original_select
-- Actions can explicitly keep the dashboard open, as pull does.
action.keep_open = true
action.run = function()
	assert(not picker.closed)
	ran = true
end
picker = require("git_repos.picker").open(state, { actions = { action }, action = action })
ran = false
picker.opts.confirm(picker, state.items[1])
assert(ran and not picker.closed)
-- Large pull plans live in a scrollable buffer and require explicit approval.
local Confirm = require("git_repos.confirm")
local lines = {}
for i = 1, 200 do
	lines[i] = "repo-" .. i .. ": skip — local changes"
end
local calls, accepted = 0, nil
local function result(value)
	calls = calls + 1
	accepted = value
end
local plan = Confirm.open(lines, 1, result)
assert(vim.api.nvim_get_current_win() == plan.window, "Confirmation must receive focus")
for _, window in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
	if window ~= plan.window then
		local zindex = vim.api.nvim_win_get_config(window).zindex or 0
		assert(vim.api.nvim_win_get_config(plan.window).zindex > zindex, "Confirmation must appear above the dashboard")
	end
end
assert(vim.api.nvim_buf_line_count(plan.buffer) == 200)
assert(vim.api.nvim_win_get_height(plan.window) < 200)
vim.cmd("normal! G")
assert(vim.api.nvim_win_get_cursor(plan.window)[1] == 200)
assert(calls == 0, "Scrolling must not approve the plan")
local function press(buffer, key)
	for _, mapping in ipairs(vim.api.nvim_buf_get_keymap(buffer, "n")) do
		if mapping.lhs == key then
			mapping.callback()
			return
		end
	end
	error("Missing key: " .. key)
end
press(plan.buffer, "y")
assert(calls == 1 and accepted == true and not vim.api.nvim_win_is_valid(plan.window))
plan = Confirm.open(lines, 1, result)
press(plan.buffer, "q")
assert(calls == 2 and accepted == false)
plan = Confirm.open(lines, 1, result)
vim.api.nvim_win_close(plan.window, true)
assert(vim.wait(1000, function()
	return calls == 3
end))
assert(accepted == false)
assert(not picker.closed, "Dashboard must survive confirmation")
picker:close()
print(
	"PASS: real Snacks picker, mappings, in-place redraw, selection preservation, nested menu, scrollable pull confirmation"
)
vim.fn.delete(vim.fs.dirname(temp), "rf")
vim.cmd("qa!")
