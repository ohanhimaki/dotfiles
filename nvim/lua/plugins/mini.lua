local function git_changed_files()
  local result = vim.fn.systemlist "git status --porcelain"
  if vim.v.shell_error ~= 0 then
    return "not git repository"
  end

  local count = #result
  if count == 0 then
    return "clean"
  end

  return "changed: " .. count .. " |"
end

local function get_cwd_and_relative_path()
  local cwd = vim.fn.getcwd()
  local filepath = vim.fn.expand "%:p"

  -- Get just the directory name from cwd
  local cwd_name = vim.fn.fnamemodify(cwd, ":t")

  -- Get relative path
  local relative_path = vim.fn.fnamemodify(filepath, ":.")

  return cwd_name .. "/" .. relative_path
end

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
            local diff = statusline.section_diff { trunc_width = 75 }
            local diagnostics = statusline.section_diagnostics { trunc_width = 75 }
            -- local lsp = statusline.section_lsp { trunc_width = 75 }
            local filename = get_cwd_and_relative_path()
            -- local filename = statusline.section_filename { trunc_width = 140 }
            local fileinfo = statusline.section_fileinfo { trunc_width = 120 }
            local location = statusline.section_location { trunc_width = 75 }
            local search = statusline.section_searchcount { trunc_width = 75 }
            local git_count = git_changed_files()

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
              { hl = "MiniStatuslineDevinfo", strings = { git, git_count, diff } },
              "%<", -- Mark general truncate point
              { hl = "MiniStatuslineFilename", strings = { filename } },
              "%=", -- End left alignment
              { hl = "MiniStatuslineFileinfo", strings = { diagnostics, lsp, fileinfo } },
              { hl = mode_hl,                  strings = { search, location } },
            }
          end,
        },
      }
    end,
  },
}
