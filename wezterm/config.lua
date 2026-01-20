-- Configuration values that can be easily modified
local M = {}

-- Opacity settings
M.opacity = {
  transparent = 0.95,
  opaque = 1.0,
}
M.opacity.default = M.opacity.transparent -- Which one to use by default

-- Default workspaces to create on startup (optional)
-- Uncomment and modify if you want pre-defined workspaces
--[[
M.default_workspaces = {
  {
    name = "dotfiles",
    cwd = "C:\\Users\\kobbi\\dotfiles",
  },
  {
    name = "work",
    cwd = "C:\\Users\\kobbi\\projects",
  },
  {
    name = "personal",
    cwd = "C:\\Users\\kobbi",
  },
}
--]]

return M

