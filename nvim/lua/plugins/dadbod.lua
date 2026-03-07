return {
  {
    "tpope/vim-dadbod",
    dependencies = {
      "kristijanhusak/vim-dadbod-ui",
      "kristijanhusak/vim-dadbod-completion",
    },
    cmd = { "DBUI", "DBUIToggle" },
    keys = {
      { "<leader>db", "<cmd>DBUIToggle<cr>", desc = "Toggle DB UI" },
    },
    config = function()
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_save_location = vim.fn.stdpath "data" .. "/db_ui"

      vim.g.db_ui_table_helpers = {
        duckdb = {
          List = "SELECT table_schema, table_name FROM information_schema.tables ORDER BY 1, 2",
          Describe = "DESCRIBE {schema}.{table}",
          Count = "SELECT COUNT(*) FROM {schema}.{table}",
          Sample = "SELECT * FROM {schema}.{table} LIMIT 200",
        },
      }

      -- Microsoft Fabric SQL endpoints (Azure AD SSO)
      -- Vaatii: go-sqlcmd (winget install Microsoft.Sqlcmd) + az login
      -- vim.g.dbs = {
      --   {
      --     name = "Fabric - MyWarehouse",
      --     url = "sqlserver://tyopaikkasi.datawarehouse.fabric.microsoft.com/TietokantaNimi?authentication=ActiveDirectoryDefault",
      --   },
      --   {
      --     name = "Fabric - MyLakehouse",
      --     url = "sqlserver://tyopaikkasi.datawarehouse.fabric.microsoft.com/LakehouseNimi?authentication=ActiveDirectoryDefault",
      --   },
      -- }
    end,
  },
}
