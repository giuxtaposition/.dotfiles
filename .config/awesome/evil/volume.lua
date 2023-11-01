local watch = require("awful.widget.watch")

local handleVolume = function(stdout)
	local mute = string.match(stdout, "false") ~= nil and "on" or "off"
	local volume = string.match(stdout, "%d+")
	volume = volume ~= nil and tonumber(volume) or 0

	local icon = ""

	if mute == "off" then
		icon = ""
	elseif volume > 50 then
		icon = ""
	elseif volume > 5 then
		icon = ""
	else
		icon = ""
	end

	awesome.emit_signal("evil::volume", {
		value = volume,
		image = icon,
	})
end

watch("sh -c 'pamixer --get-volume-human && pamixer --get-mute'", 1, function(_, stdout, _, _, _)
	handleVolume(stdout)
end, nil)
