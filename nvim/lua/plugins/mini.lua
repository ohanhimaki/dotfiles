return {
  {
    "echasnovski/mini.nvim",
    lazy = false,
    config = function()
      local statusline = require "mini.statusline"

      statusline.setup {
        use_icons = true,
        content = {
          active = function()
            local mode, mode_hl = statusline.section_mode { trunc_width = 120 }
            local git = statusline.section_git { trunc_width = 40 }
            local diagnostics = statusline.section_diagnostics { trunc_width = 75 }
            local filename = statusline.section_filename { trunc_width = 140 }
            local location = statusline.section_location { trunc_width = 75 }

            -- LSP client
            local lsp = ""
            local clients = vim.lsp.get_clients { bufnr = 0 }
            if #clients > 0 then
              lsp = " "
              for _, client in ipairs(clients) do
                lsp = lsp .. client.name .. " "
              end
            end

            return statusline.combine_groups {
              { hl = mode_hl,                 strings = { mode } },
              { hl = "MiniStatuslineDevinfo", strings = { git, diagnostics } },
              "%<", -- truncation point
              { hl = "MiniStatuslineFilename", strings = { filename } },
              "%=", -- right align
              { hl = "MiniStatuslineFileinfo", strings = { lsp } },
              { hl = mode_hl,                  strings = { location } },
            }
          end,
        },
      }
    end,
  },
}
