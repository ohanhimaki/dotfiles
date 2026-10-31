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

local tab_bar_layouts = {}
local new_tab_button_width = 3

local function tab_title(tab)
	local title = tab.tab_title
	if not title or title == "" then
		title = tab.active_pane.title
	end

	return string.format("%d: %s", tab.tab_index + 1, title)
end

local function fit_tab_title(title, width)
	if width <= 0 then
		return ""
	end

	-- Keep a cell of breathing room on each side whenever the tab is wide
	-- enough, then center the (possibly truncated) title in the tab.
	local content_width = math.max(width - 2, 1)
	local fitted = wezterm.truncate_right(title, content_width)
	local padding = width - wezterm.column_width(fitted)
	local left_padding = math.floor(padding / 2)

	return string.rep(" ", left_padding) .. fitted .. string.rep(" ", padding - left_padding)
end

local function update_tab_bar(window, pane)
	local workspace = window:active_workspace() or "default"
	local key_table = window:active_key_table()
	local left_text = " " .. workspace .. " "

	local left_status = {
		{ Background = { Color = "#3c3836" } },
		{ Foreground = { Color = "#ebdbb2" } },
		{ Attribute = { Intensity = "Bold" } },
		{ Text = left_text },
	}

	if key_table then
		local key_table_text = " " .. string.upper(key_table) .. " "
		left_text = left_text .. key_table_text
		table.insert(left_status, { Background = { Color = "#d79921" } })
		table.insert(left_status, { Foreground = { Color = "#282828" } })
		table.insert(left_status, { Text = key_table_text })
	end

	local right_items = { wezterm.strftime("%H:%M") }
	for _, battery_info in ipairs(wezterm.battery_info()) do
		local battery = string.format("%.0f%%", battery_info.state_of_charge * 100)
		if battery_info.state == "Charging" then
			battery = "⚡ " .. battery
		end
		table.insert(right_items, battery)
	end

	local right_text = " " .. table.concat(right_items, " | ") .. " "
	window:set_left_status(wezterm.format(left_status))
	window:set_right_status(wezterm.format({
		{ Foreground = { Color = "#a89984" } },
		{ Text = right_text },
	}))

	local active_tab = window:active_tab()
	local dimensions = active_tab and active_tab:get_size() or pane:get_dimensions()
	tab_bar_layouts[window:window_id()] = {
		cols = dimensions.cols,
		left_width = wezterm.column_width(left_text),
		right_width = wezterm.column_width(right_text),
	}
end

wezterm.on("update-status", update_tab_bar)
wezterm.on("window-resized", update_tab_bar)

wezterm.on("format-tab-title", function(tab, tabs)
	local title = tab_title(tab)
	local layout = tab_bar_layouts[tab.window_id]
	if not layout or #tabs == 0 then
		return " " .. title .. " "
	end

	local available_width = math.max(
		#tabs,
		layout.cols - layout.left_width - layout.right_width - new_tab_button_width
	)
	local width = math.floor(available_width / #tabs)
	local extra_cells = available_width % #tabs
	if tab.tab_index < extra_cells then
		width = width + 1
	end

	return fit_tab_title(title, width)
end)

local config = {
	default_prog = user_config.os_config.default_prog,
	color_scheme = "Gruvbox Dark (Gogh)",
	colors = {
		tab_bar = {
			background = "#282828",
			active_tab = {
				bg_color = "#504945",
				fg_color = "#fbf1c7",
				intensity = "Bold",
			},
			inactive_tab = {
				bg_color = "#282828",
				fg_color = "#a89984",
			},
			inactive_tab_hover = {
				bg_color = "#3c3836",
				fg_color = "#ebdbb2",
			},
			new_tab = {
				bg_color = "#282828",
				fg_color = "#a89984",
			},
			new_tab_hover = {
				bg_color = "#3c3836",
				fg_color = "#ebdbb2",
			},
		},
	},
	-- font
	-- "NF" variant's icon glyphs are wider than one monospace cell and bleed
	-- into neighboring cells (e.g. render-markdown.nvim bullet highlight
	-- spilling onto the next word). The Mono variant scales icons to fit
	-- exactly one cell, which terminals require. Family name differs by nerd-fonts
	-- release/installer ("NFM" abbreviated vs "Nerd Font Mono" full) across
	-- Windows and Linux installs, so list both and let wezterm pick whichever
	-- resolves.
	font = wezterm.font_with_fallback({
		"JetBrainsMono NFM",
		"JetBrainsMono Nerd Font Mono",
	}, { weight = "Medium" }),
	font_size = user_config.os_config.font_size,
	line_height = 1.2,
	underline_thickness = "1.2pt",
	underline_position = "-2.0",
	window_background_opacity = user_config.opacity.default,
	win32_system_backdrop = user_config.os_config.system_backdrop, -- Blur effect (Windows 11 only)
	-- tab bar
	use_fancy_tab_bar = false,
	tab_bar_at_bottom = false,
	hide_tab_bar_if_only_one_tab = false,
	tab_max_width = 999999,
	tab_bar_style = {
		new_tab = wezterm.format({ { Text = " + " } }),
		new_tab_hover = wezterm.format({ { Text = " + " } }),
	},
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
	--front_end possible values are "OpenGL", "WebGPU", "Software", "Vulkan"
	-- Switched from WebGpu: caused stale-cell rendering glitches (highlight
	-- bleeding onto adjacent text, leftover number-column color on wrapped
	-- line continuations) — a known class of bug with wezterm's WebGpu
	-- backend, especially on Windows with hybrid-GPU/DX12 adapter selection.
	front_end = "OpenGL",
}
if not user_config.is_windows then
    config.launch_menu = {}
end

config.adjust_window_size_when_changing_font_size = false

-- make neovim markdown bold text more weight
config.font_rules = {
	{
		intensity = "Bold",
		italic = false,
		font = wezterm.font_with_fallback({
			"JetBrainsMono NFM",
			"JetBrainsMono Nerd Font Mono",
		}, { weight = "ExtraBold" }),
	},
}

return config
