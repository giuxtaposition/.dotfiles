local beautiful = require("beautiful")
local wibox = require("wibox")
local gears = require("gears")
local dpi = beautiful.xresources.apply_dpi

local icon_widget = wibox.widget({
	font = "FiraMono Nerd Font 10",
	widget = wibox.widget.textbox,
})
local level_widget = wibox.widget({
	markup = "0%",
	font = "Roboto Medium 10",
	widget = wibox.widget.textbox,
})

local battery_widget = wibox.widget({
	icon_widget,
	level_widget,
	spacing = dpi(4),
	layout = wibox.layout.fixed.horizontal,
})

local battery_widget_container = {
	{
		{
			{
				{
					widget = battery_widget,
				},
				left = 6,
				right = 6,
				top = 0,
				bottom = 0,
				widget = wibox.container.margin,
			},
			shape = gears.shape.rounded_bar,
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

awesome.connect_signal("evil::battery", function(battery)
	icon_widget.markup = "<span foreground='" .. beautiful.fg_dark .. "'>" .. battery.image .. "</span>"
	level_widget.markup = "<span foreground='" .. beautiful.fg_dark .. "'>" .. battery.value .. "%</span>"
end)

return battery_widget_container
