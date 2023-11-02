local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local wibox = require("wibox")
local dpi = require("beautiful.xresources").apply_dpi
local modKey = require("configuration.keymaps").modKey

local get_taglist = function(s)
	-- Taglist buttons

	local taglist_buttons = gears.table.join(
		awful.button({}, 1, function(t)
			t:view_only()
		end),
		awful.button({ modKey }, 1, function(t)
			if client.focus then
				client.focus:move_to_tag(t)
			end
		end),
		awful.button({}, 3, awful.tag.viewtoggle),
		awful.button({ modKey }, 3, function(t)
			if client.focus then
				client.focus:toggle_tag(t)
			end
		end),
		awful.button({}, 4, function(t)
			awful.tag.viewnext(t.screen)
		end),
		awful.button({}, 5, function(t)
			awful.tag.viewprev(t.screen)
		end)
	)

	----------------------------------------------------------------------

	local unfocus_icon = " "
	local unfocus_color = beautiful.grey

	local empty_icon = " "
	local empty_color = beautiful.grey

	local focus_icon = " "
	local focus_color = beautiful.purple

	----------------------------------------------------------------------

	-- Function to update the tags
	local update_tags = function(self, c3)
		local tag_icon = self:get_children_by_id("icon_role")[1]
		local tag_color
		if c3.selected then
			tag_icon.text = focus_icon
			tag_color = focus_color
		elseif #c3:clients() == 0 then
			tag_icon.text = empty_icon
			tag_color = empty_color
		else
			tag_icon.text = unfocus_icon
			tag_color = unfocus_color
		end

		self.prev_color = tag_color
		self.fg = tag_color

		self:connect_signal("mouse::enter", function()
			local hover_color = beautiful.purple_light
			self.fg = hover_color
		end)
		self:connect_signal("mouse::leave", function()
			self.fg = self.prev_color
		end)
	end

	----------------------------------------------------------------------

	local icon_taglist = awful.widget.taglist({
		screen = s,
		filter = awful.widget.taglist.filter.all,
		layout = { spacing = 0, layout = wibox.layout.fixed.horizontal },
		widget_template = {
			{
				{ id = "icon_role", font = "JetBrainsMono Nerd Font 12", widget = wibox.widget.textbox },
				id = "margin_role",
				top = dpi(0),
				bottom = dpi(0),
				left = dpi(2),
				right = dpi(2),
				widget = wibox.container.margin,
			},
			id = "background_role",
			widget = wibox.container.background,
			create_callback = function(self, c, index, objects)
				update_tags(self, c)
			end,

			update_callback = function(self, c, index, objects)
				update_tags(self, c)
			end,
		},
		buttons = taglist_buttons,
	})

	return icon_taglist
end

return get_taglist
