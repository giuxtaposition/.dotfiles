{ config, pkgs, lib, ... }: {

  home.packages = with pkgs; [
    swww # wallpaper manager
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

      dunst
    '';
  in {
    enable = true;
    enableNvidiaPatches = true;
    xwayland.enable = true;
    extraConfig = ''
      exec-once=bash ${startScript}
      monitor = ,preferred, auto, auto

      $mod = SUPER
      bind = $mod, Q, exec, wezterm
      bind = $mod, M, exit
      bind = $mod, C, killactive
      bind = $mod, V, togglefloating
      bind = $mod, P, pseudo
      bind = $mod, J, togglesplit
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

      input {
        kb_options = ctrl:swapcaps
      }
    '';
  };

}
