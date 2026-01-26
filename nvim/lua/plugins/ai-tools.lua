return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup {
        suggestion = {
          auto_trigger = true,
          keymap = {
            accept = "<C-w>",
            next = "<C-n>",
            prev = "<C-p>",
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
    end,
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
      "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
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
        hint_display = "none",
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
