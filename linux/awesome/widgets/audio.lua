-- Audio output selector widget
local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local naughty = require("naughty")

local audio_widget = {}

function audio_widget.create()
    local widget = wibox.widget.textbox()
    widget:set_markup(" <span color='#88C0D0'>🔊</span> ")
    
    local function get_audio_devices()
        awful.spawn.easy_async("pactl list short sinks", function(stdout)
            local devices = {}
            for line in stdout:gmatch("[^\r\n]+") do
                local id, name, driver, sample_spec, state = line:match("(%d+)%s+(%S+)%s+(%S+)%s+(%S+)%s+(%S+)")
                if id and name then
                    -- Extract a friendly name from the sink name
                    local friendly_name = name:match("%.(.+)$") or name
                    friendly_name = friendly_name:gsub("_", " "):gsub("%-", " ")
                    -- Capitalize first letter of each word
                    friendly_name = friendly_name:gsub("(%a)([%w_']*)", function(first, rest)
                        return first:upper() .. rest:lower()
                    end)
                    table.insert(devices, {id = id, name = name, friendly = friendly_name})
                end
            end
            
            -- Create menu
            local menu_items = {}
            for _, device in ipairs(devices) do
                table.insert(menu_items, {
                    device.friendly,
                    function()
                        awful.spawn("pactl set-default-sink " .. device.name)
                        -- Also move all current streams to this device
                        awful.spawn("pactl list short sink-inputs | cut -f1 | xargs -I{} pactl move-sink-input {} " .. device.name)
                        naughty.notify({
                            title = "Audio Output",
                            text = "Switched to: " .. device.friendly,
                            timeout = 2
                        })
                    end
                })
            end
            
            table.insert(menu_items, {"", function() end}) -- separator
            table.insert(menu_items, {"Open Volume Control", function() awful.spawn("pavucontrol") end})
            
            local audio_menu = awful.menu({ items = menu_items })
            audio_menu:show()
        end)
    end
    
    -- Left click: show device menu, Right click: open pavucontrol
    widget:buttons(gears.table.join(
        awful.button({}, 1, get_audio_devices),
        awful.button({}, 3, function() awful.spawn("pavucontrol") end)
    ))
    
    return widget
end

return audio_widget