-- This file needs to have same structure as nvconfig.lua 
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :( 

---@type ChadrcConfig
local M = {}

M.base46 = {
	theme = "gruvbox",
	transparency = true,

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
     
     -- Make cursorline visible
     CursorLine = { bg = "#3c3836" },  -- gruvbox dark background
     CursorLineNr = { fg = "#fabd2f", bold = true },  -- gruvbox yellow
   },
}

--M.nvdash = { load_on_startup = true }
-- M.ui = {
--       tabufline = {
--          lazyload = false
--      }
-- }

return M
