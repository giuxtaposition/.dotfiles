local wezterm = require("wezterm")
local theme = require("theme")
local keymaps = require("keymaps")

local mux = wezterm.mux
local config = {}
-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.default_workspace = "home"
config.default_prog = { "/usr/bin/fish", "-l" } -- use fish as shell

-- start terminal maximized
wezterm.on("gui-startup", function(cmd)
	local tab, pane, window = mux.spawn_window(cmd or {})
	window:gui_window():maximize()
end)

theme.apply_to_config(config)
keymaps.apply_to_config(config)

return config
