{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  # add the home manager module
  imports = [inputs.ags.homeManagerModules.default];

  options = {
    ags = {
      enable = lib.mkEnableOption "enables ags module";
      keyboard_name = lib.mkOption {
        type = lib.types.str;
        example = "1:1:AT_Translated_Set_2_keyboard";
      };
    };
  };

  config = lib.mkIf config.ags.enable {
    programs.ags = {
      enable = true;

      configDir =
        config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/.dotfiles/.config/ags";

      # additional packages to add to gjs's runtime
      extraPackages = with pkgs; [gtksourceview webkitgtk accountsservice];
    };

    home.packages = with pkgs; [
      sassc
      inotify-tools
      bun
      wl-gammarelay-rs
      libdbusmenu-gtk3
      lsof
      brightnessctl
    ];

    home.file."${config.home.homeDirectory}/.dotfiles/.config/ags/env.ts" = {
      text = ''
        const env = {
          KEYBOARD_NAME: "${config.ags.keyboard_name}"
        }
        export default env
      '';
    };
  };
}
