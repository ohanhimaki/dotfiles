return {
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 1000,
    opts = ...,
    config = function()
      vim.cmd.colorscheme "gruvbox"
    end,
  },

  {
    "mg979/vim-visual-multi",
    lazy = false,
  },

  {

    "akinsho/toggleterm.nvim",
    lazy = false,
    config = function()
      require("toggleterm").setup {
        -- Use PowerShell on Windows
        shell = vim.fn.has "win32" == 1 and "pwsh.exe" or vim.o.shell,
        direction = "float",
        float_opts = {
          border = "curved",
          winblend = 0,
        },
      }

      -- Single keymapping for float terminal (using Ctrl+\ which works reliably on Windows)
      vim.keymap.set({ "n", "t" }, "<C-g>", function()
        require("toggleterm").toggle()
      end, { noremap = true, silent = true, desc = "Toggle terminal float" })

      -- function _G.set_terminal_keymaps()
      --   local opts = { buffer = 0 }
      --   vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
      -- end
      --
      -- vim.cmd 'autocmd! TermOpen term://*toggleterm#* lua set_terminal_keymaps()'
    end,
  },
  {
    "kndndrj/nvim-dbee",
    cmd = { "Dbee" },
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("dbee").setup( --[[optional config]])
    end,
  },
  -- lazy.nvim
}
