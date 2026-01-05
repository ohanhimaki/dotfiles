
-- Minimal WezTerm configuration for debugging
local wezterm = require 'wezterm'
local config = {}

-- Use config_builder if available (newer versions)
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- Just set font size - that's it!
config.font_size = 14.0

-- make powershell the default shell on Windows
--

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
  config.default_prog = { "pwsh.exe", "-NoLogo" }
end

return config

