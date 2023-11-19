---------------------------
-- custom awesome theme --
---------------------------
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local gfs = require("gears.filesystem")
local theme_path = gfs.get_configuration_dir() .. "theme/"
local theme = {}
local beautiful = require("beautiful")
local menubar_utils = require("menubar.utils")

local icon_theme = require("lib.icon_theme")("candy-icons")
local systray_icon_theme = require("lib.icon_theme")("Papirus-Dark", 16)

client.connect_signal("property::class", function(c)
	if not c.class then
		return
	end
	c.theme_icon = icon_theme:get_icon_path(c.class) or menubar_utils.lookup_icon(string.lower(c.class)) or c.icon
end)

theme.font = "JetBrainsMono Nerd Font Mono 11"

-- theme colors
theme.rosewater = "#f5e0dc"
theme.flamingo = "#f2cdcd"
theme.pink = "#f5c2e7"
theme.mauve = "#cba6f7"
theme.red = "#f38ba8"
theme.maroon = "#eba0ac"
theme.peach = "#fab387"
theme.yellow = "#f9e2af"
theme.green = "#a6e3a1"
theme.teal = "#94e2d5"
theme.sky = "#89dceb"
theme.sapphire = "#74c7ec"
theme.blue = "#89b4fa"
theme.lavender = "#b4befe"
theme.text = "#cdd6f4"
theme.subtext1 = "#bac2de"
theme.subtext0 = "#a6adc8"
theme.overlay2 = "#9399b2"
theme.overlay1 = "#7f849c"
theme.overlay0 = "#6c7086"
theme.surface2 = "#585b70"
theme.surface1 = "#45475a"
theme.surface0 = "#313244"
theme.base = "#1e1e2e"
theme.mantle = "#181825"
theme.crust = "#11111b"

theme.transparent = "#00000000"
theme.bg_transparent = "#000000" .. "66"
theme.bg_normal = theme.base
theme.bg_light = theme.surface0
theme.bg_dark = theme.crust

theme.fg_transparent = "#ffffff" .. "15"
theme.fg_normal = theme.text
theme.fg_dark = theme.subtext0

theme.border_width = dpi(2)
theme.border_radius = dpi(6)
theme.border_normal = theme.surface0
theme.border_focus = theme.lavender
theme.border_marked = theme.yellow

-- topbar config
theme.topbar_position = "top"
theme.topbar_height = dpi(40)

-- Icons
theme.icon_theme = icon_theme
theme.systray_icon_theme = systray_icon_theme
theme.icons = {
	left_arrow = theme_path .. "icons/left-arrow.png",
	right_arrow = theme_path .. "icons/right-arrow.png",
	music = theme_path .. "icons/music.png",
	screenshot = theme_path .. "icons/screenshot.png",
	settings = theme_path .. "icons/settings.png",
}

-- Close Button
theme.titlebar_close_button_normal = theme_path .. "titlebar/close-normal.png"
theme.titlebar_close_button_focus = theme_path .. "titlebar/close-focus.png"
theme.titlebar_close_button_normal_hover = theme_path .. "titlebar/close-normal-hover.png"
theme.titlebar_close_button_focus_hover = theme_path .. "titlebar/close-focus-hover.png"

-- Maximize Button
theme.titlebar_maximized_button_normal_inactive = theme_path .. "titlebar/maximize-normal-inactive.png"
theme.titlebar_maximized_button_focus_inactive = theme_path .. "titlebar/maximize-focus-inactive.png"
theme.titlebar_maximized_button_normal_active = theme_path .. "titlebar/maximize-normal-active.png"
theme.titlebar_maximized_button_focus_active = theme_path .. "titlebar/maximize-focus-active.png"
theme.titlebar_maximized_button_normal_inactive_hover = theme_path .. "titlebar/maximize-hover.png"
theme.titlebar_maximized_button_focus_inactive_hover = theme_path .. "titlebar/maximize-hover.png"
theme.titlebar_maximized_button_normal_active_hover = theme_path .. "titlebar/maximize-hover.png"
theme.titlebar_maximized_button_focus_active_hover = theme_path .. "titlebar/maximize-hover.png"

-- Minimize Button
theme.titlebar_minimize_button_normal = theme_path .. "titlebar/minimize-normal.png"
theme.titlebar_minimize_button_focus = theme_path .. "titlebar/minimize-focus.png"
theme.titlebar_minimize_button_normal_hover = theme_path .. "titlebar/minimize-hover.png"
theme.titlebar_minimize_button_focus_hover = theme_path .. "titlebar/minimize-hover.png"

-- Sticky Button
theme.titlebar_sticky_button_normal_inactive = theme_path .. "titlebar/sticky-normal-inactive.png"
theme.titlebar_sticky_button_focus_inactive = theme_path .. "titlebar/sticky-focus-inactive.png"
theme.titlebar_sticky_button_normal_active = theme_path .. "titlebar/sticky-normal-active.png"
theme.titlebar_sticky_button_focus_active = theme_path .. "titlebar/sticky-focus-active.png"

theme.wallpaper = theme_path .. "background.jpg"

-- You can use your own layout icons like this:
-- theme.layout_fairh = theme_path .. "layouts/fairhw.png"
-- theme.layout_fairv = theme_path .. "layouts/fairvw.png"
-- theme.layout_floating = theme_path .. "layouts/floatingw.png"
-- theme.layout_magnifier = theme_path .. "layouts/magnifierw.png"
-- theme.layout_max = theme_path .. "layouts/maxw.png"
-- theme.layout_fullscreen = theme_path .. "layouts/fullscreenw.png"
-- theme.layout_tilebottom = theme_path .. "layouts/tilebottomw.png"
-- theme.layout_tileleft = theme_path .. "layouts/tileleftw.png"
-- theme.layout_tile = theme_path .. "layouts/tilew.png"
-- theme.layout_tiletop = theme_path .. "layouts/tiletopw.png"
-- theme.layout_spiral = theme_path .. "layouts/spiralw.png"
-- theme.layout_dwindle = theme_path .. "layouts/dwindlew.png"
-- theme.layout_cornernw = theme_path .. "layouts/cornernww.png"
-- theme.layout_cornerne = theme_path .. "layouts/cornernew.png"
-- theme.layout_cornersw = theme_path .. "layouts/cornersww.png"
-- theme.layout_cornerse = theme_path .. "layouts/cornersew.png"

beautiful.init(theme)
