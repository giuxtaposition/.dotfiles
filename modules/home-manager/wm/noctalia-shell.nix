{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.noctalia.homeModules.default
  ];

  options = {
    noctalia-shell.enable = lib.mkEnableOption "enables noctalia shell module";
  };

  config = lib.mkIf config.noctalia-shell.enable {
    programs.noctalia = {
      enable = true;
      package = inputs.noctalia.packages.${pkgs.system}.default;
      settings = {
        shell = {
          avatar_path = "${config.home.homeDirectory}/.dotfiles/assets/avatar.jpg";
        };

        theme = {
          mode = "dark";
          source = "builtin";
          builtin = "Tokyo-Night";
        };

        bar.main = {
          position = "left";
          capsule = false;
          start = ["control-center" "launcher"];
          center = ["workspaces"];
          end = ["tray" "clock"];
        };

        widget.clock = {
          format = "{:%H:%M}";
          vertical_format = "{:%H\n%M}";
        };

        location = {
          address = "Rimini, Italy";
        };

        nightlight = {
          enabled = true;
        };

        wallpaper = {
          enabled = true;
          directory = "${config.home.homeDirectory}/.dotfiles/Wallpapers";
          default.path = "${config.home.homeDirectory}/.dotfiles/Wallpapers/alena-aenami-lost-1k.jpg";
        };
      };
    };
  };
}
