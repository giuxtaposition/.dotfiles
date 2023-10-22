local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local wibox = require("wibox")

local get_tasklist = function(s)
	local cell = {
		{
			{
				{
					{
						{
							id = "icon",
							widget = wibox.widget.imagebox,
						},
						left = 0,
						right = 5,
						top = 2,
						bottom = 2,
						widget = wibox.container.margin,
					},
					{
						id = "text",
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
	}

	-- Called once per created tasklist
	function cell:create_callback(c, index, clients)
		local taskicon = self:get_children_by_id("icon")[1]

		-- Set the icon
		taskicon.image = c.theme_icon

		-- Also run the update callback immediately
		self:update_callback(c, index, clients)
	end

	-- Called every time particular set of properties of the client or tag change
	-- See: https://github.com/awesomeWM/awesome/blob/master/lib/awful/widget/tasklist.lua#L974
	function cell:update_callback(c, index, clients)
		-- local children = self.children
		-- local imagebox, textbox = children[1], children[2]
		--
		-- textbox.text = c.name or "Unknown"

		-- This is a good place to style your tasklist
		-- depending on whether client is selected, minimized, urgent, etc.
	end

	local tasklist = awful.widget.tasklist({
		screen = s,
		filter = awful.widget.tasklist.filter.currenttags,
		widget_template = cell,
		buttons = {
			awful.button({}, 1, function(c)
				c:activate({ context = "tasklist", action = "toggle_minimization" })
			end),
		},
	})

	return tasklist
end

return get_tasklist
