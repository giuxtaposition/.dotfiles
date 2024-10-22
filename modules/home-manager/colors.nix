{ lib, ... }:
with lib;
let

  colors = {
    fg = "#cdd6f4";
    bg = "#1e1e2e";
    dark_bg = "#181825";
    darker_bg = "#11111b";
    selection_bg = "#313244";
    grey = "#6c7086";
    green = "#20e3b2";
    mauve = "#c197fd";
    purple = "#8d92ff";
    dark_purple = "#414171";
    darker_purple = "#23233d";
    lilac = "#9a86fd";
    sky = "#40cceb";
    indigo = "#6272a4";
    orange = "#ffb86c";
    red = "#ff5555";
    yellow = "#fde181";
    dark_yellow = "#e5c698";
    pink = "#ff6bcb";
  };

  colornames = builtins.attrNames colors;
in {
  options.colors = builtins.listToAttrs (map (c: {
    name = c;
    value = mkOption { type = types.str; };
  }) colornames);

  options.colorsWithoutPrefix = builtins.listToAttrs (map (c: {
    name = c;
    value = mkOption { type = types.str; };
  }) colornames);

  config.colors = colors;

  config.colorsWithoutPrefix = builtins.mapAttrs
    (name: value: builtins.substring 1 (builtins.stringLength value - 1) value)
    colors;
}

