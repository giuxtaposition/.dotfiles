local wezterm = require("wezterm")
local ui = require("ui")
local keymaps = require("keymaps")
local smart_splits = wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")

local config = wezterm.config_builder()

config.default_workspace = "home"
config.front_end = "WebGpu"

ui.apply_to_config(config)
keymaps.apply_to_config(config)
smart_splits.apply_to_config(config, {
  direction_keys = { "h", "j", "k", "l" },
  modifiers = {
    move = "CTRL",
    resize = "META",
  },
})

return config
