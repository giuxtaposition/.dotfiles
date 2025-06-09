local wezterm = require("wezterm")
local act = wezterm.action

local M = {}

local function is_vim(pane)
  -- this is set by the plugin, and unset on ExitPre in Neovim
  return pane:get_user_vars().IS_NVIM == "true"
end

local direction_keys = {
  h = "Left",
  j = "Down",
  k = "Up",
  l = "Right",
  LeftArrow = "Left",
  DownArrow = "Down",
  UpArrow = "Up",
  RightArrow = "Right",
}

local function split_nav(resize_or_move, key)
  return {
    key = key,
    mods = resize_or_move == "resize" and "META" or "CTRL",
    action = wezterm.action_callback(function(win, pane)
      if is_vim(pane) then
        -- pass the keys through to vim/nvim
        win:perform_action({
          SendKey = { key = key, mods = resize_or_move == "resize" and "META" or "CTRL" },
        }, pane)
      else
        if resize_or_move == "resize" then
          win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
        else
          win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
        end
      end
    end),
  }
end

function M.apply_to_config(config)
  config.disable_default_key_bindings = true
  config.leader = { key = "Enter", mods = "CTRL", timeout_milliseconds = 1000 }
  config.keys = {
    -- Window pane
    {
      key = "v",
      mods = "LEADER",
      action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
    },
    {
      key = "b",
      mods = "LEADER",
      action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
    },

    { key = "q", mods = "LEADER", action = act.CloseCurrentPane({ confirm = false }) },
    { key = "z", mods = "LEADER", action = act.TogglePaneZoomState },

    -- Tabs
    { key = "t", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
    { key = "[", mods = "LEADER", action = act.ActivateTabRelative(-1) },
    { key = "]", mods = "LEADER", action = act.ActivateTabRelative(1) },
    { key = "n", mods = "LEADER", action = act.ShowTabNavigator },
    { key = "d", mods = "LEADER", action = act.CloseCurrentTab({ confirm = true }) },

    -- Workspaces
    {
      key = "W",
      mods = "LEADER",
      action = act.PromptInputLine({
        description = wezterm.format({
          { Attribute = { Intensity = "Bold" } },
          { Foreground = { AnsiColor = "Purple" } },
          { Text = "Enter name for new workspace" },
        }),
        action = wezterm.action_callback(function(window, pane, line)
          if line then
            window:perform_action(
              act.SwitchToWorkspace({
                name = line,
              }),
              pane
            )
          end
        end),
      }),
    },
    { key = "w", mods = "LEADER", action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) },

    -- Scroll
    { key = "k", mods = "CTRL|SHIFT", action = act.ScrollByLine(-1) },
    { key = "j", mods = "CTRL|SHIFT", action = act.ScrollByLine(1) },
    { key = "k", mods = "CTRL", action = act.ScrollByPage(-0.5) },
    { key = "j", mods = "CTRL", action = act.ScrollByPage(0.5) },
    { key = "g", mods = "LEADER", action = act.ScrollToBottom },
    { key = "G", mods = "LEADER", action = act.ScrollToTop },

    { key = "v", mods = "CTRL|SHIFT", action = act.PasteFrom("Clipboard") },
    { key = "c", mods = "CTRL|SHIFT", action = act.CopyTo("Clipboard") },
    { key = "f", mods = "CTRL|SHIFT", action = act.Search({ CaseInSensitiveString = "" }) },
    { key = "F", mods = "CTRL|SHIFT", action = act.Search({ CaseSensitiveString = "" }) },
    { key = "X", mods = "CTRL|SHIFT", action = act.ActivateCopyMode },
    {
      key = "p",
      mods = "LEADER",
      action = act.ActivateCommandPalette,
    },

    -- move between split panes
    split_nav("move", "h"),
    split_nav("move", "j"),
    split_nav("move", "k"),
    split_nav("move", "l"),
    -- resize panes
    split_nav("resize", "h"),
    split_nav("resize", "j"),
    split_nav("resize", "k"),
    split_nav("resize", "l"),
    -- move between split panes
    split_nav("move", "LeftArrow"),
    split_nav("move", "DownArrow"),
    split_nav("move", "UpArrow"),
    split_nav("move", "RightArrow"),
    -- resize panes
    split_nav("resize", "LeftArrow"),
    split_nav("resize", "DownArrow"),
    split_nav("resize", "UpArrow"),
    split_nav("resize", "RightArrow"),
  }

  -- <leader> + index to quickly navigate to tab with index
  for i = 1, 9 do
    table.insert(config.keys, {
      key = tostring(i),
      mods = "LEADER",
      action = act.ActivateTab(i - 1),
    })
  end
end

return M
