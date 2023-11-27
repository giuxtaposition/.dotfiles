{ config, pkgs, ... }: {

  home.packages = with pkgs; [
    unstable.swww # wallpaper manager
    rofi-wayland # rofi for wayland
    wl-clipboard # command-line copy/paste utilities for wayland
    slurp # select a region in a wayland compositor
    grim # grab images from a wayland compositor
  ];

  # Wallpapers folder
  home.file."${config.home.homeDirectory}/Wallpapers" = {
    source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/.dotfiles/Wallpapers";
  };

  # Rofi config
  home.file."${config.home.homeDirectory}/.config/rofi" = {
    source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/.dotfiles/.config/rofi";
  };

  wayland.windowManager.hyprland = let
    startScript = pkgs.writeShellScript "start" ''
      # initializing wallpaper daemon
      swww init &
      # setting wallpaper
      swww img ~/Wallpapers/WRztVWQ.jpg &
      # start eww
      eww open bar

      dunst
    '';

    colors = import ../../colors.nix;
  in {
    enable = true;
    enableNvidiaPatches = true;
    xwayland.enable = true;
    extraConfig = ''
      exec-once=bash ${startScript}
      env = QT_WAYLAND_DISABLE_WINDOWDECORATION, 1
      env = WLR_DRM_NO_ATOMIC, 1

      # Firefox
      env = MOZ_DISABLE_RDD_SANDBOX, 1
      env = EGL_PLATFORM, wayland
      env = MOZ_ENABLE_WAYLAND, 1

      monitor = ,highrr, auto, 1.25

      # scale apps
      exec-once = xprop -root -f _XWAYLAND_GLOBAL_OUTPUT_SCALE 32c -set _XWAYLAND_GLOBAL_OUTPUT_SCALE 2

      input {
        kb_options = ctrl:swapcaps

        # focus change on cursor move
        follow_mouse = 1
        accel_profile = flat
        touchpad {
          scroll_factor = 0.3
        }
      }

      # touchpad gestures
      gestures {
        workspace_swipe = true
        workspace_swipe_forever = true
      }

      #---------------------------------------------------
      # GAPS, BORDERS, COLORS
      #---------------------------------------------------

      general {
        gaps_in = 5
        gaps_out = 5
        border_size = 2
        col.active_border = rgb(${colors.mauve})
        col.inactive_border = rgb(000000)

        allow_tearing = true
        layout = dwindle
        resize_on_border = true
      }

      #---------------------------------------------------
      # ROUNDNESS, BLUR, SHADOW
      #---------------------------------------------------

      decoration {
        rounding = 16
        blur {
          enabled = true
          xray = true
          size = 12
          passes = 4
          new_optimizations = true
        }

        drop_shadow = true
        shadow_range = 30
        shadow_render_power = 4
        col.shadow = rgba(00000099)
      }

      #---------------------------------------------------
      # ANIMATIONS
      #---------------------------------------------------

      animations {
        enabled = true

        bezier = quart, 0.25, 1, 0.5, 1

        animation = windows, 1, 6, quart, slide
        animation = border, 1, 6, quart
        animation = borderangle, 1, 6, quart
        animation = fade, 1, 6, quart
        animation = workspaces, 1, 6, quart
      }

      #---------------------------------------------------
      # WINDOWS BEHAVIOUR
      #---------------------------------------------------

      dwindle {
        # keep floating dimetions while tiling
        pseudotile = true
        preserve_split = true
      }

      master {
        new_is_master = true
      }

      # only allow shadows for floating windows
      windowrulev2 = noshadow, floating:0

      # start spotify tiled in ws9
      windowrulev2 = tile, title:^(Spotify)$
      windowrulev2 = workspace 9 silent, title:^(Spotify)$

      windowrulev2 = float,class:(.blueman-manager-wrapped)

      #---------------------------------------------------
      # KEYBINDINGS
      #---------------------------------------------------

      $mod = SUPER
      bind = $mod, Q, exec, wezterm
      bind = $mod, M, exit
      bind = $mod, C, killactive
      bind = $mod, V, togglefloating
      bind = $mod, P, pseudo
      bind = $mod, J, togglesplit
      bind = $mod, F, fullscreen, 1 
      bind = $mod, D, exec, $HOME/.config/rofi/bin/launcher
      bind = $mod, R, exec, $HOME/.config/rofi/bin/runner
      bind = $mod SHIFT, P, exec, $HOME/.config/rofi/bin/powermenu

      # Resize active window
      bind = $mod ALT, H, resizeactive, -10 0
      bind = $mod ALT, L, resizeactive, 10 0
      bind = $mod ALT, K, resizeactive, 0 -10
      bind = $mod ALT, J, resizeactive, 0 10

      # Move active window
      bind = $mod SHIFT, H, movewindow, l
      bind = $mod SHIFT, L, movewindow, r
      bind = $mod SHIFT, K, movewindow, u
      bind = $mod SHIFT, J, movewindow, d 

      # Move to other screen
      bind = $mod, CTRL, movewindow,mon:l

      # Move Focus
      bind = $mod, H, movefocus, l
      bind = $mod, L, movefocus, r
      bind = $mod, K, movefocus, u
      bind = $mod, J, movefocus, d

      # Switch workspace
      bind = $mod, 1, workspace, 1
      bind = $mod, 2, workspace, 2
      bind = $mod, 3, workspace, 3
      bind = $mod, 4, workspace, 4
      bind = $mod, 5, workspace, 5
      bind = $mod, 6, workspace, 6
      bind = $mod, 7, workspace, 7
      bind = $mod, 8, workspace, 8
      bind = $mod, 9, workspace, 9
      bind = $mod, 0, workspace, 10

      # Move current window to other workspace
      bind = $mod SHIFT, 1, movetoworkspace, 1
      bind = $mod SHIFT, 2, movetoworkspace, 2
      bind = $mod SHIFT, 3, movetoworkspace, 3
      bind = $mod SHIFT, 4, movetoworkspace, 4
      bind = $mod SHIFT, 5, movetoworkspace, 5
      bind = $mod SHIFT, 6, movetoworkspace, 6
      bind = $mod SHIFT, 7, movetoworkspace, 7
      bind = $mod SHIFT, 8, movetoworkspace, 8
      bind = $mod SHIFT, 9, movetoworkspace, 9
      bind = $mod SHIFT, 0, movetoworkspace, 10


      # backlight
      binde = , XF86MonBrightnessUp, exec, brightnessctl set +3% > /dev/null
      binde = , XF86MonBrightnessDown, exec, brightnessctl set 3%- > /dev/null

      # volume
      binde = , XF86AudioRaiseVolume, exec, pamixer -i 3
      binde = , XF86AudioLowerVolume, exec, pamixer -d 3
      bindl = , XF86AudioMute, exec, pamixer -t
      bindl = , XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle

      # screenshot 
      bind =, Print, exec, grim -g "$(slurp)" - | wl-copy && wl-paste > ~/Pictures/Screenshots/Screenshot-$(date +%F_%T).png | dunstify "Screenshot of the region taken" -t 1000 # screenshot of a region 
      bind = SHIFT, Print, exec, grim - | wl-copy && wl-paste > ~/Pictures/Screenshots/Screenshot-$(date +%F_%T).png | dunstify "Screenshot of whole screen taken" -t 1000 # screenshot of the whole screen

      # mouse movements
      bindm = $mod, mouse:272, movewindow
      bindm = $mod, mouse:273, resizewindow
      bindm = $mod ALT, mouse:272, resizewindow

    '';
  };

}
