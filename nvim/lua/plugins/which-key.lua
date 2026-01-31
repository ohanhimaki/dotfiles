return {

  {
    "folke/which-key.nvim",
    keys = { "<leader>", "<c-w>", '"', "'", "`", "c", "v", "g" },
    cmd = "WhichKey",
    opts = function()
      dofile(vim.g.base46_cache .. "whichkey")

      require("which-key").add {
        {
          "gp",
          proxy = "[",
          desc = "Go prev",
        },
        {
          "gn",
          proxy = "]",
          desc = "Go next",
        },
      }
      return {}
    end,
  },
}
