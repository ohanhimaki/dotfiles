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
local user_config = require("config")

-- Enhanced status bar with key table, workspace, and battery info
wezterm.on("update-right-status", function(window, pane)
	local status_items = {}

	-- Key table indicator
	local key_table = window:active_key_table()
	if key_table then
		table.insert(status_items, "TABLE: " .. key_table)
	end

	-- Workspace name
	local workspace = window:active_workspace()
	if workspace and workspace ~= "default" then
		table.insert(status_items, "WS: " .. workspace)
	end

	-- Date and time
	local time = wezterm.strftime("%H:%M")
	table.insert(status_items, time)

	-- Battery info (if available)
	for _, b in ipairs(wezterm.battery_info()) do
		local battery = string.format("%.0f%%", b.state_of_charge * 100)
		if b.state == "Charging" then
			battery = "⚡ " .. battery
		end
		table.insert(status_items, battery)
	end

	window:set_right_status(table.concat(status_items, " | "))
end)

-- Format tab titles to show workspace name
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local workspace = tab.active_pane.workspace
	local title = tab.active_pane.title

	-- Show workspace name in tab if not default
	if workspace and workspace ~= "default" then
		title = string.format("[%s] %s", workspace, title)
	end

	-- Add tab index
	return string.format(" %d: %s ", tab.tab_index + 1, title)
end)

local config = {
  default_prog = user_config.os_config.default_prog,
  color_scheme = 'Gruvbox Dark (Gogh)',
	colors = {
		cursor_bg = "#A6ACCD",
		cursor_border = "#A6ACCD",
		cursor_fg = "#1B1E28",
	},
	-- font
	font = wezterm.font("JetBrains Mono", { weight = "Medium" }),
	font_size = user_config.os_config.font_size,
	line_height = 1.2,
	window_background_opacity = user_config.opacity.default,
	win32_system_backdrop = user_config.os_config.system_backdrop, -- Blur effect (Windows 11 only)
	-- tab bar
	use_fancy_tab_bar = false,
	tab_bar_at_bottom = false,
	hide_tab_bar_if_only_one_tab = false,
	tab_max_width = 999999,
	window_decorations = "RESIZE",
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
