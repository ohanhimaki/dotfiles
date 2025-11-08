-- Spotify now playing widget
local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")

local spotify_widget = {}

function spotify_widget.create()
    local widget = wibox.widget.textbox()
    widget:set_markup(" <span color='#A3BE8C'>🎵 --</span> ")
    
    local function update_spotify()
        awful.spawn.easy_async("playerctl --player=spotify metadata --format '{{ artist }} - {{ title }}'", function(stdout)
            local info = stdout:gsub("\n", "")
            if info and info ~= "" and not info:match("No players found") then
                -- Limit the length to avoid taking too much space
                if #info > 40 then
                    info = info:sub(1, 37) .. "..."
                end
                widget:set_markup(string.format(" <span color='#A3BE8C'>🎵 %s</span> ", info))
            else
                widget:set_markup(" <span color='#A3BE8C'>🎵 --</span> ")
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
        end),
        awful.button({}, 3, function() -- Right click: next track
            awful.spawn("playerctl --player=spotify next")
        end),
        awful.button({}, 4, function() -- Scroll up: previous track
            awful.spawn("playerctl --player=spotify previous")
        end),
        awful.button({}, 5, function() -- Scroll down: next track
            awful.spawn("playerctl --player=spotify next")
        end)
    ))
    
    return widget
end

return spotify_widget