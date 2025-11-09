-- Audio volume widget with arc indicator
local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local naughty = require("naughty")

local audio_widget = {}

function audio_widget.create()
    -- Create arc widget
    local arc = wibox.widget {
        start_angle = 3 * math.pi / 2,
        min_value = 0,
        max_value = 100,
        value = 50,
        thickness = 3,
        rounded_edge = true,
        bg = "#3c3836",
        colors = { "#8ec07c" },  -- Gruvbox bright aqua
        widget = wibox.container.arcchart
    }
    
    -- Create text widget for percentage
    local text = wibox.widget {
        align = "center",
        valign = "center",
        font = "FiraCode Nerd Font Mono 9",
        widget = wibox.widget.textbox
    }
    
    -- Stack arc and text
    local widget = wibox.widget {
        arc,
        {
            text,
            left = 2,
            right = 2,
            widget = wibox.container.margin
        },
        layout = wibox.layout.stack
    }
    
    local function update_volume()
        awful.spawn.easy_async("pactl get-sink-volume @DEFAULT_SINK@", function(stdout)
            local volume = stdout:match("(%d+)%%")
            if volume then
                local vol = tonumber(volume)
                arc.value = vol
                text:set_markup(string.format("<span color='#ebdbb2'>%d</span>", vol))
                
                -- Change color based on volume level
                if vol > 100 then
                    arc.colors = { "#fb4934" }  -- Red for too loud
                elseif vol > 70 then
                    arc.colors = { "#fabd2f" }  -- Yellow for loud
                else
                    arc.colors = { "#8ec07c" }  -- Aqua for normal
                end
            end
        end)
        
        -- Check if muted
        awful.spawn.easy_async("pactl get-sink-mute @DEFAULT_SINK@", function(stdout)
            if stdout:match("yes") then
                text:set_markup("<span color='#fb4934'>M</span>")
                arc.colors = { "#504945" }  -- Gray when muted
            end
        end)
    end
    
    local function get_audio_devices()
        awful.spawn.easy_async("pactl list short sinks", function(stdout)
            local devices = {}
            for line in stdout:gmatch("[^\r\n]+") do
                local id, name, driver, sample_spec, state = line:match("(%d+)%s+(%S+)%s+(%S+)%s+(%S+)%s+(%S+)")
                if id and name then
                    local friendly_name = name:match("%.(.+)$") or name
                    friendly_name = friendly_name:gsub("_", " "):gsub("%-", " ")
                    friendly_name = friendly_name:gsub("(%a)([%w_']*)", function(first, rest)
                        return first:upper() .. rest:lower()
                    end)
                    table.insert(devices, {id = id, name = name, friendly = friendly_name})
                end
            end
            
            local menu_items = {}
            for _, device in ipairs(devices) do
                table.insert(menu_items, {
                    device.friendly,
                    function()
                        awful.spawn("pactl set-default-sink " .. device.name)
                        awful.spawn("pactl list short sink-inputs | cut -f1 | xargs -I{} pactl move-sink-input {} " .. device.name)
                        naughty.notify({
                            title = "Audio Output",
                            text = "Switched to: " .. device.friendly,
                            timeout = 2
                        })
                    end
                })
            end
            
            table.insert(menu_items, {"", function() end})
            table.insert(menu_items, {"Open Volume Control", function() awful.spawn("pavucontrol") end})
            
            local audio_menu = awful.menu({ items = menu_items })
            audio_menu:show()
        end)
    end
    
    -- Mouse controls
    widget:buttons(gears.table.join(
        awful.button({}, 1, get_audio_devices),  -- Left: show device menu
        awful.button({}, 3, function() awful.spawn("pavucontrol") end),  -- Right: open mixer
        awful.button({}, 4, function()  -- Scroll up: volume up
            awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ +5%")
            update_volume()
        end),
        awful.button({}, 5, function()  -- Scroll down: volume down
            awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ -5%")
            update_volume()
        end)
    ))
    
    -- Update immediately and every 5 seconds
    update_volume()
    gears.timer {
        timeout = 5,
        autostart = true,
        callback = update_volume
    }
    
    return widget
end

return audio_widget