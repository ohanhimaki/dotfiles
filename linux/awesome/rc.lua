-- vim: filetype=lua
-- Simplified rc.lua using modular structure
-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")

-- Enable hotkeys help widget for VIM and other apps
require("awful.hotkeys_popup.keys")

-- {{{ Variable definitions - Must be defined before loading keybindings
terminal = os.getenv("HOME") .. "/.local/kitty.app/bin/kitty"
editor = os.getenv("EDITOR") or "nvim"
editor_cmd = terminal .. " -- " .. editor
-- left alt as modkey
modkey = "Mod1"
-- }}}

-- Load custom modules
local battery_widget = require("widgets.battery")
local audio_widget = require("widgets.audio")
local spotify_widget = require("widgets.spotify")
local keybindings = require("keybindings")
local rules = require("rules")

-- Load Debian menu entries
local debian = require("debian.menu")
local has_fdo, freedesktop = pcall(require, "freedesktop")

-- {{{ Error handling
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        if in_error then return end
        in_error = true
        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
beautiful.init("~/.config/awesome/themes/gruvbox.lua")

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.max,
    -- Muut layoutit kommentoitu pois yksinkertaisuuden vuoksi
    -- awful.layout.suit.floating,
    -- awful.layout.suit.tile.left,
    -- awful.layout.suit.tile.bottom,
    -- awful.layout.suit.tile.top,
    -- awful.layout.suit.fair,
    -- awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.magnifier,
    -- awful.layout.suit.corner.nw,
}
-- }}}

-- {{{ Menu
local myawesomemenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
   { "shutdown", function() awful.spawn("shutdown -h now") end },
}

local menu_awesome = { "awesome", myawesomemenu, beautiful.awesome_icon }
local menu_terminal = { "open terminal", terminal }

if has_fdo then
    mymainmenu = freedesktop.menu.build({
        before = { menu_awesome },
        after =  { menu_terminal }
    })
else
    mymainmenu = awful.menu({
        items = {
                  menu_awesome,
                  { "Debian", debian.menu.Debian_menu.Debian },
                  menu_terminal,
                }
    })
end

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

menubar.utils.terminal = terminal
-- }}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
mytextclock = wibox.widget.textclock()

-- Helper function to shorten text
local function shorten_text(text, max_length)
    if not text then return "" end
    local char_count = utf8.len(text) or 0
    if char_count > max_length then
        local offset = utf8.offset(text, max_length + 1) or #text
        return text:sub(1, offset - 1) .. "..."
    end
    return text
end

-- Create widgets
local battery = battery_widget.create()
local audio = audio_widget.create()
local spotify = spotify_widget.create()

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                )

local tasklist_buttons = gears.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  c:emit_signal(
                                                      "request::activate",
                                                      "tasklist",
                                                      {raise = true}
                                                  )
                                              end
                                          end),
                     awful.button({ }, 3, function()
                                              awful.menu.client_list({ theme = { width = 250 } })
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                          end))

