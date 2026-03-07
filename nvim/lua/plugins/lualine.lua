return {
  {
    "nvim-lualine/lualine.nvim",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local function lsp_clients()
        local clients = vim.lsp.get_clients { bufnr = 0 }
        if #clients == 0 then
          return ""
        end
        local names = {}
        for _, c in ipairs(clients) do
          table.insert(names, c.name)
        end
        return " " .. table.concat(names, " ")
      end

      local function cwd_name()
        return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
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
          lualine_c = {
            { cwd_name, color = { fg = "#a89984" } },
            { "filename", path = 1, symbols = { modified = " ●", readonly = " ", unnamed = "[No Name]" } },
          },
          lualine_x = { "diagnostics", lsp_clients, "filetype" },
          lualine_y = {
            "searchcount",
            function()
              return vim.fn.line "." .. "/" .. vim.fn.line "$"
            end,
          },
          lualine_z = { "location" },
        },
        inactive_sections = {
          lualine_c = {
            { cwd_name },
            { "filename", path = 1 },
          },
          lualine_x = { "location" },
        },
      }
    end,
  },
}
