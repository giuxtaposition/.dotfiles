local wezterm = require("wezterm")
local act = wezterm.action

local module = {}

function module.apply_to_config(config)
  config.disable_default_key_bindings = true
  config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
  config.keys = {
    { key = "a", mods = "LEADER|CTRL", action = act.SendKey({ key = "a", mods = "CTRL" }) },

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
    { key = "T", mods = "LEADER", action = act.CloseCurrentTab({ confirm = true }) },

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

return module
