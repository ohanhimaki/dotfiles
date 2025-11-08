---------------------------
-- Gruvbox awesome theme --
---------------------------

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()

local theme = {}

-- Gruvbox colors
local gruvbox = {
    bg0_h     = "#1d2021",
    bg0       = "#282828",
    bg1       = "#3c3836",
    bg2       = "#504945",
    bg3       = "#665c54",
    bg4       = "#7c6f64",
    
    fg0       = "#fbf1c7",
    fg1       = "#ebdbb2",
    fg2       = "#d5c4a1",
    fg3       = "#bdae93",
    fg4       = "#a89984",
    
    red       = "#cc241d",
    green     = "#98971a",
    yellow    = "#d79921",
    blue      = "#458588",
    purple    = "#b16286",
    aqua      = "#689d6a",
    orange    = "#d65d0e",
    
    bright_red     = "#fb4934",
    bright_green   = "#b8bb26",
    bright_yellow  = "#fabd2f",
    bright_blue    = "#83a598",
    bright_purple  = "#d3869b",
    bright_aqua    = "#8ec07c",
    bright_orange  = "#fe8019",
}

theme.font          = "FiraCode Nerd Font Mono 10"

theme.bg_normal     = gruvbox.bg0_h
theme.bg_focus      = gruvbox.bg1
theme.bg_urgent     = gruvbox.red
theme.bg_minimize   = gruvbox.bg2
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = gruvbox.fg1
theme.fg_focus      = gruvbox.bright_yellow
theme.fg_urgent     = gruvbox.fg0
theme.fg_minimize   = gruvbox.fg4

theme.useless_gap   = dpi(4)
theme.border_width  = dpi(2)
theme.border_normal = gruvbox.bg2
theme.border_focus  = gruvbox.bright_blue
theme.border_marked = gruvbox.bright_orange

-- Taglist
theme.taglist_bg_focus = gruvbox.bright_yellow
theme.taglist_fg_focus = gruvbox.bg0_h
theme.taglist_bg_urgent = gruvbox.bright_red
theme.taglist_fg_urgent = gruvbox.bg0_h
theme.taglist_bg_occupied = gruvbox.bg2
theme.taglist_fg_occupied = gruvbox.bright_aqua
theme.taglist_bg_empty = gruvbox.bg0_h
theme.taglist_fg_empty = gruvbox.bg3

-- Taglist shapes with borders for occupied/urgent tags
local gears = require("gears")
theme.taglist_shape = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, dpi(4))
end
theme.taglist_shape_border_width = dpi(0)
theme.taglist_shape_border_color = gruvbox.bg2
theme.taglist_shape_border_width_focus = dpi(0)
theme.taglist_shape_border_color_focus = gruvbox.bright_yellow
theme.taglist_shape_border_width_empty = dpi(0)
theme.taglist_shape_border_color_empty = gruvbox.bg2
theme.taglist_shape_border_width_urgent = dpi(2)
theme.taglist_shape_border_color_urgent = gruvbox.bright_red
theme.taglist_shape_border_width_occupied = dpi(2)
theme.taglist_shape_border_color_occupied = gruvbox.bright_green

-- Taglist spacing
theme.taglist_spacing = dpi(4)

-- Tasklist
theme.tasklist_bg_focus = gruvbox.bg1
theme.tasklist_fg_focus = gruvbox.bright_aqua
theme.tasklist_bg_normal = gruvbox.bg0_h
theme.tasklist_fg_normal = gruvbox.fg2

-- Titlebar
theme.titlebar_bg_focus  = gruvbox.bg1
theme.titlebar_bg_normal = gruvbox.bg0_h
theme.titlebar_fg_focus  = gruvbox.bright_yellow
theme.titlebar_fg_normal = gruvbox.fg4

-- Notifications
theme.notification_bg = gruvbox.bg0
theme.notification_fg = gruvbox.fg1
theme.notification_border_color = gruvbox.bright_blue
theme.notification_border_width = dpi(2)
theme.notification_shape = function(cr, width, height)
    require("gears").shape.rounded_rect(cr, width, height, dpi(8))
end

-- Hotkeys popup
theme.hotkeys_bg = gruvbox.bg0
theme.hotkeys_fg = gruvbox.fg1
theme.hotkeys_border_width = dpi(2)
theme.hotkeys_border_color = gruvbox.bright_blue
theme.hotkeys_modifiers_fg = gruvbox.bright_aqua
theme.hotkeys_label_fg = gruvbox.bright_yellow
theme.hotkeys_font = "FiraCode Nerd Font Mono 10"
theme.hotkeys_description_font = "FiraCode Nerd Font Mono 9"

-- Menu
theme.menu_submenu_icon = themes_path.."default/submenu.png"
theme.menu_height = dpi(20)
theme.menu_width  = dpi(150)
theme.menu_bg_normal = gruvbox.bg0
theme.menu_bg_focus = gruvbox.bg1
theme.menu_fg_normal = gruvbox.fg1
theme.menu_fg_focus = gruvbox.bright_yellow
theme.menu_border_color = gruvbox.bg2
theme.menu_border_width = dpi(1)

-- Wallpaper
theme.wallpaper = themes_path.."default/background.png"

-- Layout icons
theme.layout_fairh = themes_path.."default/layouts/fairhw.png"
theme.layout_fairv = themes_path.."default/layouts/fairvw.png"
theme.layout_floating  = themes_path.."default/layouts/floatingw.png"
theme.layout_magnifier = themes_path.."default/layouts/magnifierw.png"
theme.layout_max = themes_path.."default/layouts/maxw.png"
theme.layout_fullscreen = themes_path.."default/layouts/fullscreenw.png"
theme.layout_tilebottom = themes_path.."default/layouts/tilebottomw.png"
theme.layout_tileleft   = themes_path.."default/layouts/tileleftw.png"
theme.layout_tile = themes_path.."default/layouts/tilew.png"
theme.layout_tiletop = themes_path.."default/layouts/tiletopw.png"
theme.layout_spiral  = themes_path.."default/layouts/spiralw.png"
theme.layout_dwindle = themes_path.."default/layouts/dwindlew.png"
theme.layout_cornernw = themes_path.."default/layouts/cornernww.png"
theme.layout_cornerne = themes_path.."default/layouts/cornernew.png"
theme.layout_cornersw = themes_path.."default/layouts/cornersww.png"
theme.layout_cornerse = themes_path.."default/layouts/cornersew.png"

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height, theme.bg_focus, theme.fg_focus
)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

return theme
