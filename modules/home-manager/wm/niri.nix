{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (config.lib.niri) actions;
in {
  options = {niri.enable = lib.mkEnableOption "enables niri module";};

  config = lib.mkIf config.niri.enable {
    home.packages = with pkgs; [xwayland-satellite brightnessctl];

    programs.niri.settings = {
      input = {
        keyboard.xkb = {
          layout = "us";
          variant = "altgr-intl";
        };
        touchpad = {
          tap = true;
          dwt = true;
          dwtp = true;
          natural-scroll = true;
        };
        warp-mouse-to-focus.enable = true;
        focus-follows-mouse.enable = true;
      };

      layout = {
        gaps = 16;
        center-focused-column = "never";
        preset-column-widths = [
          {proportion = 0.33333;}
          {proportion = 0.5;}
          {proportion = 0.66667;}
        ];
        default-column-width = {};
        focus-ring.enable = false;
        border.enable = false;
      };

      spawn-at-startup = [
        {command = ["noctalia-shell"];}
        {command = ["xwayland-satellite"];}
        {
          command = [
            "cachix"
            "watch-store"
            "giuxtaposition"
          ];
        }
      ];

      prefer-no-csd = true;
      screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";

      window-rules = [
        {
          geometry-corner-radius = let
            r = 12.0;
          in {
            top-left = r;
            top-right = r;
            bottom-left = r;
            bottom-right = r;
          };
          clip-to-geometry = true;
        }
        {
          matches = [{app-id = "^spotify$";}];
          default-column-width = {proportion = 0.5;};
        }
        {
          matches = [{app-id = "^\\.blueman-manager-wrapped$";}];
          default-column-width = {proportion = 0.5;};
        }
        {
          matches = [
            {
              app-id = "^firefox$";
              title = "^Picture-in-Picture$";
            }
          ];
          open-floating = true;
        }
        {
          matches = [
            {
              app-id = "^\\.blueman-manager-wrapped$";
              title = "^Bluetooth Devices$";
            }
          ];
          open-floating = true;
        }
      ];

      layer-rules = [
        {
          matches = [{namespace = "^noctalia-overview";}];
          place-within-backdrop = true;
        }
      ];

      binds = {
        "Mod+Shift+Slash".action = actions."show-hotkey-overlay";

        "Mod+Q".action.spawn = ["kitty"];
        "Mod+D".action.spawn = ["noctalia-shell" "ipc" "call" "launcher" "toggle"];
        "Mod+P".action.spawn = ["noctalia-shell" "ipc" "call" "sessionMenu" "toggle"];

        "XF86AudioRaiseVolume" = {
          allow-when-locked = true;
          action.spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1+"];
        };
        "XF86AudioLowerVolume" = {
          allow-when-locked = true;
          action.spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1-"];
        };
        "XF86AudioMute" = {
          allow-when-locked = true;
          action.spawn = ["wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"];
        };
        "XF86AudioMicMute" = {
          allow-when-locked = true;
          action.spawn = ["wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle"];
        };
        "XF86MonBrightnessUp" = {
          allow-when-locked = true;
          action.spawn = ["brightnessctl" "--class=backlight" "set" "+10%"];
        };
        "XF86MonBrightnessDown" = {
          allow-when-locked = true;
          action.spawn = ["brightnessctl" "--class=backlight" "set" "10%-"];
        };

        "Mod+O" = {
          repeat = false;
          action = actions."toggle-overview";
        };
        "Mod+C".action = actions."close-window";

        "Mod+Left".action = actions."focus-column-left";
        "Mod+Down".action = actions."focus-window-down";
        "Mod+Up".action = actions."focus-window-up";
        "Mod+Right".action = actions."focus-column-right";
        "Mod+H".action = actions."focus-column-left";
        "Mod+J".action = actions."focus-window-down";
        "Mod+K".action = actions."focus-window-up";
        "Mod+L".action = actions."focus-column-right";

        "Mod+Ctrl+Left".action = actions."move-column-left";
        "Mod+Ctrl+Down".action = actions."move-window-down";
        "Mod+Ctrl+Up".action = actions."move-window-up";
        "Mod+Ctrl+Right".action = actions."move-column-right";
        "Mod+Ctrl+H".action = actions."move-column-left";
        "Mod+Ctrl+J".action = actions."move-window-down";
        "Mod+Ctrl+K".action = actions."move-window-up";
        "Mod+Ctrl+L".action = actions."move-column-right";

        "Mod+Home".action = actions."focus-column-first";
        "Mod+End".action = actions."focus-column-last";
        "Mod+Ctrl+Home".action = actions."move-column-to-first";
        "Mod+Ctrl+End".action = actions."move-column-to-last";

        "Mod+Shift+Left".action = actions."focus-monitor-left";
        "Mod+Shift+Down".action = actions."focus-monitor-down";
        "Mod+Shift+Up".action = actions."focus-monitor-up";
        "Mod+Shift+Right".action = actions."focus-monitor-right";
        "Mod+Shift+H".action = actions."focus-monitor-left";
        "Mod+Shift+J".action = actions."focus-monitor-down";
        "Mod+Shift+K".action = actions."focus-monitor-up";
        "Mod+Shift+L".action = actions."focus-monitor-right";

        "Mod+Shift+Ctrl+Left".action = actions."move-column-to-monitor-left";
        "Mod+Shift+Ctrl+Down".action = actions."move-column-to-monitor-down";
        "Mod+Shift+Ctrl+Up".action = actions."move-column-to-monitor-up";
        "Mod+Shift+Ctrl+Right".action = actions."move-column-to-monitor-right";
        "Mod+Shift+Ctrl+H".action = actions."move-column-to-monitor-left";
        "Mod+Shift+Ctrl+J".action = actions."move-column-to-monitor-down";
        "Mod+Shift+Ctrl+K".action = actions."move-column-to-monitor-up";
        "Mod+Shift+Ctrl+L".action = actions."move-column-to-monitor-right";

        "Mod+Page_Down".action = actions."focus-workspace-down";
        "Mod+Page_Up".action = actions."focus-workspace-up";
        "Mod+U".action = actions."focus-workspace-down";
        "Mod+I".action = actions."focus-workspace-up";

        "Mod+Ctrl+Page_Down".action = actions."move-column-to-workspace-down";
        "Mod+Ctrl+Page_Up".action = actions."move-column-to-workspace-up";
        "Mod+Ctrl+U".action = actions."move-column-to-workspace-down";
        "Mod+Ctrl+I".action = actions."move-column-to-workspace-up";

        "Mod+Shift+Page_Down".action = actions."move-workspace-down";
        "Mod+Shift+Page_Up".action = actions."move-workspace-up";
        "Mod+Shift+U".action = actions."move-workspace-down";
        "Mod+Shift+I".action = actions."move-workspace-up";

        "Mod+WheelScrollDown" = {
          cooldown-ms = 150;
          action = actions."focus-workspace-down";
        };
        "Mod+WheelScrollUp" = {
          cooldown-ms = 150;
          action = actions."focus-workspace-up";
        };
        "Mod+Ctrl+WheelScrollDown" = {
          cooldown-ms = 150;
          action = actions."move-column-to-workspace-down";
        };
        "Mod+Ctrl+WheelScrollUp" = {
          cooldown-ms = 150;
          action = actions."move-column-to-workspace-up";
        };

        "Mod+WheelScrollRight".action = actions."focus-column-right";
        "Mod+WheelScrollLeft".action = actions."focus-column-left";
        "Mod+Ctrl+WheelScrollRight".action = actions."move-column-right";
        "Mod+Ctrl+WheelScrollLeft".action = actions."move-column-left";

        "Mod+Shift+WheelScrollDown".action = actions."focus-column-right";
        "Mod+Shift+WheelScrollUp".action = actions."focus-column-left";
        "Mod+Ctrl+Shift+WheelScrollDown".action = actions."move-column-right";
        "Mod+Ctrl+Shift+WheelScrollUp".action = actions."move-column-left";

        "Mod+1".action.focus-workspace = 1;
        "Mod+2".action.focus-workspace = 2;
        "Mod+3".action.focus-workspace = 3;
        "Mod+4".action.focus-workspace = 4;
        "Mod+5".action.focus-workspace = 5;
        "Mod+6".action.focus-workspace = 6;
        "Mod+7".action.focus-workspace = 7;
        "Mod+8".action.focus-workspace = 8;
        "Mod+9".action.focus-workspace = 9;

        "Mod+Shift+1".action.move-column-to-workspace = 1;
        "Mod+Shift+2".action.move-column-to-workspace = 2;
        "Mod+Shift+3".action.move-column-to-workspace = 3;
        "Mod+Shift+4".action.move-column-to-workspace = 4;
        "Mod+Shift+5".action.move-column-to-workspace = 5;
        "Mod+Shift+6".action.move-column-to-workspace = 6;
        "Mod+Shift+7".action.move-column-to-workspace = 7;
        "Mod+Shift+8".action.move-column-to-workspace = 8;
        "Mod+Shift+9".action.move-column-to-workspace = 9;

        "Mod+Comma".action = actions."consume-window-into-column";
        "Mod+Period".action = actions."expel-window-from-column";
        "Mod+BracketLeft".action = actions."consume-or-expel-window-left";
        "Mod+BracketRight".action = actions."consume-or-expel-window-right";

        "Mod+R".action = actions."switch-preset-column-width";
        "Mod+Shift+R".action = actions."switch-preset-window-height";
        "Mod+Ctrl+R".action = actions."reset-window-height";
        "Mod+F".action = actions."maximize-column";
        "Mod+Shift+F".action = actions."fullscreen-window";
        "Mod+Shift+C".action = actions."center-column";

        "Mod+Minus".action.set-column-width = "-10%";
        "Mod+Equal".action.set-column-width = "+10%";
        "Mod+Shift+Minus".action.set-window-height = "-10%";
        "Mod+Shift+Equal".action.set-window-height = "+10%";

        "Mod+V".action = actions."toggle-window-floating";
        "Mod+Shift+V".action = actions."switch-focus-between-floating-and-tiling";

        "Print".action.screenshot = {};
        "Ctrl+Print".action.screenshot-screen = {};
        "Alt+Print".action.screenshot-window = {};

        "Mod+Shift+E".action = actions.quit;
        "Ctrl+Alt+Delete".action = actions.quit;
        "Mod+Shift+P".action = actions."power-off-monitors";
      };

      environment = {
        DISPLAY = ":0";
      };
    };
  };
}