-- {{{ Wallpaper
local function set_wallpaper(s)
    local wallpaper_path = os.getenv("HOME") .. "/dotfiles/wallpapers/among-us.jpg"
    local file = io.open(wallpaper_path, "r")
    if file then
        file:close()
        gears.wallpaper.maximized(wallpaper_path, s, true)
    elseif beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

awful.screen.connect_for_each_screen(function(s)
    set_wallpaper(s)
    
    -- Only create 4 tags for left-hand efficiency
    awful.tag({ "1", "2", "3", "4" }, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons,
        layout = {
            spacing = 5,
            layout  = wibox.layout.fixed.horizontal
        },
        widget_template = {
            {
                {
                    {
                        {
                            id     = 'icon_role',
                            widget = wibox.widget.imagebox,
                        },
                        margins = 2,
                        widget  = wibox.container.margin,
                    },
                    {
                        id     = 'text_widget',
                        widget = wibox.widget.textbox,
                    },
                    {
                        id     = 'state_widget',
                        widget = wibox.widget.textbox,
                    },
                    layout = wibox.layout.fixed.horizontal,
                },
                left  = 5,
                right = 10,
                widget = wibox.container.margin
            },
            id     = 'background_role',
            widget = wibox.container.background,
            create_callback = function(self, c, index, objects)
                local text_widget = self:get_children_by_id('text_widget')[1]
                local state_widget = self:get_children_by_id('state_widget')[1]

                local function update_text()
                    if text_widget then
                        text_widget.text = " " .. shorten_text(c.name or "", 15)
                    end
                end

                local function update_state()
                    if state_widget then
                        local states = ""
                        if c.floating then states = states .. " 󰉈" end
                        if c.maximized then states = states .. " 󰊓" end
                        if c.minimized then states = states .. " 󰖰" end
                        if c.sticky then states = states .. " 󰐃" end
                        if c.ontop then states = states .. " 󰉿" end
                        state_widget.text = states
                    end
                end

                update_text()
                update_state()

                -- Update text when client name changes
                c:connect_signal("property::name", update_text)
                c:connect_signal("property::floating", update_state)
                c:connect_signal("property::maximized", update_state)
                c:connect_signal("property::minimized", update_state)
                c:connect_signal("property::sticky", update_state)
                c:connect_signal("property::ontop", update_state)
            end,
            update_callback = function(self, c, index, objects)
                local text_widget = self:get_children_by_id('text_widget')[1]
                local state_widget = self:get_children_by_id('state_widget')[1]

                if text_widget then
                    text_widget.text = " " .. shorten_text(c.name or "", 15)
                end

                if state_widget then
                    local states = ""
                    if c.floating then states = states .. " 󰉈" end
                    if c.maximized then states = states .. " 󰊓" end
                    if c.minimized then states = states .. " 󰖰" end
                    if c.sticky then states = states .. " 󰐃" end
                    if c.ontop then states = states .. " 󰉿" end
                    state_widget.text = states
                end
            end,
        },
    }

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            mylauncher,
            s.mytaglist,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            mykeyboardlayout,
            wibox.widget.systray(),
            audio,
            spotify,
            battery,
            mytextclock,
            s.mylayoutbox,
        },
    }
end)
-- }}}

-- Power menu
local power_menu = awful.menu({
    items = {
        { "&Lock screen", function() awful.spawn(os.getenv("HOME") .. "/.config/awesome/lock.sh") end },
        { "Turn off screens", function() awful.spawn("xset dpms force off") end },
        { "Sh&utdown", function() awful.spawn("systemctl poweroff") end },
        { "Restart", function() awful.spawn("systemctl reboot") end },
        { "Logout", awesome.quit },
    }
})

-- Setup keybindings and rules
local globalkeys, clientkeys, clientbuttons = keybindings.setup({}, {}, {}, power_menu)
rules.setup(clientkeys, clientbuttons)

-- Set keys
root.keys(globalkeys)

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
-- client.connect_signal("mouse::enter", function(c)
--     c:emit_signal("request::activate", "mouse_enter", {raise = false})
-- end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- Wallpaper refresh on screen geometry changes
screen.connect_signal("property::geometry", set_wallpaper)

-- Auto-run programs
awful.spawn.with_shell("xrandr --output DP-4 --mode 1920x1080 --rate 143.61 --primary --pos 1920x0 --output HDMI-0 --mode 1920x1080 --rate 60.00 --pos 0x0")

-- Gaming and input optimizations from backup
awful.spawn.with_shell("xset r rate 200 35")  -- Set keyboard repeat rate (delay=200ms, rate=35/sec - good for gaming)
awful.spawn.with_shell("xinput --set-prop 12 'libinput Accel Speed' -0.3")  -- Logitech mouse sensitivity
awful.spawn.with_shell("xset -dpms")  -- Disable power management
awful.spawn.with_shell("xset s off")   -- Disable screen saver
awful.spawn.with_shell("setxkbmap -option && setxkbmap -option caps:escape")  -- CapsLock to Escape
-- }}}
