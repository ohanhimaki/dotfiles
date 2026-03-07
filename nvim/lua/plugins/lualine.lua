return {
  {
    "nvim-lualine/lualine.nvim",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local function cwd_relative_path()
        local cwd = vim.fn.getcwd()
        local filepath = vim.fn.expand "%:p"
        local cwd_name = vim.fn.fnamemodify(cwd, ":t")
        local relative = vim.fn.fnamemodify(filepath, ":.")
        return cwd_name .. "/" .. relative
      end

      local function lsp_clients()
        local clients = vim.lsp.get_clients { bufnr = 0 }
        if #clients == 0 then return "" end
        local names = {}
        for _, c in ipairs(clients) do
          table.insert(names, c.name)
        end
        return " " .. table.concat(names, " ")
      end

      require("lualine").setup {
        options = {
          theme = "gruvbox",
          globalstatus = true,
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = { statusline = { "dashboard", "snacks_dashboard" } },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff" },
          lualine_c = { { cwd_relative_path, path = 0 } },
          lualine_x = { "diagnostics", lsp_clients, "filetype" },
          lualine_y = { "searchcount", "progress" },
          lualine_z = { "location" },
        },
        inactive_sections = {
          lualine_c = { { cwd_relative_path } },
          lualine_x = { "location" },
        },
      }
    end,
  },
}
