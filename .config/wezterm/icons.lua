local wezterm = require("wezterm")

local process_icons = {
	["nvim"] = {
		{ Text = wezterm.nerdfonts.custom_vim },
	},
	["fish"] = {
		{ Text = wezterm.nerdfonts.md_fish },
	},
}

local RIGHT_TAB_EDGE = wezterm.nerdfonts.ple_lower_left_triangle
local LEFT_TAB_EDGE = wezterm.nerdfonts.ple_lower_right_triangle

return {
	process_icons = process_icons,
	LEFT_TAB_EDGE = LEFT_TAB_EDGE,
	RIGHT_TAB_EDGE = RIGHT_TAB_EDGE,
}
