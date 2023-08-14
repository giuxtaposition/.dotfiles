local wezterm = require("wezterm")
local theme = require("theme")
local keymaps = require("keymaps")

local config = {}
-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.default_workspace = "home"

theme.apply_to_config(config)
keymaps.apply_to_config(config)

return config
