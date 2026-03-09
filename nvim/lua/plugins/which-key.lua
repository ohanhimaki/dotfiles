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
      return {
        preset = "helix",
        sort = { "local", "order", "group", "desc", "alphanum", "mod" },
      }
    end,

    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show { global = false }
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },
}
