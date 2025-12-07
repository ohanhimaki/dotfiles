-- Key bindings
local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup")
local menubar = require("menubar")

local keybindings = {}

-- Application shortcuts configuration
-- Each app can have multiple keybindings for raise_or_launch and spawn_new actions
local app_shortcuts = {
	filemanager = {
		cmd = "nautilus",
		spawn_new_cmd = "nautilus --new-window",
		class = "org.gnome.Nautilus",
		keys = {
			raise_or_launch = { { modkey, "e" } },
			spawn_new = { { modkey, "Shift", "e" } }
		},
		description = "file manager"
	},
	terminal = {
		cmd = terminal,
		spawn_new_cmd = terminal,
		class = "kitty",
		keys = {
			raise_or_launch = { { modkey, "Return" } },
			spawn_new = { { modkey, "Shift", "Return" } }
		},
		description = "terminal"
	},
	browser = {
		cmd = "flatpak run com.brave.Browser",
		spawn_new_cmd = "flatpak run com.brave.Browser --new-window",
		class = "Brave-browser",
		keys = {
			raise_or_launch = { { modkey, "b" } },
			spawn_new = { { modkey, "Shift", "b" } }
		},
		description = "browser"
	},
}

-- Track last focused client for each app class (for cycling)
local last_focused_by_class = {}

