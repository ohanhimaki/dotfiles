
vim.pack.add({ "https://github.com/folke/which-key.nvim" })

require("which-key").setup({
        preset = "helix",
        sort = { "local", "order", "group", "desc", "alphanum", "mod" },
})
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
  {
    "å",
    proxy = "[",
    desc = "Go prev",
  },
  {
    "¨",
    proxy = "]",
    desc = "Go next",
  },
}
