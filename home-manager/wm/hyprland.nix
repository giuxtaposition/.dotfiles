{ config, pkgs, lib, ... }: {

  home.packages = with pkgs; [
    unstable.swww # wallpaper manager
    rofi-wayland # rofi for wayland
    wl-clipboard # command-line copy/paste utilities for wayland
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
      swww img ~/Wallpapers/arcane.jpg &
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
      env = QT_WAYLAND_DISABLE_WINDOWDECORATION,1
      monitor = ,preferred, auto, auto

      # scale apps
      exec-once = xprop -root -f _XWAYLAND_GLOBAL_OUTPUT_SCALE 32c -set _XWAYLAND_GLOBAL_OUTPUT_SCALE 2

      # touchpad gestures
      gestures {
        workspace_swipe = true
        workspace_swipe_forever = true
      }

      general {
        gaps_in = 5
        gaps_out = 5
        border_size = 1
        col.active_border = rgba(88888888)
        col.inactive_border = rgba(00000088)

        allow_tearing = true
      }

      decoration {
        rounding = 16
        blur {
          enabled = true
          size = 10
          passes = 3
          new_optimizations = true
          brightness = 1.0
          contrast = 1.0
          noise = 0.02
        }

        drop_shadow = true
        shadow_ignore_window = true
        shadow_offset = 0 5
        shadow_range = 50
        shadow_render_power = 3
        col.shadow = rgba(00000099)
      }

      animations {
        enabled = true
        animation = border, 1, 2, default
        animation = fade, 1, 4, default
        animation = windows, 1, 3, default, popin 80%
        animation = workspaces, 1, 2, default, slide
      }

      dwindle {
        # keep floating dimetions while tiling
        pseudotile = true
        preserve_split = true
      }

      # only allow shadows for floating windows
      windowrulev2 = noshadow, floating:0

      # start spotify tiled in ws9
      windowrulev2 = tile, title:^(Spotify)$
      windowrulev2 = workspace 9 silent, title:^(Spotify)$

      $mod = SUPER
      bind = $mod, Q, exec, wezterm
      bind = $mod, M, exit
      bind = $mod, C, killactive
      bind = $mod, V, togglefloating
      bind = $mod, P, pseudo
      bind = $mod, J, togglesplit
      bind = $mod ALT, ,resizeactive,
      bind = $mod, D, exec, $HOME/.config/rofi/bin/launcher
      bind = $mod, R, exec, $HOME/.config/rofi/bin/runner
      bind = $mod SHIFT, P, exec, $HOME/.config/rofi/bin/powermenu

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


      # mouse movements
      bindm = $mod, mouse:272, movewindow
      bindm = $mod, mouse:273, resizewindow
      bindm = $mod ALT, mouse:272, resizewindow

      input {
        kb_options = ctrl:swapcaps

        # focus change on cursor move
        follow_mouse = 1
        accel_profile = flat
        touchpad {
          scroll_factor = 0.3
        }
      }
    '';
  };

}
