local wibox = require("wibox")
local beautiful = require("beautiful")

-- Distro widget
local distro_widget = {
	{
		{
			text = " ",
			font = "JetBrainsMono Nerd Font 15",
			widget = wibox.widget.textbox,
		},
		left = 8,
		right = 0,
		top = 2,
		bottom = 3,
		widget = wibox.container.margin,
	},
	fg = beautiful.cyan_light,
	widget = wibox.container.background,
}
return distro_widget
