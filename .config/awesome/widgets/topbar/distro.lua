local wibox = require("wibox")
local beautiful = require("beautiful")

-- Distro widget
local distro_widget = {
	{
		{
			markup = "<span foreground='" .. beautiful.cyan_light .. "'> </span>",
			font = "JetBrainsMono Nerd Font 15",
			widget = wibox.widget.textbox,
		},
		left = 8,
		right = 8,
		top = 2,
		bottom = 3,
		widget = wibox.container.margin,
	},
	widget = wibox.container.background,
}
return distro_widget
