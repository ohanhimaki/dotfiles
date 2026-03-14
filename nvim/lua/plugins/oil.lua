return {
  {
    "stevearc/oil.nvim",
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      keymaps = {
        ["q"] = "actions.close",
        ["m"] = "actions.select",

        ["<Tab>"] = "actions.preview",
        ["J"] = "actions.preview_scroll_down",
        ["K"] = "actions.preview_scroll_up",
      },
      view_options = {
        -- Show files and directories that start with "."
        show_hidden = true,
      },
    },
    config = function(_, opts)
      require("oil").setup(opts)
      --- Keymaps
      vim.keymap.set("n", "<leader>o", require("oil").open, { desc = "Open Oil" })
      vim.keymap.set("n", "_", require("oil").open, { desc = "Open Oil" })
    end,
    -- Optional dependencies
    dependencies = { { "nvim-mini/mini.icons", opts = {} } },
    -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
    -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
    lazy = false,
  },
}
