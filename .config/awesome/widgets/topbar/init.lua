local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

-----------------------------------------------
-- setup
------------------------------------------------

local clock = require("widgets.topbar.clock")
local systray = require("widgets.topbar.systray")

local calendar = require("widgets.topbar.calendar")({
	placement = "top_center",
	start_sunday = false,
	radius = 8,
	previous_month_button = 1,
	padding = 5,
	next_month_button = 3,
})

clock:connect_signal("button::press", function(_, _, _, button)
	if button == 1 then
		calendar.toggle()
	end
end)

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
		layout = wibox.layout.stack,
		expand = "none",
		{
			layout = wibox.layout.align.horizontal,
			{
				-- Left widgets
				layout = wibox.layout.fixed.horizontal,
				require("widgets.topbar.distro")[1],
				require("widgets.topbar.taglist")(s),
				require("widgets.topbar.tasklist")(s),
			},
			nil,
			{
				-- Right widgets
				layout = wibox.layout.fixed.horizontal,
				systray,
				require("widgets.topbar.battery")[1],
			},
		},
		{
			clock,
			valign = "center",
			halign = "center",
			layout = wibox.container.place,
		},
	})

	return bar
end

return TopBar
