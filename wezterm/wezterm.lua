-- test
-- https://wezfurlong.org/wezterm/config/lua/config/index.html
-- https://wezfurlong.org/wezterm/config/lua/index.html

-- local wezterm = require 'wezterm'
-- local act = wezterm.actions	
-- local mux = wezterm.mux
-- local config = {}
-- if wezterm.config_builder then
--   config = wezterm.config_builder()
-- end
-- -- This is where you actually apply your config choices
-- -- use grovebox
-- config.color_scheme = "Grovebox"
-- --config.font = wezterm.font("FiraCode Nerd Font Mono")
-- config.font_size = 10.0
-- config.line_height = 1.0
-- config.cell_width = 1.0
-- config.enable_tab_bar = true
-- config.hide_tab_bar_if_only_one_tab = false
--
-- -- use powershell
-- config.default_prog = { "pwsh", "-NoLogo" }
--
-- return config
--

local wezterm = require("wezterm")
local mappings = require("modules.mappings")

-- Show which key table is active in the status area
wezterm.on("update-right-status", function(window, pane)
	local name = window:active_key_table()
	if name then
		name = "TABLE: " .. name
	end
	window:set_right_status(name or "")
end)

local config = {
  default_prog = { "pwsh", "-NoLogo" },
  color_scheme = 'Gruvbox Dark (Gogh)',
	colors = {
		cursor_bg = "#A6ACCD",
		cursor_border = "#A6ACCD",
		cursor_fg = "#1B1E28",
	},
	-- font
	font = wezterm.font("JetBrains Mono", { weight = "Medium" }),
	font_size = 10,
	line_height = 1.2,
	window_background_opacity = 0.98,
	-- tab bar
	use_fancy_tab_bar = false,
	tab_bar_at_bottom = true,
	hide_tab_bar_if_only_one_tab = true,
	tab_max_width = 999999,
	window_decorations = "RESIZE|TITLE",
	inactive_pane_hsb = {
		brightness = 0.7,
	},
	send_composed_key_when_left_alt_is_pressed = false,
	send_composed_key_when_right_alt_is_pressed = true,
	-- key bindings
	leader = mappings.leader,
	keys = mappings.keys,
	key_tables = mappings.key_tables,
  window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
  },
  -- Launch menu with admin PowerShell option
  launch_menu = {
    {
      label = "PowerShell",
      args = { "pwsh", "-NoLogo" },
    },
    {
      label = "PowerShell (Admin)",
      args = { "powershell.exe", "-Command", "Start-Process", "pwsh", "-Verb", "RunAs" },
    },
  },
  front_end = "WebGpu",
  webgpu_power_preference = "HighPerformance",
  -- force dx12 
}
local gpus = wezterm.gui.enumerate_gpus()

config.webgpu_preferred_adapter = gpus[1]


return config
