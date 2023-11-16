local wezterm = require("wezterm")

local process_icons = {
	["nvim"] = {
		{ Text = wezterm.nerdfonts.custom_vim },
	},
	["fish"] = {
		{ Text = wezterm.nerdfonts.md_fish },
	},
	["node"] = {
		{ Text = wezterm.nerdfonts.dev_nodejs_small },
	},
	["git"] = {
		{ Text = wezterm.nerdfonts.dev_git },
	},
	["bash"] = {
		{ Text = wezterm.nerdfonts.md_bash },
	},
}

local RIGHT_TAB_EDGE = wezterm.nerdfonts.ple_lower_left_triangle
local LEFT_TAB_EDGE = wezterm.nerdfonts.ple_lower_right_triangle

return {
	process_icons = process_icons,
	LEFT_TAB_EDGE = LEFT_TAB_EDGE,
	RIGHT_TAB_EDGE = RIGHT_TAB_EDGE,
}
