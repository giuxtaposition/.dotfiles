local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

-- Clock widget
local clock_widget = {
	{
		{
			{
				{
					widget = wibox.widget.textclock(),
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
