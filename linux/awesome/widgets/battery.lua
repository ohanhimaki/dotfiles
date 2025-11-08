-- Battery widget
local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")

local battery_widget = {}

function battery_widget.create()
    local widget = wibox.widget.textbox()
    
    local function update_battery()
        awful.spawn.easy_async("cat /sys/class/power_supply/BAT*/capacity 2>/dev/null", function(stdout)
            local capacity = stdout:match("(%d+)")
            if capacity then
                local level = tonumber(capacity)
                local color = "#A3BE8C"  -- Green
                local icon = "🔋"
                
                if level <= 20 then
                    color = "#BF616A"  -- Red
                    icon = "🪫"
                elseif level <= 50 then
                    color = "#EBCB8B"  -- Yellow
                    icon = "🔋"
                end
                
                widget:set_markup(string.format(" <span color='%s'>%s %d%%</span> ", color, icon, level))
            else
                widget:set_markup("")  -- Hide if no battery
            end
        end)
    end
    
    -- Update every 60 seconds
    local timer = gears.timer {
        timeout = 60,
        call_now = true,
        autostart = true,
        callback = update_battery
    }
    
    return widget
end

return battery_widget