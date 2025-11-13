require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")


map("n", "<leader>cc", "<cmd>CopilotChat<cr>", { desc = "Run CopilotChat" })

-- Map LSP actions
map("n", "<C-.>", vim.lsp.buf.code_action, { desc = "Code Action" })
map("n", "<C-k>", vim.lsp.buf.hover, { desc = "LSP Hover Details" })
-- VCS Commands (Added per Rider mapping comparison)
map("n", "<Leader>gn", ":Gitsigns next_hunk<CR>", { desc = "Next VCS Change" })
map("n", "<Leader>gr", ":Gitsigns reset_hunk<CR>", { desc = "Rollback Change" })

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


-- vim.lsp.inlay_hint.enable() toggle by  <leader>th
map("n", "<Leader>th", function()
  local clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
  for _, client in ipairs(clients) do
    if client.server_capabilities.inlayHintProvider then
      vim.lsp.inlay_hint(0, not vim.lsp.inlay_hint.is_enabled())
      print("Toggled inlay hints for", client.name)
      return
    end
  end
  print("Inlay hints not supported by active LSP servers.")
end, { desc = "Toggle Inlay Hints" })



