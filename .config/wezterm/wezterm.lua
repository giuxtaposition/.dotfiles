local wezterm = require("wezterm")
local theme = require("theme")
local keymaps = require("keymaps")

local mux = wezterm.mux
local config = {}
config = wezterm.config_builder()

config.default_workspace = "home"

-- start terminal maximized
wezterm.on("gui-startup", function(cmd)
	local tab, pane, window = mux.spawn_window(cmd or {})
	window:gui_window():maximize()
end)

theme.apply_to_config(config)
keymaps.apply_to_config(config)

return config
