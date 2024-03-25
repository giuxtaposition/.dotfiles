local wezterm = require("wezterm")

local M = {}

M.process_icons = {
  ["nvim"] = {
    { Text = wezterm.nerdfonts.custom_vim },
  },
  ["fish"] = {
    { Text = wezterm.nerdfonts.md_fish },
  },
  ["node"] = {
    { Text = wezterm.nerdfonts.dev_nodejs_small },
  },
  ["git"] = {
    { Text = wezterm.nerdfonts.dev_git },
  },
  ["bash"] = {
    { Text = wezterm.nerdfonts.md_bash },
  },
  ["nix"] = {
    { Text = wezterm.nerdfonts.linux_nixos },
  },
  ["lazygit"] = {
    { Text = wezterm.nerdfonts.cod_github },
  },
  -- for some weird reason nixos has no process name...
  [""] = {
    { Text = wezterm.nerdfonts.linux_nixos },
  },
}
M.RIGHT_TAB_EDGE = wezterm.nerdfonts.ple_lower_left_triangle
M.LEFT_TAB_EDGE = wezterm.nerdfonts.ple_lower_right_triangle

return M
