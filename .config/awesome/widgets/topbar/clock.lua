local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local clock_format = "%A %B %d, %H:%M"
local clock = wibox.widget.textclock()
clock.format = "<span foreground='" .. beautiful.fg_dark .. "'>" .. clock_format .. "</span>"

-- Clock widget
local clock_widget = {
	{
		{
			{
				{
					widget = clock,
				},
				left = 6,
				right = 6,
				top = 0,
				bottom = 0,
				widget = wibox.container.margin,
			},
			shape = gears.shape.rounded_bar,
			fg = beautiful.purple,
			bg = beautiful.bg_light,
			widget = wibox.container.background,
		},
		top = 6,
		bottom = 6,
		left = 6,
		right = 6,
		widget = wibox.container.margin,
	},
	spacing = 5,
	layout = wibox.layout.fixed.horizontal,
}

return clock_widget
