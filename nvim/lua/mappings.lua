require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- Map LSP actions
map("n", "<C-.>", vim.lsp.buf.code_action, { desc = "Code Action" })
map("n", "<C-k>", vim.lsp.buf.hover, { desc = "LSP Hover Details" })
-- VCS Commands (Added per Rider mapping comparison)
map("n", "<Leader>gn", ":Gitsigns next_hunk<CR>", { desc = "Next VCS Change" })
map("n", "<Leader>gr", ":Gitsigns reset_hunk<CR>", { desc = "Rollback Change" })
-- gitsigns blame with leader g b 
map("n", "<leader>gl", "<cmd>Gitsigns blame_line<cr>", { desc = "Git blame line" })
map("n", "<leader>gb", "<cmd>Gitsigns blame<cr>", { desc = "Git blame" })

-- Terminal key mappings for Kitty
-- vim.api.nvim_set_keymap('i', '<C-H>', '<C-W>', { noremap = true })
-- vim.api.nvim_set_keymap('i', '<C-BS>', '<C-W>', { noremap = true, silent = true })
map('i', '<C-H>', '<C-W>', { noremap = true })
map('i', '<C-BS>', '<C-W>', { noremap = true, silent = true })

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





map("n", "<leader>fp", "<cmd>Telescope frecency workspace=CWD<cr>", { desc = "telescope Frecency CWD" })
map("n", "<leader>fk", "<cmd>Telescope keymaps<cr>", { desc = "telescope keymaps" })
-- telescope code errors


vim.keymap.set("n", "<leader>q", function()
  require("quicker").toggle()
end, {
  desc = "Toggle quickfix",
})
vim.keymap.set("n", "<leader>l", function()
  require("quicker").toggle({ loclist = true })
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
map("n", "<F9>", "<cmd>lua require('dap').toggle_breakpoint()<CR>", { desc = "Toggle Breakpoint" })
map("n", "<F5>", "<cmd>lua require('dap').continue()<CR>", { desc = "Debug Continue/Start" })
map("n", "<F10>", "<cmd>lua require('dap').step_over()<CR>", { desc = "Debug Step Over" })
map("n", "<F11>", "<cmd>lua require('dap').step_into()<CR>", { desc = "Debug Step Into" })
map("n", "<S-F11>", "<cmd>lua require('dap').step_out()<CR>", { desc = "Debug Step Out" })
map("n", "<S-F5>", "<cmd>lua require('dap').terminate()<CR>", { desc = "Debug Stop" })

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
