require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")


map("n", "<leader>cc", "<cmd>CopilotChat<cr>", { desc = "Run CopilotChat" })


vim.api.nvim_set_keymap('i', '<C-H>', '<C-W>', { noremap = true })
