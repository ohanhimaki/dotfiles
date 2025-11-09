-- Battery widget
local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")

local battery_widget = {}

function battery_widget.create()
    local widget = wibox.widget.textbox()
    widget:set_markup(" <span color='#A3BE8C'>🔋 --</span> ")
    
    local function update_battery()
        local bat_path = "/sys/class/power_supply/BAT0"
        
        -- Check if battery exists
        local capacity_file = io.open(bat_path .. "/capacity", "r")
        if not capacity_file then
            widget:set_markup("")  -- Hide widget if no battery
            return
        end
        
        local capacity = capacity_file:read("*all")
        capacity_file:close()
        capacity = tonumber(capacity) or 0
        
        -- Get time remaining (if available)
        local time_str = ""
        local energy_now_file = io.open(bat_path .. "/energy_now", "r")
        local power_now_file = io.open(bat_path .. "/power_now", "r")
        
        if energy_now_file and power_now_file then
            local energy_now = tonumber(energy_now_file:read("*all")) or 0
            local power_now = tonumber(power_now_file:read("*all")) or 1
            energy_now_file:close()
            power_now_file:close()
            
            if power_now > 0 then
                local hours = energy_now / power_now
                local h = math.floor(hours)
                local m = math.floor((hours - h) * 60)
                time_str = string.format(" %02d:%02d", h, m)
            end
        end
        
        -- Get charging status
        local status_file = io.open(bat_path .. "/status", "r")
        local status = ""
        if status_file then
            status = status_file:read("*all"):gsub("\n", "")
            status_file:close()
        end
        
        -- Choose color and icon based on level and status
        local color = "#A3BE8C"  -- Green
        local icon = "🔋"
        
        if status == "Charging" then
            icon = "⚡"
            color = "#88C0D0"  -- Cyan
        elseif capacity < 20 then
            color = "#BF616A"  -- Red
            icon = "🪫"
        elseif capacity < 50 then
            color = "#EBCB8B"  -- Yellow
        end
        
        widget:set_markup(string.format(" <span color='%s'>%s %d%%%s</span> ", color, icon, capacity, time_str))
    end
    
    -- Update battery immediately and every 30 seconds
    update_battery()
    gears.timer {
        timeout = 30,
        autostart = true,
        callback = update_battery
    }
    
    return widget
end

return battery_widget