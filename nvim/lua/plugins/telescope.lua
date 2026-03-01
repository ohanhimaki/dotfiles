return {

  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
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
      local telescopebuiltin = require "telescope.builtin"
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

      map("<leader>fa", "<cmd>Seeker files<CR>", " seeker files")
      map("<leader>ff", "<cmd>Seeker git_files<CR>", " seeker git files")
      map("<leader>fw", "<cmd>Seeker grep<CR>", " seeker grep")
      map("<leader>fp", function()
        require("telescope").extensions.frecency.frecency {
          workspace = "CWD",
          default_text = "",
        }
      end, "telescope Frecency CWD")

      -- todo: search from nvim config dir
      map("<leader>fc", function()
        telescopebuiltin.find_files {
          cwd = vim.fn.stdpath "config",
        }
      end, " find nvim config")
      -- todo: search from lazy appdata dir
      map("<leader>fl", function()
        telescopebuiltin.find_files {
          cwd = vim.fn.stdpath "data" .. "/lazy",
        }
      end, " find lazy appdata")
    end,
  },
}
