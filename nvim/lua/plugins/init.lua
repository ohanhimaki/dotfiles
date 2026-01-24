return {

  "nvim-lua/plenary.nvim",

  {
    "nvchad/base46",
    build = function()
      require("base46").load_all_highlights()
    end,
  },

  {
    "nvchad/ui",
    lazy = false,
    config = function()
      require "nvchad"
    end,
  },

  "nvzone/volt",
  "nvzone/menu",
  { "nvzone/minty", cmd = { "Huefy", "Shades" } },

  {
    "nvim-tree/nvim-web-devicons",
    opts = function()
      dofile(vim.g.base46_cache .. "devicons")
      return {}
    end,
  },

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

  -- file managing , picker etc
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    opts = function()
      return require "configs.nvimtree"
    end,
  },

  {
    "folke/which-key.nvim",
    keys = { "<leader>", "<c-w>", '"', "'", "`", "c", "v", "g" },
    cmd = "WhichKey",
    opts = function()
      dofile(vim.g.base46_cache .. "whichkey")
      return {}
    end,
  },

  -- formatting!
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        -- python = { "ruff_format", "ruff_organize_imports" },
        -- css = { "prettier" },
        -- html = { "prettier" },
      }
    }
  },

  -- lsp stuff


  -- load luasnips + cmp related in insert mode only
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      {
        -- snippet plugin
        "L3MON4D3/LuaSnip",
        dependencies = "rafamadriz/friendly-snippets",
        opts = { history = true, updateevents = "TextChanged,TextChangedI" },
        config = function(_, opts)
          require("luasnip").config.set_config(opts)
          require "configs.luasnip"
        end,
      },

      -- autopairing of (){}[] etc
      {
        "windwp/nvim-autopairs",
        opts = {
          fast_wrap = {},
          disable_filetype = { "TelescopePrompt", "vim" },
        },
        config = function(_, opts)
          require("nvim-autopairs").setup(opts)

          -- setup cmp for autopairs
          local cmp_autopairs = require "nvim-autopairs.completion.cmp"
          require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
      },

      -- cmp sources plugins
      {
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
       "https://codeberg.org/FelipeLema/cmp-async-path.git",
      },
    },
    opts = function()
      return require "configs.cmp"
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    cmd = "Telescope",
    opts = function()
      return require "configs.telescope"
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    build = ":TSUpdate | TSInstallAll",
    opts = function()
      local base_opts = require "configs.treesitter"
      base_opts.ensure_installed = {
        "hyprlang",
        "vim",
        "lua",
        "vimdoc",
        "html",
        "css",
        "c_sharp",
        "razor",
        "javascript",
        "typescript",
        "tsx",
      }
      return base_opts
    end,
  },
  {
    -- Debug Framework
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
    },
    config = function()
      require "configs.nvim-dap"
    end,
    event = "VeryLazy",
  },
  { "nvim-neotest/nvim-nio" },
  {
    -- UI for debugging
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    config = function()
      require "configs.nvim-dap-ui"
    end,
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "Issafalcon/neotest-dotnet",
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-dotnet")
        }
      })
    end,
  },
  {
    "gelguy/wilder.nvim",
    lazy = false,
    config = function()
      local wilder = require "wilder"
      wilder.setup {
        modes = { ":", "/", "?" },
        next_key = "<Tab>",
        previous_key = "<S-Tab>",
        accept_key = "<Down>",
        reject_key = "<Up>",
      }

      wilder.set_option(
        "renderer",
        wilder.popupmenu_renderer(wilder.popupmenu_renderer {
          highlights = {
            border = "Normal",
          },
          border = "rounded",
        })
      )
    end,
  },
  --   {
  --   'github/copilot.vim'
  --   , lazy = false
  -- },
  -- {
  --   "CopilotC-Nvim/CopilotChat.nvim",
  --     lazy = false,
  --   dependencies = {
  --     { "nvim-lua/plenary.nvim", branch = "master" },
  --   },
  --   -- build = "make tiktoken",
  --   opts = {
  --     -- See Configuration section for options
  --   },
  -- },
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
  -- {
  --   "lewis6991/satellite.nvim",
  --   event = "VeryLazy",
  --   opts = {
  --     current_only = true,
  --     winblend = 50,
  --     zindex = 40,
  --     excluded_filetypes = {},
  --     width = 2,
  --     handlers = {
  --       cursor = {
  --         enable = true,
  --       },
  --       diagnostic = {
  --         enable = true,
  --       },
  --       gitsigns = {
  --         enable = true,
  --       },
  --       marks = {
  --         enable = true,
  --         show_builtins = false,
  --       },
  --       search = {
  --         enable = true,
  --       },
  --     },
  --   },
  -- },
{
  "nvim-telescope/telescope-frecency.nvim",
  -- install the latest stable version
  version = "*",
    lazy = false,
    
  config = function()
  require("telescope").load_extension "frecency"
  end,
},
{
  'stevearc/quicker.nvim',
  ft = "qf",
  ---@module "quicker"
  ---@type quicker.SetupOptions
  opts = {},
    config = function()
      require("quicker").setup ({
  keys = {
    {
      ">",
      function()
        require("quicker").expand({ before = 2, after = 2, add_to_existing = true })
      end,
      desc = "Expand quickfix context",
    },
    {
      "<",
      function()
        require("quicker").collapse()
      end,
      desc = "Collapse quickfix context",
    },
  },
      })
    end,
},
{
  'stevearc/oil.nvim',
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
    keymaps = {
      ["q"] = "actions.close",
    },
  },
    config = function(_, opts)
      require("oil").setup(opts)
      --- Keymaps
      vim.keymap.set("n", "<leader>o", require("oil").open, { desc = "Open Oil" })
    end,
  -- Optional dependencies
  dependencies = { { "nvim-mini/mini.icons", opts = {} } },
  -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
  -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
  lazy = false,
}, {

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
{ 'echasnovski/mini.diff',
    lazy = false,
    version = '*',
    config = function()
      require('mini.diff').setup({
        view = {
          style = 'sign',
          signs = { add = '▎', change = '▎', delete = '▎' },
        },
      })
      vim.keymap.set('n', '<leader>gd', function()
        require('mini.diff').toggle_overlay()
      end, { noremap = true, silent = true, desc = "Toggle diff overlay" })
    end,
},
-- lazy.nvim
}
