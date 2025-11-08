-- Spotify now playing widget
local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")

local spotify_widget = {}

function spotify_widget.create()
    local widget = wibox.widget.textbox()
    widget:set_markup(" <span color='#A3BE8C'>🎵 --</span> ")
    
    local function update_spotify()
        awful.spawn.easy_async_with_shell("playerctl -p spotify status 2>/dev/null", 
            function(status)
                if status:match("Playing") then
                    awful.spawn.easy_async_with_shell("playerctl -p spotify metadata --format '{{ artist }} - {{ title }}' 2>/dev/null", 
                        function(metadata)
                            local text = metadata:gsub("%s+$", "")  -- trim whitespace
                            if #text > 40 then
                                text = text:sub(1, 37) .. "..."
                            end
                            widget:set_markup(string.format(" <span color='#A3BE8C'>🎵 %s</span> ", text))
                        end)
                elseif status:match("Paused") then
                    widget:set_markup(" <span color='#EBCB8B'>⏸️ Paused</span> ")
                else
                    widget:set_markup(" <span color='#4C566A'>🎵 --</span> ")
                end
            end)
    end
    
    -- Update every 5 seconds
    local timer = gears.timer {
        timeout = 5,
        call_now = true,
        autostart = true,
        callback = update_spotify
    }
    
    -- Click handlers for play/pause and track control
    widget:buttons(gears.table.join(
        awful.button({}, 1, function() -- Left click: play/pause
            awful.spawn("playerctl --player=spotify play-pause")
            gears.timer.delayed_call(function() update_spotify() end)
        end),
        awful.button({}, 3, function() -- Right click: next track
            awful.spawn("playerctl --player=spotify next")
            gears.timer.delayed_call(function() update_spotify() end)
        end),
        awful.button({}, 4, function() -- Scroll up: previous track
            awful.spawn("playerctl --player=spotify previous")
            gears.timer.delayed_call(function() update_spotify() end)
        end),
        awful.button({}, 5, function() -- Scroll down: next track
            awful.spawn("playerctl --player=spotify next")
            gears.timer.delayed_call(function() update_spotify() end)
        end)
    ))
    
    return widget
end

return spotify_widget