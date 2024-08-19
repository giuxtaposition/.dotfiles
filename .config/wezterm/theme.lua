local w = require("wezterm")
local icons = require("icons")

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
  config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }
  config.window_background_opacity = 0.9

  w.on("update-right-status", function(window, pane)
    local cells = {}

    local stat = window:active_workspace()
    if window:active_key_table() then
      stat = window:active_key_table()
    end
    if window:leader_is_active() then
      stat = w.nerdfonts.md_lightbulb
    end

    table.insert(cells, stat)

    local cwd_uri = pane:get_current_working_dir()
    local cwd = M.basename(cwd_uri.file_path)
    table.insert(cells, w.nerdfonts.md_folder .. " " .. cwd)

    local cmd = M.basename(pane:get_foreground_process_name())
    table.insert(cells, w.nerdfonts.fa_code .. "  " .. cmd)

    local time = w.strftime("%H:%M")
    table.insert(cells, w.nerdfonts.md_clock .. " " .. time)

    local DIVIDER = "|"
    local text_fg = "#b4befe"
    local elements = {}
    local num_cells = 0

    local function push(text, is_last)
      table.insert(elements, { Foreground = { Color = text_fg } })
      table.insert(elements, { Text = " " .. text .. " " })

      if not is_last then
        table.insert(elements, { Text = DIVIDER })
      end
      num_cells = num_cells + 1
    end

    while #cells > 0 do
      local cell = table.remove(cells, 1)
      push(cell, #cells == 0)
    end

    window:set_right_status(w.format(elements))
  end)

  w.on("format-tab-title", function(tab, tabs, panes, _config, hover, max_width)
    local edge_background = "#181825"
    local background = "#1e1e2e"
    local foreground = "#cdd6f4"

    if tab.is_active then
      background = "#313244"
      foreground = "#b4befe"
    elseif hover then
      background = "#313244"
      foreground = "#cdd6f4"
    end

    local edge_foreground = background

    local title = M.tab_title(tab)

    return w.format({
      { Background = { Color = edge_background } },
      { Foreground = { Color = edge_foreground } },
      { Text = icons.LEFT_TAB_EDGE },
      { Background = { Color = background } },
      { Foreground = { Color = foreground } },
      { Text = title },
      { Background = { Color = edge_background } },
      { Foreground = { Color = edge_foreground } },
      { Text = icons.RIGHT_TAB_EDGE },
    })
  end)
end

function M.basename(s)
  return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

function M.should_hide_cwd_uri(process_name)
  local hide_cwd = {
    "btop",
    "yazi",
  }

  for _, name in ipairs(hide_cwd) do
    if name == process_name then
      return true
    end
  end
end

function M.tab_title(tab_info)
  local process_name = M.basename(tab_info.active_pane.foreground_process_name)
  local process = w.format(icons.process_icons[process_name] or { { Text = string.format("[%s]", process_name) } })

  local cwd = M.should_hide_cwd_uri(process_name) and ""
    or M.basename(tab_info.active_pane.current_working_dir.file_path)
  return process .. " " .. cwd
end

return M
