---------------------------
-- custom awesome theme --
---------------------------
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local gfs = require("gears.filesystem")
local theme_path = gfs.get_configuration_dir() .. "themes/default/"
local theme = {}
local beautiful = require("beautiful")
local menubar_utils = require("menubar.utils")

beautiful.icon_theme = "candy-icons"

client.connect_signal("property::class", function(c)
	if not c.class then
		return
	end
	c.theme_icon = menubar_utils.lookup_icon(string.lower(c.class)) or c.icon
end)

theme.font = "JetBrainsMono Nerd Font 11"

-- theme colors
theme.blue = "#26BBD9"
theme.blue_light = "#3FC6DE"
theme.cyan = "#59E3E3"
theme.cyan_light = "#6BE6E6"
theme.green = "#29D398"
theme.green_light = "#3FDAA4"
theme.pink = "#EE64AE"
theme.pink_light = "#F075B7"
theme.red = "#E95678"
theme.red_light = "#EC6A88"
theme.yellow = "#FAB795"
theme.yellow_light = "#FBC3A7"
theme.purple = "#b4befe"
theme.purple_light = "#c4cbfd"
theme.grey = "#7f849c"

theme.bg_normal = "#1e1e2e"
theme.bg_light = "#313244"
theme.bg_dark = "#11111b"

theme.fg_normal = "#cdd6f4"
theme.fg_dark = "#a6adc8"

theme.border_width = dpi(2)
theme.border_normal = "#313244"
theme.border_focus = theme.purple
theme.border_marked = theme.yellow_light

-- topbar config
theme.topbar_position = "top"
theme.topbar_height = dpi(40)

-- regular
theme.titlebar_close_button_normal = theme_path .. "titlebar/close/close_1.png"
theme.titlebar_close_button_focus = theme_path .. "titlebar/close/close_2.png"
theme.titlebar_maximized_button_normal_inactive = theme_path .. "titlebar/maximize/maximize_1.png"
theme.titlebar_maximized_button_focus_inactive = theme_path .. "titlebar/maximize/maximize_2.png"
theme.titlebar_maximized_button_normal_active = theme_path .. "titlebar/maximize/maximize_3.png"
theme.titlebar_maximized_button_focus_active = theme_path .. "titlebar/maximize/maximize_3.png"
theme.titlebar_minimize_button_normal = theme_path .. "titlebar/minimize/minimize_1.png"
theme.titlebar_minimize_button_focus = theme_path .. "titlebar/minimize/minimize_2.png"

-- hover
theme.titlebar_close_button_normal_hover = theme_path .. "titlebar/close/close_3.png"
theme.titlebar_close_button_focus_hover = theme_path .. "titlebar/close/close_3.png"
theme.titlebar_maximized_button_normal_inactive_hover = theme_path .. "titlebar/maximize/maximize_3.png"
theme.titlebar_maximized_button_focus_inactive_hover = theme_path .. "titlebar/maximize/maximize_3.png"
theme.titlebar_maximized_button_normal_active_hover = theme_path .. "titlebar/maximize/maximize_3.png"
theme.titlebar_maximized_button_focus_active_hover = theme_path .. "titlebar/maximize/maximize_3.png"
theme.titlebar_minimize_button_normal_hover = theme_path .. "titlebar/minimize/minimize_3.png"
theme.titlebar_minimize_button_focus_hover = theme_path .. "titlebar/minimize/minimize_3.png"
theme.titlebar_height = dpi(28)

theme.wallpaper = theme_path .. "background.jpg"

-- You can use your own layout icons like this:
theme.layout_fairh = theme_path .. "layouts/fairhw.png"
theme.layout_fairv = theme_path .. "layouts/fairvw.png"
theme.layout_floating = theme_path .. "layouts/floatingw.png"
theme.layout_magnifier = theme_path .. "layouts/magnifierw.png"
theme.layout_max = theme_path .. "layouts/maxw.png"
theme.layout_fullscreen = theme_path .. "layouts/fullscreenw.png"
theme.layout_tilebottom = theme_path .. "layouts/tilebottomw.png"
theme.layout_tileleft = theme_path .. "layouts/tileleftw.png"
theme.layout_tile = theme_path .. "layouts/tilew.png"
theme.layout_tiletop = theme_path .. "layouts/tiletopw.png"
theme.layout_spiral = theme_path .. "layouts/spiralw.png"
theme.layout_dwindle = theme_path .. "layouts/dwindlew.png"
theme.layout_cornernw = theme_path .. "layouts/cornernww.png"
theme.layout_cornerne = theme_path .. "layouts/cornernew.png"
theme.layout_cornersw = theme_path .. "layouts/cornersww.png"
theme.layout_cornerse = theme_path .. "layouts/cornersew.png"

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

return theme
