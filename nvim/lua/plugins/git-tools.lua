return {

  {
    "echasnovski/mini.diff",
    lazy = false,
    version = "*",
    config = function()
      require("mini.diff").setup {
        view = {
          style = "sign",
          signs = { add = "▎", change = "▎", delete = "▎" },
        },
      }
      vim.keymap.set("n", "<leader>gd", function()
        require("mini.diff").toggle_overlay()
      end, { noremap = true, silent = true, desc = "Toggle diff overlay" })
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    event = "User FilePost",
    opts = function()
      dofile(vim.g.base46_cache .. "git")

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
      { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
      { "<leader>gc", "<cmd>LazyGitFilterCurrentFile<cr>", desc = "LazyGit current file" },
    },
  },
}
