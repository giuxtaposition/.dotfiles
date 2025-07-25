local wezterm = require("wezterm")
local ui = require("ui")
local general = require("general")
local keymaps = require("keymaps")

local config = wezterm.config_builder()

config.default_workspace = "home"

ui.apply_to_config(config)
general.apply_to_config(config)
keymaps.apply_to_config(config)

return config
