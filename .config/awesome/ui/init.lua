local top_bar = require("widgets.topbar.init")

-- Create top_bar widget for each screen
screen.connect_signal("request::desktop_decoration", function(s)
	s.top_bar = top_bar(s)
end)

-- Hide bars when app go fullscreen
function updateBarsVisibility()
	for s in screen do
		if s.selected_tag then
			local fullscreen = s.selected_tag.fullscreenMode

			-- Make sure a panel does exist on this specific screen, otherwise return
			if s.top_bar == nil then
				return
			end

			-- Set top_bar invisible when fullscreen
			s.top_bar.visible = not fullscreen
		end
	end
end

_G.tag.connect_signal("property::selected", function(t)
	updateBarsVisibility()
end)

_G.client.connect_signal("property::fullscreen", function(c)
	c.screen.selected_tag.fullscreenMode = c.fullscreen
	updateBarsVisibility()
end)

_G.client.connect_signal("unmanage", function(c)
	if c.fullscreen then
		c.screen.selected_tag.fullscreenMode = false
		updateBarsVisibility()
	end
end)
