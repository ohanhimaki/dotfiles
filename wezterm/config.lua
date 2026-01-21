-- Configuration values that can be easily modified
local wezterm = require("wezterm")
local M = {}

-- Detect OS
M.is_windows = wezterm.target_triple:find("windows") ~= nil
M.is_linux = wezterm.target_triple:find("linux") ~= nil
M.is_mac = wezterm.target_triple:find("darwin") ~= nil

-- Opacity settings
M.opacity = {
  transparent = 0.95,
  opaque = 1.0,
}
M.opacity.default = M.opacity.transparent -- Which one to use by default

-- OS-specific settings
M.os_config = {}

if M.is_windows then
  M.os_config.default_prog = { "pwsh", "-NoLogo" }
  M.os_config.font_size = 10
  M.os_config.system_backdrop = "Acrylic" -- Windows 11 blur effect
elseif M.is_linux then
  M.os_config.default_prog = { "bash" } -- or "zsh" if you use that
  M.os_config.font_size = 11 -- Linux often needs slightly larger fonts
  M.os_config.system_backdrop = nil -- Not available on Linux
elseif M.is_mac then
  M.os_config.default_prog = { "zsh" }
  M.os_config.font_size = 12
  M.os_config.system_backdrop = nil
end

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

