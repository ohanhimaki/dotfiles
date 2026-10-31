return {
  {
    "nvim-mini/mini.nvim",
    lazy = false,
    config = function()
      require("mini.ai").setup()
      require("mini.diff").setup()
      require("mini.files").setup({
        mappings = {
          go_in_plus = "<CR>",
          synchronize = "s",
        },
      })
      require("mini.git").setup()
      require("mini.jump").setup()
      require("mini.move").setup()
      require("mini.pairs").setup()
      require("mini.statusline").setup()
      require("mini.surround").setup()
      require("mini.tabline").setup()
    end,
    keys = {
      {
        "<leader>E",
        function()
          local path = vim.api.nvim_buf_get_name(0)
          MiniFiles.open(path ~= "" and path or nil, false)
        end,
        desc = "MiniFiles",
      },
      {
        "<leader>gd",
        function()
          MiniDiff.toggle_overlay()
        end,
        desc = "Toggle Git diff overlay",
      },
    },
  },
}
