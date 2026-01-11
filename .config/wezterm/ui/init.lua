local w = require("wezterm")
local bar = require("ui.bar")

local M = {}

function M.apply_to_config(config)
  config.color_scheme = "Catppuccin Mocha"

  config.tab_bar_at_bottom = true
  config.use_fancy_tab_bar = false
  config.hide_tab_bar_if_only_one_tab = true

  config.colors = {
    tab_bar = {
      background = "#1e1e2e",
    },
  }

  config.underline_thickness = 3
  config.underline_position = -2
  config.cursor_thickness = 1
  config.default_cursor_style = "BlinkingBar"
  config.cursor_blink_rate = 800

  config.font = w.font_with_fallback({
    "JetBrainsMono Nerd Font",
    "Symbols Nerd Font Mono",
    "Noto Color Emoji",
  })

  config.font_size = 11.0

  config.window_frame = {
    font = w.font("JetBrains Mono Nerd Font"),
  }
  config.window_padding = { left = 2, right = 2, top = 1, bottom = 1 }
  config.window_background_opacity = 1

  bar.tabs()
  bar.right_status()
end

return M
