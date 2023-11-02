local wibox = require("wibox")
local beautiful = require("beautiful")

local clock = wibox.widget.textclock(
	'<span color="' .. beautiful.fg_dark .. '" font="JetBrains Mono Nerd Font 13"> %a %b %d, %H:%M </span>',
	10
)
return clock
