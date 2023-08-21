local gears = require("gears")
local awful = require("awful")

-- Mousebindings that occur on the desktop
desktopMouse = gears.table.join(

	-- This is the mousewheel on the unfocused desktop
	awful.button({}, 4, awful.tag.viewnext),
	awful.button({}, 5, awful.tag.viewprev)
)

return desktopMouse
