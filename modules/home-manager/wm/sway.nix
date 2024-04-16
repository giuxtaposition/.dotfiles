{ config, pkgs, lib, ... }:
let
  eww-bars = lib.concatMapStrings (x: x + "&")
    (map (m: "eww open bar --screen ${toString m.index} --id ${m.name}")
      (config.monitors));

  startScript = pkgs.writeShellScript "start" ''
    eww daemon &

    # initializing wallpaper daemon
    swww init &
    # setting wallpaper
    swww img ~/Wallpapers/WRztVWQ.jpg &

    dunst &

    #idle
    swayidle -w timeout 300 'swaylock -f -c 000000' \ timeout 600 'systemctl suspend' \ before-sleep 'swaylock -f -c 000000' &

    ${eww-bars}
  '';

  monitors = lib.concatMapStrings (x: x + "\n") (map (m:
    let
      resolution =
        "${toString m.width}x${toString m.height}@${toString m.refreshRate}Hz";
      position = "pos ${toString m.x} ${toString m.y}";
    in "output ${m.name} mode ${
      if m.enabled then
        "${resolution} ${position} scale ${toString m.scale}"
      else
        "disable"
    }") (config.monitors));

  keyboardOptions = if config.laptop.enable then
    "ctrl:swapcaps,grp:alt_shift_toggle"
  else
    "grp:alt_shift_toggle";

  themeColors = import ../../../colors.nix;
in {
  options = { sway.enable = lib.mkEnableOption "enables sway module"; };

  config = lib.mkIf config.sway.enable {

    home.sessionVariables = {
      XDG_CURRENT_DESKTOP = "sway";
      XDG_SESSION_DESKTOP = "sway";
    };

    wayland.windowManager.sway = {
      enable = true;
      package = pkgs.unstable.swayfx;
      xwayland = true;
      systemd = {
        enable = true; # beta
      };
      wrapperFeatures = {
        base = true;
        gtk = true;
      };
      config = {
        modifier = "Mod4";
        terminal = "foot";
        startup =
          [ { command = "${startScript}"; } { command = "${eww-bars}"; } ];
        bars = [ ];
        fonts = {
          names = [ "JetBrains Mono Nerd Font" ];
          size = 0.0;
        };
        gaps = {
          outer = 0;
          inner = 15;
          smartBorders = "off";
          smartGaps = false;
        };
        window = {
          border = 3;
          titlebar = false;
        };
        floating = {
          border = 3;
          titlebar = false;
        };
        focus = { wrapping = "yes"; };
        colors = {
          focused = {
            border = "${themeColors.lavender}";
            background = "${themeColors.base}";
            text = "${themeColors.text}";
            indicator = "${themeColors.lavender}";
            childBorder = "${themeColors.lavender}";
          };
          focusedInactive = {
            border = "${themeColors.overlay0}";
            background = "${themeColors.base}";
            text = "${themeColors.text}";
            indicator = "${themeColors.lavender}";
            childBorder = "${themeColors.lavender}";
          };
          unfocused = {
            border = "${themeColors.overlay0}";
            background = "${themeColors.base}";
            text = "${themeColors.text}";
            indicator = "${themeColors.lavender}";
            childBorder = "${themeColors.mauve}";
          };
          urgent = {
            border = "${themeColors.peach}";
            background = "${themeColors.base}";
            text = "${themeColors.peach}";
            indicator = "${themeColors.overlay0}";
            childBorder = "${themeColors.peach}";
          };
          placeholder = {
            border = "${themeColors.overlay0}";
            background = "${themeColors.base}";
            text = "${themeColors.text}";
            indicator = "${themeColors.overlay0}";
            childBorder = "${themeColors.overlay0}";
          };
          background = "${themeColors.base}";
        };

        input = {
          "type:keyboard" = {
            xkb_options = "${keyboardOptions}";
            xkb_layout = "us,it";
            pointer_accel = "0";
          };
          "type:pointer" = { natural_scroll = "enabled"; };
          "type:touchpad" = {
            tap = "enabled";
            natural_scroll = "disabled";
            accel_profile = "adaptive";
          };
        };

        focus = { followMouse = "yes"; };

        keybindings = let
          mod = "Mod4"; # Super
          term = "wezterm";
          app-menu = ''exec ags --toggle-window "launcher-0"'';
          power-menu = "$HOME/.config/eww/scripts/toggle_powermenu.sh open";
        in {
          "${mod}+q" = "exec ${term}";
          "${mod}+d" = "exec ${app-menu}";
          "${mod}+Shift+p" = "exec ${power-menu}";
          "${mod}+c" = "kill";
          "${mod}+f1" = "reload";

          # Screenshot
          "Print" = ''
            exec grim -g "$(slurp)" - | wl-copy && wl-paste > ~/Pictures/Screenshots/Screenshot-$(date +%F_%T).png | dunstify "Screenshot of the region taken" -t 1000'';
          # Screenshot of a region
          "Shift+Print" = ''
            exec grim - | wl-copy && wl-paste > ~/Pictures/Screenshots/Screenshot-$(date +%F_%T).png | dunstify "Screenshot of whole screen taken" -t 1000'';

          # Move your focus around
          "${mod}+h" = "focus left";
          "${mod}+j" = "focus down";
          "${mod}+k" = "focus up";
          "${mod}+l" = "focus right";
          # Or use $mod+[up|down|left|right]
          "${mod}+Left" = "focus left";
          "${mod}+Down" = "focus down";
          "${mod}+Up" = "focus up";
          "${mod}+Right" = "focus right";

          # Move the focused window with the same, but add Shift
          "${mod}+Shift+h" = "move left";
          "${mod}+Shift+j" = "move down";
          "${mod}+Shift+k" = "move up";
          "${mod}+Shift+l" = "move right";
          # Ditto, with arrow keys
          "${mod}+Shift+Left" = "move left";
          "${mod}+Shift+Down" = "move down";
          "${mod}+Shift+Up" = "move up";
          "${mod}+Shift+Right" = "move right";

          # Switch to workspace
          "${mod}+1" = "workspace number 1";
          "${mod}+2" = "workspace number 2";
          "${mod}+3" = "workspace number 3";
          "${mod}+4" = "workspace number 4";
          "${mod}+5" = "workspace number 5";
          "${mod}+6" = "workspace number 6";
          "${mod}+7" = "workspace number 7";
          "${mod}+8" = "workspace number 8";
          "${mod}+9" = "workspace number 9";
          "${mod}+0" = "workspace number 10";
          "${mod}+Tab" = "workspace back_and_forth";

          # Move focused container to workspace
          "${mod}+Shift+1" = "move container to workspace number 1";
          "${mod}+Shift+2" = "move container to workspace number 2";
          "${mod}+Shift+3" = "move container to workspace number 3";
          "${mod}+Shift+4" = "move container to workspace number 4";
          "${mod}+Shift+5" = "move container to workspace number 5";
          "${mod}+Shift+6" = "move container to workspace number 6";
          "${mod}+Shift+7" = "move container to workspace number 7";
          "${mod}+Shift+8" = "move container to workspace number 8";
          "${mod}+Shift+9" = "move container to workspace number 9";
          "${mod}+Shift+0" = "move container to workspace number 10";

          # Layout
          "${mod}+v" = "splith";
          "${mod}+b" = "splitv";

          # Switch the current container between different layout styles
          "${mod}+s" = "layout stacking";
          "${mod}+t" = "layout tabbed";
          "${mod}+e" = "layout toggle split";

          # Make the current focus fullscreen
          "${mod}+f" = "fullscreen";

          # Toggle the current focus between tiling and floating mode
          "${mod}+Shift+space" = "floating toggle";

          # Swap focus between the tiling area and the floating area
          "${mod}+space" = "focus mode_toggle";

          "${mod}+r" = ''mode "resize"'';

          # Audio
          "XF86AudioRaiseVolume" = "exec pamixer -i 3";
          "XF86AudioLowerVolume" = "exec pamixer -d 3";
          "XF86AudioMute" = "exec pamixer -t";
          "XF86AudioMicMute" =
            "exec wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";

          "XF86MonBrightnessDown" = "exec brightnessctl set 3%-";
          "XF86MonBrightnessUp" = "exec brightnessctl set +3%";
        };
      };
      extraConfig = ''
        # SwayFX settings
        layer_effects "gtk-layer-shell" blur enable; shadows enable; corner_radius 13

        smart_corner_radius enable
        corner_radius 15
        shadows enable
        shadows_on_csd enable
        shadow_blur_radius 20

        # blur
        blur enable
        blur_radius 7
        blur_passes 4

        for_window [app_id="foot"] blur enable

        # dim inactive
        default_dim_inactive 0.0

        ${monitors}

        # set floating (nontiling)for apps needing it:
        for_window [app_id="blueman-manager"] floating enable, resize set width 40 ppt height 30 ppt

        # set floating (nontiling) for special apps:
        for_window [class="qt5ct" instance="qt5ct"] floating enable, resize set width 60 ppt height 50 ppt

        # set floating for window roles
        for_window [window_role="pop-up"] floating enable
        for_window [window_role="bubble"] floating enable
        for_window [window_role="task_dialog"] floating enable
        for_window [window_role="Preferences"] floating enable
        for_window [window_type="dialog"] floating enable
        for_window [window_type="menu"] floating enable
        for_window [window_role="About"] floating enable
        for_window [title="File Operation Progress"] floating enable, border pixel 1, sticky enable, resize set width 40 ppt height 30 ppt
        for_window [title="Picture in picture"] floating enable, sticky enable
        for_window [title="Save File"] floating enable
        for_window [app_id="qalculate-gtk"] floating enable

        # keep sharing popup in workspace 5
        assign [title="is sharing your screen"] -> number 5


        # Inhibit idle
        for_window [class=".*"] inhibit_idle fullscreen
        for_window [app_id=".*"] inhibit_idle fullscreen

        # Title format for windows
        for_window [shell="xdg_shell"] title_format "%title (%app_id)"
        for_window [shell="x_wayland"] title_format "%class - %title"

        assign [class="Spotify"]                    9
      '';
    };
  };

}
