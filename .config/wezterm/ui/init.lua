local w = require("wezterm")
local bar = require("ui.bar")

local M = {}

function M.apply_to_config(config)
  config.color_scheme = "Tokyo Night Moon"

  config.tab_bar_at_bottom = true
  config.use_fancy_tab_bar = false
  config.hide_tab_bar_if_only_one_tab = true

  config.colors = {
    tab_bar = {
      background = "#1e1e2e",

      -- The new tab button that let you create new tabs
      new_tab = {
        bg_color = "#1e1e2e",
        fg_color = "#cdd6f4",
      },
      new_tab_hover = {
        -- The color of the background area for the tab
        bg_color = "#313244",
        -- The color of the text for the tab
        fg_color = "#cdd6f4",
      },
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

  config.font_size = 12.5

  config.window_frame = {
    font = w.font("JetBrains Mono Nerd Font"),
  }
  config.window_padding = { left = 4, right = 4, top = 1, bottom = 1 }
  config.window_background_opacity = 0.9

  bar.tabs()
  bar.right_status()
end

return M
