return {

  {
    "lewis6991/gitsigns.nvim",
    event = "User FilePost",
    opts = function()
      -- VCS Commands (Added per Rider mapping comparison)
      vim.keymap.set("n", "<Leader>gn", ":Gitsigns next_hunk<CR>", { desc = "Git Next VCS Change" })
      vim.keymap.set("n", "<Leader>gr", ":Gitsigns reset_hunk<CR>", { desc = "Git Rollback Change" })
      vim.keymap.set("n", "<Leader>gs", ":Gitsigns stage_hunk<CR>", { desc = "Git Stage Hunk" })
      vim.keymap.set("n", "<Leader>gf", ":Gitsigns stage_buffer<CR>", { desc = "Git Stage File" })
      -- gitsigns blame with leader g b
      vim.keymap.set("n", "<leader>gl", "<cmd>Gitsigns blame_line<cr>", { desc = "Git blame line" })
      vim.keymap.set("n", "<leader>gb", "<cmd>Gitsigns blame<cr>", { desc = "Git blame" })
      vim.keymap.set("n", "<leader>gd", "<cmd>Gitsigns preview_hunk_inline<cr>", { desc = "GitSigns toggle diff" })
      return {
        signs = {
          delete = { text = "󰍵" },
          changedelete = { text = "󱕖" },
        },
      }
    end,
  },
  {
    "esmuellert/codediff.nvim", -- optional
    cmd = "CodeDiff",
  },
}
