return {

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
}
