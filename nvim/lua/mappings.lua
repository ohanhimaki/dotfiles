require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")


map("n", "<leader>cc", "<cmd>CopilotChat<cr>", { desc = "Run CopilotChat" })

-- Terminal key mappings for Kitty
vim.api.nvim_set_keymap('i', '<C-H>', '<C-W>', { noremap = true })
vim.api.nvim_set_keymap('i', '<C-BS>', '<C-W>', { noremap = true, silent = true })

-- Insert mode: delete word backward
map("i", "<C-BS>", "<C-W>", { desc = "Delete word backward" })

-- Normal mode: delete word backward (like 'db' command)
map("n", "<C-BS>", "db", { desc = "Delete word backward in normal mode" })

-- Command mode: delete word backward
map("c", "<C-BS>", "<C-W>", { desc = "Delete word backward in command mode" })
