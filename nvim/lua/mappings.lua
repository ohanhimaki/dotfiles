local map = vim.keymap.set

map("i", "<C-b>", "<ESC>^i", { desc = "move beginning of line" })
map("i", "<C-e>", "<End>", { desc = "move end of line" })
map("i", "<C-h>", "<Left>", { desc = "move left" })
map("i", "<C-l>", "<Right>", { desc = "move right" })

-- map("n", "<C-h>", "<C-w>h", { desc = "switch window left" })
-- map("n", "<C-l>", "<C-w>l", { desc = "switch window right" })
-- map("n", "<C-j>", "<C-w>j", { desc = "switch window down" })
-- map("n", "<C-k>", "<C-w>k", { desc = "switch window up" })

-- map("n", "<Esc>", "<cmd>noh<CR>", { desc = "general clear highlights" })
--
-- map("n", "<C-s>", "<cmd>w<CR>", { desc = "general save file" })
-- map("n", "<C-c>", "<cmd>%y+<CR>", { desc = "general copy whole file" })

-- map("n", "<leader>n", "<cmd>set nu!<CR>", { desc = "toggle line number" })
map("n", "<leader>rn", "<cmd>set rnu!<CR>", { desc = "toggle relative number" })

map({ "n", "x" }, "<leader>fm", function()
  require("conform").format { lsp_fallback = true }
end, { desc = "general format file" })

-- global lsp mappings
map("n", "<leader>ds", vim.diagnostic.setloclist, { desc = "LSP diagnostic loclist" })

vim.keymap.set("n", "<leader>tdl", function()
  local new_config = not vim.diagnostic.config().virtual_lines
  vim.diagnostic.config { virtual_lines = new_config }
end, { desc = "Toggle diagnostic virtual_lines" })

vim.keymap.set("n", "<leader>tdv", function()
  local new_config = not vim.diagnostic.config().virtual_text
  vim.diagnostic.config { virtual_text = new_config }
end, { desc = "Toggle diagnostic virtual_lines" })

-- tabufline

-- Comment
map("n", "<leader>/", "gcc", { desc = "toggle comment", remap = true })
map("v", "<leader>/", "gc", { desc = "toggle comment", remap = true })

-- nvimtree
map("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "nvimtree toggle window" })
-- map("n", "<leader>e", "<cmd>NvimTreeFocus<CR>", { desc = "nvimtree focus window" })
map("n", "<leader>e", function()
  Snacks.explorer()
end, { desc = "Snacks explorer" })

-- terminal
map("t", "<C-x>", "<C-\\><C-N>", { desc = "terminal escape terminal mode" })

-- whichkey
map("n", "<leader>wK", "<cmd>WhichKey <CR>", { desc = "whichkey all keymaps" })

map("n", "<leader>wk", function()
  vim.cmd("WhichKey " .. vim.fn.input "WhichKey: ")
end, { desc = "whichkey query lookup" })

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- Map LSP actions
map("n", "<C-.>", vim.lsp.buf.code_action, { desc = "Code Action" })
map("n", "<C-k>", vim.lsp.buf.hover, { desc = "LSP Hover Details" })

-- Terminal key mappings for Kitty
-- vim.api.nvim_set_keymap('i', '<C-H>', '<C-W>', { noremap = true })
-- vim.api.nvim_set_keymap('i', '<C-BS>', '<C-W>', { noremap = true, silent = true })
map("i", "<C-H>", "<C-W>", { noremap = true })
map("i", "<C-BS>", "<C-W>", { noremap = true, silent = true })

-- Insert mode: delete word backward
map("i", "<C-BS>", "<C-W>", { desc = "Delete word backward" })

-- Normal mode: delete word backward (like 'db' command)
map("n", "<C-BS>", "db", { desc = "Delete word backward in normal mode" })

-- Command mode: delete word backward
map("c", "<C-BS>", "<C-W>", { desc = "Delete word backward in command mode" })

-- vim.lsp.inlay_hint.enable() toggle by <leader>tih
map("n", "<Leader>tih", function()
  local is_enabled = vim.lsp.inlay_hint.is_enabled()
  vim.lsp.inlay_hint.enable(not is_enabled)
  print("Inlay hints " .. (is_enabled and "disabled" or "enabled"))
end, { desc = "Toggle Inlay Hints" })

vim.keymap.set("n", "<leader>q", function()
  require("quicker").toggle()
end, {
  desc = "Toggle quickfix",
})
vim.keymap.set("n", "<leader>l", function()
  require("quicker").toggle { loclist = true }
end, {
  desc = "Toggle loclist",
})

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode

-- DAP (Debugging) keybindings - Rider style

vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

vim.keymap.set("n", "gp", "[", { remap = true, desc = "Go prev" })
vim.keymap.set("n", "gn", "]", { remap = true, desc = "Go next" })

vim.keymap.set("n", "<leader><leader>", "<C-^>", { desc = "Previous buffer" })

-- Markdown checkbox toggle
vim.keymap.set("n", "<leader>mc", function()
  local line = vim.api.nvim_get_current_line()
  local new_line = line

  if line:match "^%s*- %[ %]" then
    new_line = line:gsub("^(%s*- )%[ %]", "%1[x]")
  elseif line:match "^%s*- %[x%]" or line:match "^%s*- %[X%]" then
    new_line = line:gsub("^(%s*- )%[[xX]%]", "%1[ ]")
  end

  if new_line ~= line then
    vim.api.nvim_set_current_line(new_line)
  end
end, { desc = "Toggle markdown checkbox" })
