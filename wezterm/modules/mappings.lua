local wezterm = require("wezterm")
local act = wezterm.action
local user_config = require("config")

return {
	leader = { key = "Space", mods = "SHIFT" },

	keys = {
		{
			key = "w",
			mods = "CMD",
			action = act.CloseCurrentPane({ confirm = true }),
		},

		-- activate resize mode
		{
			key = "r",
			mods = "LEADER",
			action = act.ActivateKeyTable({
				name = "resize_pane",
				one_shot = false,
			}),
		},

		-- focus panes
		{
			key = "h",
			mods = "LEADER",
			action = act.ActivatePaneDirection("Left"),
		},
		{
			key = "l",
			mods = "LEADER",
			action = act.ActivatePaneDirection("Right"),
		},
		{
			key = "k",
			mods = "LEADER",
			action = act.ActivatePaneDirection("Up"),
		},
		{
			key = "j",
			mods = "LEADER",
			action = act.ActivatePaneDirection("Down"),
		},

		-- add new panes
		{
			key = "D",
			mods = "LEADER",
			action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
		},
		{
			key = "d",
			mods = "LEADER",
			action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
		},
    -- show launcher menu
    {
      key = "p",
      mods = "LEADER",
      action = act.ShowLauncher,
    },
    -- toggle opacity
    {
      key = "o",
      mods = "LEADER",
      action = wezterm.action_callback(function(window, _pane)
        local overrides = window:get_config_overrides() or {}
        if overrides.window_background_opacity == user_config.opacity.opaque then
          overrides.window_background_opacity = user_config.opacity.transparent
        else
          overrides.window_background_opacity = user_config.opacity.opaque
        end
        window:set_config_overrides(overrides)
      end),
    },
	},

	key_tables = {
		resize_pane = {
			{ key = "LeftArrow",  action = act.AdjustPaneSize({ "Left", 5 }) },
			{ key = "h",  action = act.AdjustPaneSize({ "Left", 5 }) },

			{ key = "RightArrow", action = act.AdjustPaneSize({ "Right", 5 }) },
			{ key = "l", action = act.AdjustPaneSize({ "Right", 5 }) },

			{ key = "UpArrow",    action = act.AdjustPaneSize({ "Up", 2 }) },
			{ key = "k",    action = act.AdjustPaneSize({ "Up", 2 }) },

			{ key = "DownArrow",  action = act.AdjustPaneSize({ "Down", 2 }) },
			{ key = "j",  action = act.AdjustPaneSize({ "Down", 2 }) },

			{ key = "Escape",     action = "PopKeyTable" },
		},
	},

}
