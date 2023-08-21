local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

-----------------------------------------------
-- setup
------------------------------------------------

local TopBar = function(s)
	-- Create the wibox
	local bar = awful.wibar({
		screen = s,
		position = beautiful.topbar_position,
		height = beautiful.topbar_height,
		bg = beautiful.bg_normal,
		fg = beautiful.fg_normal,
		type = "dock",
		border_width = 0,
		border_color = "#00000000",
	})

	-- Add widgets to the wibox
	bar:setup({
		layout = wibox.layout.align.horizontal,
		{ -- Left widgets
			layout = wibox.layout.fixed.horizontal,
			require("widgets.topbar.distro")[1],
			require("widgets.topbar.taglist")(s),
		},
		{ -- Middle widgets
			layout = wibox.layout.fixed.horizontal,
			require("widgets.topbar.tasklist")(s),
		},

		{ -- Right widgets
			layout = wibox.layout.fixed.horizontal,
			require("widgets.topbar.clock")[1],
		},
	})

	return bar
end

return TopBar
