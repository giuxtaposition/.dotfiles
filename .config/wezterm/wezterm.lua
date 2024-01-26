local wezterm = require("wezterm")
local theme = require("theme")
local keymaps = require("keymaps")
local smart_splits = wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")

local config = {}
config = wezterm.config_builder()

config.default_workspace = "home"

theme.apply_to_config(config)
keymaps.apply_to_config(config)
smart_splits.apply_to_config(config, {
  direction_keys = { "h", "j", "k", "l" },
  modifiers = {
    move = "CTRL",
    resize = "META",
  },
})

return config