-- Raise or launch application
-- First press: focus the app (even if on different screen/tag) and switch to that screen/tag
-- Repeated press: cycle to next window of the same app
-- If app is not running: launch it
local function raise_or_launch(app_config)
	local matcher = function(c)
		return awful.rules.match(c, { class = app_config.class })
	end

	-- Find all clients matching the class and sort them predictably
	local clients = {}
	for _, c in ipairs(client.get()) do
		if matcher(c) then
			table.insert(clients, c)
		end
	end

	-- Debug: print found clients count
	-- Uncomment the line below for debugging:
	-- naughty.notify({ text = "Found " .. #clients .. " instances of " .. app_config.class })

	-- Sort clients by screen index, then by tag index for predictable cycling
	table.sort(clients, function(a, b)
		if a.screen.index ~= b.screen.index then
			return a.screen.index < b.screen.index
		end
		local a_tag = a.first_tag
		local b_tag = b.first_tag
		if a_tag and b_tag and a_tag.index ~= b_tag.index then
			return a_tag.index < b_tag.index
		end
		return a.window < b.window
	end)

	-- No instances running - launch it
	if #clients == 0 then
		awful.spawn(app_config.cmd)
		last_focused_by_class[app_config.class] = nil
		return
	end

	-- Find the last focused client of this app class
	local last_focused = last_focused_by_class[app_config.class]
	local last_focused_index = nil

	-- Check if last_focused is still valid and in the clients list
	if last_focused and last_focused.valid then
		for i, c in ipairs(clients) do
			if c == last_focused then
				last_focused_index = i
				break
			end
		end
	end

	-- Determine the target client
	local target_client
	if last_focused_index and #clients > 1 then
		-- Cycle to the next client
		target_client = clients[(last_focused_index % #clients) + 1]
	else
		-- Focus the first client (no previous focus or only one instance)
		target_client = clients[1]
	end

	-- Switch to the screen and tag of the target client
	if target_client.screen then
		awful.screen.focus(target_client.screen)
	end
	local tag = target_client.first_tag
	if tag then
		tag:view_only()
	end
	target_client:emit_signal("request::activate", "keybinding", { raise = true })

	-- Remember this client for next cycle
	last_focused_by_class[app_config.class] = target_client
end

-- Generate keybindings from app_shortcuts configuration
local function generate_app_keybindings()
	local keys = {}

	for app_name, app_config in pairs(app_shortcuts) do
		-- Generate raise_or_launch keybindings
		if app_config.keys.raise_or_launch then
			for _, key_combo in ipairs(app_config.keys.raise_or_launch) do
				-- Extract modifiers (all elements except last) and key (last element)
				local modifiers = {}
				for i = 1, #key_combo - 1 do
					table.insert(modifiers, key_combo[i])
				end
				local key = key_combo[#key_combo]

				table.insert(keys, awful.key(
					modifiers,
					key,
					function() raise_or_launch(app_config) end,
					{ description = app_config.description .. " (raise or launch)", group = "launcher" }
				))
			end
		end

		-- Generate spawn_new keybindings
		if app_config.keys.spawn_new then
			for _, key_combo in ipairs(app_config.keys.spawn_new) do
				-- Extract modifiers (all elements except last) and key (last element)
				local modifiers = {}
				for i = 1, #key_combo - 1 do
					table.insert(modifiers, key_combo[i])
				end
				local key = key_combo[#key_combo]

				table.insert(keys, awful.key(
					modifiers,
					key,
					function() awful.spawn(app_config.spawn_new_cmd or app_config.cmd) end,
					{ description = app_config.description .. " (new instance)", group = "launcher" }
				))
			end
		end
	end

	return keys
end

function keybindings.setup(globalkeys, clientkeys, clientbuttons, power_menu)
	-- Global key bindings
	globalkeys = awful.util.table.join(
		globalkeys,
		-- Awesome controls
		awful.key({ modkey }, "s", hotkeys_popup.show_help, { description = "show help", group = "awesome" }),
		awful.key({ modkey, "Control" }, "r", awesome.restart,
				{ description = "reload awesome", group = "awesome" }),
		
			-- Tag navigation (sequential)
			awful.key({ modkey }, "a", awful.tag.viewprev,
				{ description = "view previous tag", group = "tag" }),
			awful.key({ modkey }, "d", awful.tag.viewnext,
				{ description = "view next tag", group = "tag" }),
			awful.key({ modkey }, "Left", awful.tag.viewprev,
				{ description = "view previous tag", group = "tag" }),
			awful.key({ modkey }, "Right", awful.tag.viewnext,
				{ description = "view next tag", group = "tag" }),
		
			-- Move client to adjacent tag and follow
			awful.key({ modkey, "Control" }, "a", function()
				if client.focus then
					local screen = client.focus.screen
					local tag = screen.tags[screen.selected_tag.index - 1]
					if tag then
						client.focus:move_to_tag(tag)
						tag:view_only()
					end
				end
			end, { description = "move client to previous tag and switch", group = "tag" }),
			awful.key({ modkey, "Control" }, "d", function()
				if client.focus then
					local screen = client.focus.screen
					local tag = screen.tags[screen.selected_tag.index + 1]
					if tag then
						client.focus:move_to_tag(tag)
						tag:view_only()
					end
				end
			end, { description = "move client to next tag and switch", group = "tag" }),
			awful.key({ modkey, "Control" }, "Left", function()
				if client.focus then
					local screen = client.focus.screen
					local tag = screen.tags[screen.selected_tag.index - 1]
					if tag then
						client.focus:move_to_tag(tag)
						tag:view_only()
					end
				end
			end, { description = "move client to previous tag and switch", group = "tag" }),
			awful.key({ modkey, "Control" }, "Right", function()
				if client.focus then
					local screen = client.focus.screen
					local tag = screen.tags[screen.selected_tag.index + 1]
					if tag then
						client.focus:move_to_tag(tag)
						tag:view_only()
					end
				end
			end, { description = "move client to next tag and switch", group = "tag" }),
		
			-- Client focus navigation
		awful.key({ modkey }, "j", function()
			awful.client.focus.byidx(1)
		end, { description = "focus next by index", group = "client" }),
		awful.key({ modkey }, "k", function()
			awful.client.focus.byidx(-1)
		end, { description = "focus previous by index", group = "client" }),

		-- Layout manipulation
		awful.key({ modkey, "Shift" }, "j", function()
			awful.client.swap.byidx(1)
		end, { description = "swap with next client by index", group = "client" }),
		awful.key({ modkey, "Shift" }, "k", function()
			awful.client.swap.byidx(-1)
		end, { description = "swap with previous client by index", group = "client" }),
		awful.key({ modkey, "Control" }, "j", function()
			awful.screen.focus_relative(1)
		end, { description = "focus the next screen", group = "screen" }),
		awful.key({ modkey, "Control" }, "k", function()
			awful.screen.focus_relative(-1)
		end, { description = "focus the previous screen", group = "screen" }),
		awful.key(
			{ modkey },
			"u",
			awful.client.urgent.jumpto,
			{ description = "jump to urgent client", group = "client" }
		),
		awful.key({ modkey }, "Tab", function()
			awful.client.focus.history.previous()
			if client.focus then
				client.focus:raise()
			end
		end, { description = "go back", group = "client" }),

		-- -- Standard program
		-- awful.key({ modkey }, "Return", function()
		-- 	raise_or_launch(app_shortcuts.terminal)
		-- end, { description = "terminal (raise or launch)", group = "launcher" }),

		-- Layout controls
		awful.key({ modkey }, "l", function()
			awful.tag.incmwfact(0.05)
		end, { description = "increase master width factor", group = "layout" }),
		awful.key({ modkey }, "h", function()
			awful.tag.incmwfact(-0.05)
		end, { description = "decrease master width factor", group = "layout" }),
		awful.key({ modkey, "Shift" }, "h", function()
			awful.tag.incnmaster(1, nil, true)
		end, { description = "increase the number of master clients", group = "layout" }),
		awful.key({ modkey, "Shift" }, "l", function()
			awful.tag.incnmaster(-1, nil, true)
		end, { description = "decrease the number of master clients", group = "layout" }),
		awful.key({ modkey, "Control" }, "h", function()
			awful.tag.incncol(1, nil, true)
		end, { description = "increase the number of columns", group = "layout" }),
		awful.key({ modkey, "Control" }, "l", function()
			awful.tag.incncol(-1, nil, true)
		end, { description = "decrease the number of columns", group = "layout" }),
		awful.key({ modkey }, "space", function()
			awful.layout.inc(1)
		end, { description = "select next", group = "layout" }),
		awful.key({ modkey, "Shift" }, "space", function()
			awful.layout.inc(-1)
		end, { description = "select previous", group = "layout" }),
		awful.key({ modkey, "Control" }, "n", function()
			local c = awful.client.restore()
			-- Focus restored client
			if c then
				c:emit_signal("request::activate", "key.unminimize", { raise = true })
			end
		end, { description = "restore minimized", group = "client" }),

		-- Prompt
		awful.key({ modkey }, "r", function()
			awful.screen.focused().mypromptbox:run()
		end, { description = "run prompt", group = "launcher" }),

		awful.key({ modkey }, "x", function()
			awful.prompt.run({
				prompt = "Run Lua code: ",
				textbox = awful.screen.focused().mypromptbox.widget,
				exe_callback = awful.util.eval,
				history_path = awful.util.get_cache_dir() .. "/history_eval",
			})
		end, { description = "lua execute prompt", group = "awesome" }),
		-- Menubar
		awful.key({ modkey }, "p", function()
			menubar.show()
		end, { description = "show the menubar", group = "launcher" }),

		-- Media keys
		awful.key({}, "XF86AudioMute", function()
			awful.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle")
		end, { description = "toggle mute", group = "media" }),
		awful.key({}, "XF86AudioLowerVolume", function()
			awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ -5%")
		end, { description = "lower volume", group = "media" }),
		awful.key({}, "XF86AudioRaiseVolume", function()
			awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ +5%")
		end, { description = "raise volume", group = "media" }),
		awful.key({}, "XF86AudioPlay", function()
			awful.spawn("playerctl play-pause")
		end, { description = "play/pause", group = "media" }),
		awful.key({}, "XF86AudioNext", function()
			awful.spawn("playerctl next")
		end, { description = "next track", group = "media" }),
		awful.key({}, "XF86AudioPrev", function()
			awful.spawn("playerctl previous")
		end, { description = "previous track", group = "media" }),
		awful.key({}, "XF86MonBrightnessUp", function()
			awful.spawn("brightnessctl set +10%")
			end, { description = "increase brightness", group = "media" }),
		
			-- Alternative media controls for keyboards without media keys
			awful.key({ modkey, "Shift" }, "p", function()
				awful.spawn("playerctl play-pause")
			end, { description = "play/pause (alternative)", group = "media" }),
		awful.key({}, "XF86MonBrightnessDown", function()
			awful.spawn("brightnessctl set 10%-")
		end, { description = "decrease brightness", group = "media" }),

		-- -- Custom shortcuts
		-- -- Left-handed tag switching (Alt + Q/W/E/R for tags 1-4)
		-- awful.key({ "Mod1" }, "q",
		-- 	function()
		-- 		local screen = awful.screen.focused()
		-- 		local tag = screen.tags[1]
		-- 		if tag then tag:view_only() end
		-- 	end,
		-- 	{ description = "view tag 1", group = "tag" }),
		-- awful.key({ "Mod1" }, "w",
		-- 	function()
		-- 		local screen = awful.screen.focused()
		-- 		local tag = screen.tags[2]
		-- 		if tag then tag:view_only() end
		-- 	end,
		-- 	{ description = "view tag 2", group = "tag" }),
		-- awful.key({ "Mod1" }, "e",
		-- 	function()
		-- 		local screen = awful.screen.focused()
		-- 		local tag = screen.tags[3]
		-- 		if tag then tag:view_only() end
		-- 	end,
		-- 	{ description = "view tag 3", group = "tag" }),
		-- awful.key({ "Mod1" }, "r",
		-- 	function()
		-- 		local screen = awful.screen.focused()
		-- 		local tag = screen.tags[4]
		-- 		if tag then tag:view_only() end
		-- 	end,
		-- 	{ description = "view tag 4", group = "tag" }),

		-- Traditional Super+number tag switching (for all tags)
		awful.key({ modkey }, "1", function()
			local screen = awful.screen.focused()
			local tag = screen.tags[1]
			if tag then
				tag:view_only()
			end
		end, { description = "view tag 1", group = "tag" }),
		awful.key({ modkey }, "2", function()
			local screen = awful.screen.focused()
			local tag = screen.tags[2]
			if tag then
				tag:view_only()
			end
		end, { description = "view tag 2", group = "tag" }),
		awful.key({ modkey }, "3", function()
			local screen = awful.screen.focused()
			local tag = screen.tags[3]
			if tag then
				tag:view_only()
			end
		end, { description = "view tag 3", group = "tag" }),
		awful.key({ modkey }, "4", function()
			local screen = awful.screen.focused()
			local tag = screen.tags[4]
			if tag then
				tag:view_only()
			end
		end, { description = "view tag 4", group = "tag" }),

		-- Super+Shift+number to move client to tag
		awful.key({ modkey, "Shift" }, "1", function()
			if client.focus then
				local tag = client.focus.screen.tags[1]
				if tag then
					client.focus:move_to_tag(tag)
				end
			end
		end, { description = "move focused client to tag 1", group = "tag" }),
		awful.key({ modkey, "Shift" }, "2", function()
			if client.focus then
				local tag = client.focus.screen.tags[2]
				if tag then
					client.focus:move_to_tag(tag)
				end
			end
		end, { description = "move focused client to tag 2", group = "tag" }),
		awful.key({ modkey, "Shift" }, "3", function()
			if client.focus then
				local tag = client.focus.screen.tags[3]
				if tag then
					client.focus:move_to_tag(tag)
				end
			end
		end, { description = "move focused client to tag 3", group = "tag" }),
		awful.key({ modkey, "Shift" }, "4", function()
			if client.focus then
				local tag = client.focus.screen.tags[4]
				if tag then
					client.focus:move_to_tag(tag)
				end
			end
			end, { description = "move focused client to tag 4", group = "tag" }),
		
			-- Super+Control+number to move client to tag AND follow it
			awful.key({ modkey, "Control" }, "1", function()
				if client.focus then
					local tag = client.focus.screen.tags[1]
					if tag then
						client.focus:move_to_tag(tag)
						tag:view_only()
					end
				end
			end, { description = "move focused client to tag 1 and switch", group = "tag" }),
			awful.key({ modkey, "Control" }, "2", function()
				if client.focus then
					local tag = client.focus.screen.tags[2]
					if tag then
						client.focus:move_to_tag(tag)
						tag:view_only()
					end
				end
			end, { description = "move focused client to tag 2 and switch", group = "tag" }),
			awful.key({ modkey, "Control" }, "3", function()
				if client.focus then
					local tag = client.focus.screen.tags[3]
					if tag then
						client.focus:move_to_tag(tag)
						tag:view_only()
					end
				end
			end, { description = "move focused client to tag 3 and switch", group = "tag" }),
			awful.key({ modkey, "Control" }, "4", function()
				if client.focus then
					local tag = client.focus.screen.tags[4]
					if tag then
						client.focus:move_to_tag(tag)
						tag:view_only()
					end
				end
			end, { description = "move focused client to tag 4 and switch", group = "tag" }),

		-- Monitor switching with Super+Esc
		awful.key({ modkey }, "Escape", function()
			awful.screen.focus_relative(1)
		end, { description = "focus next screen", group = "screen" }),

		-- Window switcher with Alt+Tab (rofi)
		awful.key({ "Mod1" }, "Tab", function()
			awful.spawn("rofi -show window")
		end, { description = "window switcher", group = "launcher" }),

		-- Additional rofi shortcut with Super+Z
		awful.key({ modkey }, "z", function()
			awful.spawn("rofi -show window")
		end, { description = "window switcher", group = "launcher" }),

		-- Power menu with Super+Shift+Q (changed from Super+Q to avoid conflict)
		awful.key({ modkey, "Shift" }, "q", function()
			power_menu:show()
		end, { description = "power menu", group = "awesome" }),

		-- Application launchers (dynamically generated from app_shortcuts)
		table.unpack(generate_app_keybindings())
	)

	-- Client key bindingsa
	clientkeys = awful.util.table.join(
		awful.key({ modkey }, "f", function(c)
			c.fullscreen = not c.fullscreen
			c:raise()
		end, { description = "toggle fullscreen", group = "client" }),
		awful.key({ modkey, "Shift" }, "c", function(c)
			c:kill()
		end, { description = "close", group = "client" }),
		awful.key({ modkey }, "q", function(c)
			c:kill()
		end, { description = "close (alternative)", group = "client" }),
		awful.key(
			{ modkey, "Control" },
			"space",
			awful.client.floating.toggle,
			{ description = "toggle floating", group = "client" }
		),
		awful.key({ modkey, "Control" }, "Return", function(c)
			c:swap(awful.client.getmaster())
		end, { description = "move to master", group = "client" }),
		awful.key({ modkey }, "o", function(c)
			c:move_to_screen()
		end, { description = "move to screen", group = "client" }),
		awful.key({ modkey }, "t", function(c)
			c.ontop = not c.ontop
		end, { description = "toggle keep on top", group = "client" }),
		awful.key({ modkey }, "n", function(c)
			-- The client currently has the input focus, so it cannot be
			-- minimized, since minimized clients can't have the focus.
			c.minimized = true
		end, { description = "minimize", group = "client" }),
		awful.key({ modkey }, "m", function(c)
			c.maximized = not c.maximized
			c:raise()
		end, { description = "(un)maximize", group = "client" }),
		awful.key({ modkey, "Control" }, "m", function(c)
			c.maximized_vertical = not c.maximized_vertical
			c:raise()
		end, { description = "(un)maximize vertically", group = "client" }),
		awful.key({ modkey, "Shift" }, "m", function(c)
			c.maximized_horizontal = not c.maximized_horizontal
			c:raise()
		end, { description = "(un)maximize horizontally", group = "client" }),
		awful.key({ modkey, "Shift" }, "s", function(c)
			c.sticky = not c.sticky
		end, { description = "toggle sticky", group = "client" })
	)

	-- Client buttons
	clientbuttons = awful.util.table.join(
		awful.button({}, 1, function(c)
			c:emit_signal("request::activate", "mouse_click", { raise = true })
		end),
		awful.button({ modkey }, 1, function(c)
			c:emit_signal("request::activate", "mouse_click", { raise = true })
			awful.mouse.client.move(c)
		end),
		awful.button({ modkey }, 3, function(c)
			c:emit_signal("request::activate", "mouse_click", { raise = true })
			awful.mouse.client.resize(c)
		end)
	)

	return globalkeys, clientkeys, clientbuttons
end

return keybindings
