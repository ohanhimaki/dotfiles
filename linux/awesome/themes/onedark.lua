---------------------------
-- OneDark awesome theme --
---------------------------

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()

local theme = {}

-- OneDark colors
local onedark = {
    bg          = "#282c34",
    bg_dark     = "#21252b",
    bg_highlight = "#2c313c",
    bg_visual   = "#3e4452",

    fg          = "#abb2bf",
    fg_dark     = "#5c6370",
    fg_gutter   = "#4b5263",

    black       = "#282c34",
    red         = "#e06c75",
    green       = "#98c379",
    yellow      = "#e5c07b",
    blue        = "#61afef",
    purple      = "#c678dd",
    cyan        = "#56b6c2",
    white       = "#abb2bf",
    orange      = "#d19a66",

    -- Bright variants
    bright_red     = "#be5046",
    bright_green   = "#98c379",
    bright_yellow  = "#d19a66",
    bright_blue    = "#61afef",
    bright_purple  = "#c678dd",
    bright_cyan    = "#56b6c2",
}

theme.font          = "FiraCode Nerd Font Mono 10"

theme.bg_normal     = onedark.bg_dark
theme.bg_focus      = onedark.bg_highlight
theme.bg_urgent     = onedark.red
theme.bg_minimize   = onedark.bg_visual
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = onedark.fg
theme.fg_focus      = onedark.blue
theme.fg_urgent     = onedark.white
theme.fg_minimize   = onedark.fg_dark

theme.useless_gap   = dpi(4)
theme.border_width  = dpi(2)
theme.border_normal = onedark.bg_visual
theme.border_focus  = onedark.blue
theme.border_marked = onedark.cyan

-- Taglist
theme.taglist_bg_focus = onedark.blue
theme.taglist_fg_focus = onedark.bg_dark
theme.taglist_bg_urgent = onedark.red
theme.taglist_fg_urgent = onedark.bg_dark
theme.taglist_bg_occupied = onedark.bg_visual
theme.taglist_fg_occupied = onedark.cyan
theme.taglist_bg_empty = onedark.bg_dark
theme.taglist_fg_empty = onedark.fg_gutter

-- Taglist shapes with borders for occupied/urgent tags
local gears = require("gears")
theme.taglist_shape = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, dpi(4))
end
theme.taglist_shape_border_width = dpi(0)
theme.taglist_shape_border_color = onedark.bg_visual
theme.taglist_shape_border_width_focus = dpi(0)
theme.taglist_shape_border_color_focus = onedark.blue
theme.taglist_shape_border_width_empty = dpi(0)
theme.taglist_shape_border_color_empty = onedark.bg_visual
theme.taglist_shape_border_width_urgent = dpi(2)
theme.taglist_shape_border_color_urgent = onedark.red
theme.taglist_shape_border_width_occupied = dpi(2)
theme.taglist_shape_border_color_occupied = onedark.green

-- Taglist spacing
theme.taglist_spacing = dpi(4)

-- Tasklist
theme.tasklist_bg_focus = onedark.bg_visual
theme.tasklist_fg_focus = onedark.cyan
theme.tasklist_bg_normal = onedark.bg_highlight
theme.tasklist_fg_normal = onedark.fg
theme.tasklist_bg_minimize = onedark.bg_dark
theme.tasklist_fg_minimize = onedark.fg_gutter
theme.tasklist_bg_urgent = onedark.bg_dark
theme.tasklist_fg_urgent = onedark.red

-- Tasklist shapes and borders for subtle pop
theme.tasklist_shape = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, dpi(5))
end
theme.tasklist_shape_border_width = dpi(0)
theme.tasklist_shape_border_width_focus = dpi(2)
theme.tasklist_shape_border_color_focus = onedark.blue

-- Tasklist spacing
theme.tasklist_spacing = dpi(5)

-- Titlebar
theme.titlebar_bg_focus  = onedark.bg_highlight
theme.titlebar_bg_normal = onedark.bg_dark
theme.titlebar_fg_focus  = onedark.blue
theme.titlebar_fg_normal = onedark.fg_dark

-- Notifications
theme.notification_bg = onedark.bg
theme.notification_fg = onedark.fg
theme.notification_border_color = onedark.blue
theme.notification_border_width = dpi(2)
theme.notification_shape = function(cr, width, height)
    require("gears").shape.rounded_rect(cr, width, height, dpi(8))
end

-- Hotkeys popup
theme.hotkeys_bg = onedark.bg
theme.hotkeys_fg = onedark.fg
theme.hotkeys_border_width = dpi(2)
theme.hotkeys_border_color = onedark.blue
theme.hotkeys_modifiers_fg = onedark.cyan
theme.hotkeys_label_fg = onedark.yellow
theme.hotkeys_font = "FiraCode Nerd Font Mono 10"
theme.hotkeys_description_font = "FiraCode Nerd Font Mono 9"

-- Menu
theme.menu_submenu_icon = themes_path.."default/submenu.png"
theme.menu_height = dpi(20)
theme.menu_width  = dpi(150)
theme.menu_bg_normal = onedark.bg
theme.menu_bg_focus = onedark.bg_highlight
theme.menu_fg_normal = onedark.fg
theme.menu_fg_focus = onedark.blue
theme.menu_border_color = onedark.bg_visual
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

