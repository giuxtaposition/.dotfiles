local beautiful = require("beautiful")

local createPopup = require("widgets.popup.popup")

local popup = createPopup(beautiful.blue)

awesome.connect_signal("evil::volume", function(volume)
	popup.update(volume.value, volume.image)
end)

awesome.connect_signal("popup::volume", function(volume)
	if volume ~= nil then
		popup.updateValue(volume.amount)
	end
	popup.show()
end)
