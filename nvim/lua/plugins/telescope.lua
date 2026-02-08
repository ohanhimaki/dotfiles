return {

  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      {
        "nvim-telescope/telescope-frecency.nvim",
        -- install the latest stable version
        version = "*",
        cmd = { "Telescope" },

        config = function()
          require("telescope").load_extension "frecency"
        end,
      },
      {
        "2kabhishek/seeker.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        cmd = { "Seeker" },
        opts = {
          picker_provider = "telescope",
        },
      },
    },
    cmd = "Telescope",
    opts = function()
      return {
        defaults = {
          prompt_prefix = "   ",
          selection_caret = " ",
          entry_prefix = " ",
          sorting_strategy = "ascending",
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width = 0.55,
            },
            width = 0.87,
            height = 0.80,
          },
          mappings = {
            n = { ["q"] = require("telescope.actions").close },
          },
        },

        extensions_list = {},
        extensions = {},
        pickers = {
          buffers = {

            sort_lastused = true,
            ignore_current_buffer = true,
          },
        },
      }
    end,
    config = function(_, opts)
      local telescope = require "telescope"
      telescope.setup(opts)

      for _, ext in ipairs(opts.extensions_list) do
        telescope.load_extension(ext)
      end

      local map = function(lhs, rhs, desc)
        vim.keymap.set("n", lhs, rhs, { desc = "telescope " .. desc })
      end
      map("<leader>fk", "<cmd>Telescope keymaps<cr>", " keymaps")
      map("<leader>fb", "<cmd>Telescope buffers<CR>", " find buffers")
      map("<leader>fh", "<cmd>Telescope help_tags<CR>", " help page")
      map("<leader>fgg", "<cmd>Telescope git_status<CR>", " git status")
      map("<leader>fgr", "<cmd>Telescope git_bcommits_range<CR>", " git commits range")
      map("<leader>fgr", "<cmd>Telescope git_bcommits<CR>", " git commits file")
      map("<leader>ma", "<cmd>Telescope marks<CR>", " find marks")
      map("<leader>fo", "<cmd>Telescope oldfiles<CR>", " find oldfiles")
      map("<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<CR>", " find in current buffer")
      map("<leader>cm", "<cmd>Telescope git_commits<CR>", " git commits")
      map("<leader>gt", "<cmd>Telescope git_status<CR>", " git status")
      map("<leader>pt", "<cmd>Telescope terms<CR>", " pick hidden term")

      -- keys = {
      --   { "<leader>fa", ":Seeker files<CR>",     desc = "Seek Files" },
      --   { "<leader>ff", ":Seeker git_files<CR>", desc = "Seek Git Files" },
      --   { "<leader>fw", ":Seeker grep<CR>",      desc = "Seek Grep" },
      -- },
      map("<leader>fa", "<cmd>Seeker files<CR>", " seeker files")
      map("<leader>ff", "<cmd>Seeker git_files<CR>", " seeker git files")
      map("<leader>fw", "<cmd>Seeker grep<CR>", " seeker grep")
      -- map("<leader>ff", "<cmd>Telescope find_files<cr>", " find files")
      -- map("<leader>fa", "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>", " find all files")
      -- map("<leader>fw", "<cmd>Telescope live_grep<CR>", " live grep")
      map("<leader>fp", function()
        require("telescope").extensions.frecency.frecency {
          workspace = "CWD",
          default_text = "",
        }
      end, "telescope Frecency CWD")
    end,
  },
}
