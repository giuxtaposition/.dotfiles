local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local wibox = require("wibox")

local get_tasklist = function(s)
	local tasklist = awful.widget.tasklist({
		screen = s,
		filter = awful.widget.tasklist.filter.currenttags,
		style = {
			shape = gears.shape.rounded_bar,
		},
		widget_template = {
			{
				{
					{
						{
							{
								id = "icon_role",
								widget = wibox.widget.imagebox,
							},
							left = 0,
							right = 5,
							top = 2,
							bottom = 2,
							widget = wibox.container.margin,
						},
						{
							id = "text_role",
							font = "JetBrainsMono Nerd Font 9",
							widget = wibox.widget.textbox,
						},
						layout = wibox.layout.fixed.horizontal,
					},
					left = 5,
					right = 5,
					top = 0,
					bottom = 2,
					widget = wibox.container.margin,
				},
				fg = beautiful.fg_normal,
				bg = beautiful.bg_light,

				shape = gears.shape.rounded_bar,
				widget = wibox.container.background,
			},
			top = 6,
			bottom = 6,
			left = 6,
			right = 6,
			widget = wibox.container.margin,
		},
	})

	return tasklist
end

return get_tasklist
