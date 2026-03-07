return {

  {
    "folke/which-key.nvim",
    lazy = false,
    -- keys = { "<leader>", "<c-w>", '"', "'", "`", "c", "v", "g" },
    -- cmd = "WhichKey",
    opts = function()
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
