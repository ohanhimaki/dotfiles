vim.pack.add({
  "https://github.com/zbirenbaum/copilot.lua"
})
require("copilot").setup {
  suggestion = {
    auto_trigger = true,
    keymap = {
      accept = "<C-w>",
      dismiss = "<C-d>",
    },
  },
  panel = {
    enabled = true,
    auto_refresh = true,
  },
  nes = {
    enabled = false, -- requires copilot-lsp as a dependency
    auto_trigger = false,
    keymap = {
      accept_and_goto = false,
      accept = false,
      dismiss = false,
    },
  },
}
