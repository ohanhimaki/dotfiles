return {


  {
    "lukas-reineke/indent-blankline.nvim",
    event = "User FilePost",
    opts = {
      indent = { char = "│", highlight = "IblChar" },
      scope = { char = "│", highlight = "IblScopeChar" },
    },
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "blankline")

      local hooks = require "ibl.hooks"
      hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
      require("ibl").setup(opts)

      dofile(vim.g.base46_cache .. "blankline")
    end,
  },

  {
    "mg979/vim-visual-multi",
    lazy = false,
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      {
        "s",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash",
      },
      {
        "S",
        mode = { "n", "x", "o" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
    },
  },

{

  'akinsho/toggleterm.nvim',
    lazy = false,
  config = function()
    require('toggleterm').setup({
      -- Use PowerShell on Windows
      shell = vim.fn.has('win32') == 1 and 'pwsh.exe' or vim.o.shell,
      direction = 'float',
      float_opts = {
        border = 'curved',
        winblend = 0,
      },
    })

    -- Single keymapping for float terminal (using Ctrl+\ which works reliably on Windows)
    vim.keymap.set({ 'n', 't' }, '<C-g>', function()
      require('toggleterm').toggle()
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
  lazy = false,
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  config = function()
    require("dbee").setup(--[[optional config]])
  end,
},
-- lazy.nvim
}
