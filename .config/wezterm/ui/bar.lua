local w = require("wezterm")
local icons = require("ui.icons")
local spotify = require("utils.spotify")

local M = {}

local function should_hide_cwd_uri(process_name)
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

local function basename(s)
  return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

local function tab_title(tab_info)
  local process_name = basename(tab_info.active_pane.foreground_process_name)

  local process = w.format(icons.process_icons[process_name] or { { Text = string.format("[%s]", process_name) } })

  local cwd = should_hide_cwd_uri(process_name) and "" or basename(tab_info.active_pane.current_working_dir.file_path)

  return process .. " " .. cwd
end

M.tabs = function()
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

    local title = tab_title(tab)

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

M.right_status = function()
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
    local cwd = basename(cwd_uri.file_path)
    table.insert(cells, w.nerdfonts.md_folder .. " " .. cwd)

    local cmd = basename(pane:get_foreground_process_name())
    table.insert(cells, w.nerdfonts.fa_code .. "  " .. cmd)

    local time = w.strftime("%H:%M")
    table.insert(cells, w.nerdfonts.md_clock .. " " .. time)

    local playing = spotify.get_currently_playing(64, 5)
    if playing ~= "" then
      table.insert(cells, w.nerdfonts.md_music_note .. " " .. playing .. " ")
    end

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
end

return M
