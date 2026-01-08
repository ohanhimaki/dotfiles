return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },
  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
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
      },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = {
      registries = {
        "github:mason-org/mason-registry",
        "github:Crashdummyy/mason-registry",
      },
      ensure_installed = {
        "lua-language-server",
        "xmlformatter",
        "csharpier",
        "prettier",
        "stylua",
        "bicep-lsp",
        "html-lsp",
        "css-lsp",
        "eslint-lsp",
        "typescript-language-server",
        "json-lsp",
        "rust-analyzer",
        "roslyn",
        -- "csharp-language-server",
        -- "omnisharp",
      },
    },
  },
  {
  'seblyng/roslyn.nvim',
  lazy = false,
  dependencies = {
    {
      'mason-org/mason.nvim',
      opts = {
        registries = {
          'github:mason-org/mason-registry',
          'github:crashdummyy/mason-registry',
        },
      },
    },
  },
  opts = {
    broad_search = true,
    filewatching = 'roslyn',
  },
  config = function()
    vim.lsp.config('roslyn', {
      settings = {
        ['csharp|inlay_hints'] = {
          csharp_enable_inlay_hints_for_implicit_object_creation = true,
          csharp_enable_inlay_hints_for_implicit_variable_types = true,

          csharp_enable_inlay_hints_for_lambda_parameter_types = true,
          csharp_enable_inlay_hints_for_types = true,
          dotnet_enable_inlay_hints_for_indexer_parameters = true,
          dotnet_enable_inlay_hints_for_literal_parameters = true,
          dotnet_enable_inlay_hints_for_object_creation_parameters = true,
          dotnet_enable_inlay_hints_for_other_parameters = true,
          dotnet_enable_inlay_hints_for_parameters = true,
          dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
          dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
          dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
        },
        ['csharp|code_lens'] = {
          dotnet_enable_references_code_lens = true,
        },
        ['csharp|completion'] = {
          dotnet_provide_regex_completions = true,
          dotnet_show_name_completion_suggestions = true,
          dotnet_show_completion_items_from_unimported_namespaces = true,
        },
        ['csharp|formatting'] = {
          dotnet_organize_imports_on_format = true,
        },
        ['csharp|background_analysis'] = {
          background_analysis = {
            dotnet_analyzer_diagnostics_scope = 'fullSolution',
            dotnet_compiler_diagnostics_scope = 'fullSolution',
          },
        },
      },
    })
    vim.lsp.enable 'roslyn'
  end,
},
  -- {
  --   -- Debug Framework
  --   "mfussenegger/nvim-dap",
  --   dependencies = {
  --     "rcarriga/nvim-dap-ui",
  --   },
  --   config = function()
  --     require "configs.nvim-dap"
  --   end,
  --   event = "VeryLazy",
  -- },
  -- { "nvim-neotest/nvim-nio" },
  -- {
  --   -- UI for debugging
  --   "rcarriga/nvim-dap-ui",
  --   dependencies = {
  --     "mfussenegger/nvim-dap",
  --   },
  --   config = function()
  --     require "configs.nvim-dap-ui"
  --   end,
  -- },
  {
    "zbirenbaum/copilot.lua",
    lazy = false,
    config = function()
      require("copilot").setup {
        suggestion = {
          auto_trigger = true,
          keymap = {
            accept = "<C-a>",
            next = "<C-n>",
            prev = "<C-p>",
            dismiss = "<C-d>",
          },
        },
        panel = {
          enabled = true,
          auto_refresh = true,
        },
      }
    end,
  },
  {
    "nvim-neotest/neotest",
    requires = {
      {
        "Issafalcon/neotest-dotnet",
      },
    },
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
  },
  {
    "Issafalcon/neotest-dotnet",
    lazy = false,
    dependencies = {
      "nvim-neotest/neotest",
    },
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
  {
    "kdheepak/lazygit.nvim",
    lazy = true,
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    -- optional for floating window border decoration
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    -- setting the keybinding for LazyGit with 'keys' is recommended in
    -- order to load the plugin when the command is run for the first time
    keys = {
      { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
      { "<leader>gc", "<cmd>LazyGitFilterCurrentFile<cr>", desc = "LazyGit current file" },
    },
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
    "yetone/avante.nvim",
    build = vim.fn.has "win32" ~= 0 and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
      or "make",
    version = false, -- älä aseta "*" — ohjeen mukaan
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
      "zbirenbaum/copilot.lua", -- jos haluat käyttää Copilot-providerina
      "stevearc/dressing.nvim",
      "folke/snacks.nvim",
    },
    opts = {
      provider = "copilot", -- “copilot” provider määritys
      providers = {
        copilot = {
          -- kopilot-provider-asetukset, jos tarvitaan
          -- esim. timeout, extra_request_body jne.
          model = "claude-sonnet-4.5",
        },
        -- voit määritellä myös muita provider-asetuksia
      },
      instructions_file = "avante.md", -- projektikohtainen ohjetiedosto
      windows = {
        position = "right", -- sivupalkin paikka
        width = 30,
        wrap = true,
      },
      selection = {
        enabled = true,
        hint_display = "delayed",
      },
      -- lisäasetuksia voit määritellä täällä…
    },
    config = function(_, opts)
      require("avante").setup(opts)
      -- Esimerkiksi custom keybindings
      vim.api.nvim_set_keymap("n", "<leader>aa", "<cmd>AvanteAsk<CR>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("n", "<leader>ae", "<cmd>AvanteEdit<CR>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("n", "<leader>ar", "<cmd>AvanteRefresh<CR>", { noremap = true, silent = true })
    end,
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
    "lewis6991/satellite.nvim",
    event = "VeryLazy",
    opts = {
      current_only = false,
      winblend = 50,
      zindex = 40,
      excluded_filetypes = {},
      width = 2,
      handlers = {
        cursor = {
          enable = true,
        },
        diagnostic = {
          enable = true,
        },
        gitsigns = {
          enable = true,
        },
        marks = {
          enable = true,
          show_builtins = false,
        },
        search = {
          enable = true,
        },
      },
    },
  },
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
  opts = {},
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
}
