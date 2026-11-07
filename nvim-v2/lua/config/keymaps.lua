local map = vim.keymap.set

map("i", "jk", "<Esc>", { desc = "Exit insert mode" })
map("i", "<C-b>", "<Esc>^i", { desc = "Move to beginning of line" })
map("i", "<C-e>", "<End>", { desc = "Move to end of line" })
map("i", "<C-h>", "<Left>", { desc = "Move left" })
map("i", "<C-l>", "<Right>", { desc = "Move right" })
map("i", "<C-BS>", "<C-w>", { desc = "Delete previous word" })
map("c", "<C-BS>", "<C-w>", { desc = "Delete previous word" })

map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })
map("n", "<leader>rn", "<cmd>set relativenumber!<CR>", { desc = "Toggle relative numbers" })
map("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Next buffer" })

map("n", "<C-h>", "<C-w><C-h>", { desc = "Focus left window" })
map("n", "<C-j>", "<C-w><C-j>", { desc = "Focus lower window" })
map("n", "<C-k>", "<C-w><C-k>", { desc = "Focus upper window" })
map("n", "<C-l>", "<C-w><C-l>", { desc = "Focus right window" })

-- Keep resizing until explicitly leaving the mode. No temporary mappings needed.
map("n", "<C-w>r", function()
	local actions = {
		h = "vertical resize -5",
		l = "vertical resize +5",
		j = "resize +2",
		k = "resize -2",
	}
	for arrow, key in pairs({ Left = "h", Right = "l", Down = "j", Up = "k" }) do
		actions[vim.api.nvim_replace_termcodes("<" .. arrow .. ">", true, false, true)] = actions[key]
	end
	local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
	while true do
		vim.api.nvim_echo({ { "Resize: h/j/k/l or arrows | Esc/q: exit", "ModeMsg" } }, false, {})
		vim.cmd("redraw")
		local ok, key = pcall(vim.fn.getcharstr)
		if not ok or key == esc or key == "q" then
			break
		end
		if actions[key] then
			vim.cmd(actions[key])
		end
	end
	vim.api.nvim_echo({ { "" } }, false, {})
end, { desc = "Enter window resize mode" })

map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
map("t", "<C-q>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Convenient previous/next aliases for a Scandinavian keyboard layout.
map("n", "gp", "[", { remap = true, desc = "Go previous" })
map("n", "å", "[", { remap = true, desc = "Go previous" })
map("n", "gn", "]", { remap = true, desc = "Go next" })
map("n", "¨", "]", { remap = true, desc = "Go next" })

map("n", "<leader>/", "gcc", { remap = true, desc = "Toggle comment" })
map("x", "<leader>/", "gc", { remap = true, desc = "Toggle comment" })

map("x", "J", ":move '>+1<CR>gv=gv", { desc = "Move selection down" })
map("x", "K", ":move '<-2<CR>gv=gv", { desc = "Move selection up" })

map("n", "<leader>ds", vim.diagnostic.setloclist, { desc = "Diagnostics to location list" })
map("n", "<leader>tdl", function()
  local enabled = vim.diagnostic.config().virtual_lines
  vim.diagnostic.config({ virtual_lines = not enabled })
end, { desc = "Toggle diagnostic virtual lines" })

map("n", "<leader>tdv", function()
  local enabled = vim.diagnostic.config().virtual_text
  vim.diagnostic.config({ virtual_text = not enabled })
end, { desc = "Toggle diagnostic virtual text" })

map("n", "<leader>tih", function()
  local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = 0 })
  vim.lsp.inlay_hint.enable(not enabled, { bufnr = 0 })
  vim.notify("Inlay hints " .. (enabled and "disabled" or "enabled"))
end, { desc = "Toggle inlay hints" })
