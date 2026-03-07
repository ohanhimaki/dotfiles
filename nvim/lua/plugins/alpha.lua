return {
  "goolord/alpha-nvim",
  enabled = false,
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },

  config = function()
    local alpha = require "alpha"
    local startify = require "alpha.themes.startify"
    startify.section.header.val = {}
    startify.section.top_buttons.val = {
      startify.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
      startify.button("o", "  Oil", ":Oil<CR>"),
    }
    startify.section.bottom_buttons.val = {
      startify.button("q", "󰅚  Quit NVIM", ":qa<CR>"),
    }
    startify.section.footer.val = {
      { type = "text", val = "footer" },
    }
    -- ignore filetypes in MRU

    alpha.setup(startify.config)
  end,
}
