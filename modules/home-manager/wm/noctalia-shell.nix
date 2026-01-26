{
  lib,
  config,
  inputs,
  ...
}: {
  imports = [
    inputs.noctalia.homeModules.default
  ];

  options = {
    noctalia-shell.enable = lib.mkEnableOption "enables noctalia-shell shell module";
  };

  config = lib.mkIf config.noctalia-shell.enable {
    programs.noctalia-shell = {
      enable = true;
      settings = {
        bar = {
          position = "left";
          showCapsule = false;
          widgets = {
            left = [
              {
                id = "ControlCenter";
                useDistroLogo = true;
              }
              {
                id = "Launcher";
              }
              {
                id = "plugin:privacy-indicator";
              }
            ];
            center = [
              {
                hideUnoccupied = false;
                id = "Workspace";
                labelMode = "none";
              }
            ];
            right = [
              # {
              #   alwaysShowPercentage = false;
              #   id = "Battery";
              #   warningThreshold = 30;
              # }
              {
                id = "plugin:pomodoro";
              }
              {
                id = "Tray";
              }
              {
                formatHorizontal = "HH:mm";
                formatVertical = "HH mm";
                id = "Clock";
                useMonospacedFont = true;
                usePrimaryColor = true;
              }
            ];
          };
        };
        colorSchemes.predefinedScheme = "Tokyo Night";
        general = {
          avatarImage = "${config.home.homeDirectory}/.dotfiles/assets/avatar.jpg";
        };
        location = {
          monthBeforeDay = false;
          name = "Rimini, Italy";
        };
        nightLight = {
          enabled = true;
        };
        wallpaper = {
          "overviewEnabled" = true;
        };
        plugins = {
          sources = [
            {
              enabled = true;
              name = "Official Noctalia Plugins";
              url = "https://github.com/noctalia-dev/noctalia-plugins";
            }
          ];
          states = {
            privacy-indicator = {
              enabled = true;
              sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
            };
            pomodoro = {
              enabled = true;
              sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
            };
          };
          version = 1;
        };

        pluginSettings = {
          privacy-indicator = {
            hideInactiveStates = true;
          };
        };
      };
    };

    ## Setup wallpaper
    home.file.".cache/noctalia/wallpapers.json" = {
      text = builtins.toJSON {
        defaultWallpaper = "${config.home.homeDirectory}/.dotfiles/Wallpapers/alena-aenami-lost-1k.jpg";
        wallpapers = {
          "DP-1" = "/path/to/monitor/wallpaper.png";
        };
      };
    };
  };
}
