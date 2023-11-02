local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

-- Double click titlebar timer, how long it takes for a 2 clicks to be considered a double click
function double_click_event_handler(double_click_event)
	if double_click_timer then
		double_click_timer:stop()
		double_click_timer = nil
		return true
	end

	double_click_timer = gears.timer.start_new(0.20, function()
		double_click_timer = nil
		return false
	end)
end

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
	-- new buttons for the titlebar, this allows you to double click and toggle maximization of client
	local buttons = awful.util.table.join(
		buttons,
		awful.button({}, 1, function()
			c:emit_signal("request::activate", "titlebar", { raise = true })
			-- WILL EXECUTE THIS ON DOUBLE CLICK
			if double_click_event_handler() then
				c.maximized = not c.maximized
				c:raise()
			else
				awful.mouse.client.move(c)
			end
		end),
		awful.button({}, 3, function()
			c:emit_signal("request::activate", "titlebar", { raise = true })
			awful.mouse.client.resize(c)
		end)
	)

	awful
		.titlebar(c, {
			height = 20,
			size = 35,
			position = "left",
			bg_normal = beautiful.bg_dark,
			bg_focus = beautiful.bg_dark,
		})
		:setup({
			{ -- Left
				{
					awful.titlebar.widget.closebutton(c),
					awful.titlebar.widget.maximizedbutton(c),
					awful.titlebar.widget.minimizebutton(c),

					spacing = 0,
					layout = wibox.layout.fixed.vertical(),
				},
				widget = wibox.container.margin,
				top = 2,
				bottom = 0,
				right = 6,
				left = 3,
			},
			{
				-- Middle
				buttons = buttons,
				layout = wibox.layout.flex.horizontal,
			},
			{ -- Right
				{
					awful.titlebar.widget.stickybutton(c),
					layout = wibox.layout.fixed.vertical(),
				},
				widget = wibox.container.margin,
				top = 0,
				bottom = 0,
				right = 6,
				left = 3,
			},
			layout = wibox.layout.align.vertical,
		})
end)
