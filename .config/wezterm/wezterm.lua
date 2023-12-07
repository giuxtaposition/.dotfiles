local wezterm = require("wezterm")
local theme = require("theme")
local keymaps = require("keymaps")

local config = {}
config = wezterm.config_builder()

config.default_workspace = "home"
config.enable_wayland = false

theme.apply_to_config(config)
keymaps.apply_to_config(config)

return config
