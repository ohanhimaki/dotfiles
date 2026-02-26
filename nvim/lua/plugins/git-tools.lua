return {

  {
    "echasnovski/mini.diff",
    lazy = false,
    version = "*",
    config = function()
      require("mini.diff").setup {}
      -- disable
      -- vim.g.minidiff_disable = true
      vim.keymap.set("n", "<leader>gd", function()
        require("mini.diff").toggle_overlay()
      end, { noremap = true, silent = true, desc = "Toggle diff overlay" })
    end,
  },
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
      return {
        signs = {
          delete = { text = "󰍵" },
          changedelete = { text = "󱕖" },
        },
      }
    end,
  },
  {
    "kdheepak/lazygit.nvim",
    lazy = true,
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    -- optional for floating window border decoration
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    -- setting the keybinding for LazyGit with 'keys' is recommended in
    -- order to load the plugin when the command is run for the first time
    keys = {
      { "<leader>gg", "<cmd>LazyGit<cr>",                  desc = "LazyGit" },
      { "<leader>gc", "<cmd>LazyGitFilterCurrentFile<cr>", desc = "LazyGit current file" },
    },
  },
}
