-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "gruvbox",
  transparency = false,

  -- hl_override = {
  -- 	Comment = { italic = true },
  -- 	["@comment"] = { italic = true },
  -- },
  -- make comment bright red and add transparency overrides
  hl_override = {
    -- Comment = { fg = "#FF5555", italic = true },
    -- ["@comment"] = { fg = "#FF5555", italic = true },
    -- Normal = { bg = "NONE" },
    -- NormalFloat = { bg = "NONE" },
    -- NormalNC = { bg = "NONE" },
    -- SignColumn = { bg = "NONE" },
    -- EndOfBuffer = { bg = "NONE" },
    -- LineNr = { bg = "NONE" },
    -- Folded = { bg = "NONE" },
    -- NonText = { bg = "NONE" },
    -- VertSplit = { bg = "NONE" },
    -- WinSeparator = { bg = "NONE" },
    -- make cursorline more visible

    -- Make cursorline visible
    -- CursorLine = { bg = "#2c2c2c" }, -- gruvbox dark background
    CursorLineNr = { fg = "#fabd2f", bold = true }, -- gruvbox yellow
  },
}

--M.nvdash = { load_on_startup = true }
-- M.ui = {
--       tabufline = {
--          lazyload = false
--      }
-- }

M.ui = {
   statusline = {
   --   theme = "default", 
   --   separator_style = "default",
   --   order = { "mode", "f", "git", "%=", "lsp_msg", "%=", "lsp", "cwd", "xyz", "abc" },
     modules = {
   --     abc = function()
   --       return "hi"
   --     end,
   --
   --     xyz =  "hi",
   --     use %P, but still show same format as nvchad statusline for rows
       cursor = function()
         local row, col = unpack(vim.api.nvim_win_get_cursor(0))
         local percent = math.floor((row / vim.api.nvim_buf_line_count(0)) * 100)
         return string.format("%d:%d %d%%%%", row, col + 1, percent)
       end,
     }
   },
}
return M
