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
        "razor"
      },
    },
  }, {
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
        "rzls",
        -- "csharp-language-server",
        -- "omnisharp",
      },
    },
  },
  {
    "seblyng/roslyn.nvim",
    ---@module 'roslyn.config'
    ---@type RoslynNvimConfig
    ft = { "cs", "razor" },
    opts = {
      -- your configuration comes here; leave empty for default settings
    },

    -- ADD THIS:

    dependencies = {
      {
        -- By loading as a dependencies, we ensure that we are available to set
        -- the handlers for Roslyn.
        "tris203/rzls.nvim",
        config = true,
      },
    },
    lazy = false,
    config = function()
  -- Use one of the methods in the Integration section to compose the command.
  local mason_registry = require "mason-registry"

  local rzls_path = vim.fn.expand "$MASON/packages/rzls/libexec"
  local cmd = {
    "roslyn",
    "--stdio",
    "--logLevel=Information",
    "--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path()),
    "--razorSourceGenerator=" .. vim.fs.joinpath(rzls_path, "Microsoft.CodeAnalysis.Razor.Compiler.dll"),
    "--razorDesignTimePath=" .. vim.fs.joinpath(rzls_path, "Targets", "Microsoft.NET.Sdk.Razor.DesignTime.targets"),
    "--extension",
    vim.fs.joinpath(rzls_path, "RazorExtension", "Microsoft.VisualStudioCode.RazorExtension.dll"),
  }

  vim.lsp.config("roslyn", {
    cmd = cmd,
    handlers = require "rzls.roslyn_handlers",
    settings = {
      ["csharp|inlay_hints"] = {
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
      ["csharp|code_lens"] = {
        dotnet_enable_references_code_lens = true,
      },
    },
  })
  vim.lsp.enable "roslyn"
    end,
    init = function()
  -- We add the Razor file types before the plugin loads.
  vim.filetype.add {
    extension = {
      razor = "razor",
      cshtml = "razor",
    },
  }
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
  "zbirenbaum/copilot.lua",
  lazy = false,
  config = function()
    require("copilot").setup({
      suggestion = {
        auto_trigger = true,
        keymap = {
          accept = "<C-a>",
          next = "<C-n>",
          prev = "<C-p>",
          dismiss = "<C-d>"
        }
      },
      panel = {
        enabled = true,
        auto_refresh = true
      }
    })
  end
 },
  {
    "nvim-neotest/neotest",
    requires = {
      {
        "Issafalcon/neotest-dotnet",
      }
    },
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter"
    }
  },
  {
    "Issafalcon/neotest-dotnet",
    lazy = false,
    dependencies = {
      "nvim-neotest/neotest"
    }
  },
 {
  "gelguy/wilder.nvim",
    lazy = false,
  config = function()
    local wilder = require("wilder")
    wilder.setup({
      modes = { ":", "/", "?" },
      next_key = "<Tab>",
      previous_key = "<S-Tab>",
      accept_key = "<Down>",
      reject_key = "<Up>",
    })

    wilder.set_option(
      "renderer",
      wilder.popupmenu_renderer(wilder.popupmenu_renderer({
        highlights = {
          border = "Normal",

        },
        border = "rounded",
      }))
    )
  end,
}, {
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
        { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" }
    }
} ,
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
  build = vim.fn.has("win32") ~= 0
      and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
      or "make",
  version = false,           -- älä aseta "*" — ohjeen mukaan
  event = "VeryLazy",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons",
    "zbirenbaum/copilot.lua",         -- jos haluat käyttää Copilot-providerina
    "stevearc/dressing.nvim",
    "folke/snacks.nvim",
  },
  opts = {
    provider = "copilot",            -- “copilot” provider määritys
    providers = {
      copilot = {
        -- kopilot-provider-asetukset, jos tarvitaan
        -- esim. timeout, extra_request_body jne.
      },
      -- voit määritellä myös muita provider-asetuksia
    },
    instructions_file = "avante.md",  -- projektikohtainen ohjetiedosto
    windows = {
      position = "right",             -- sivupalkin paikka
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
}
