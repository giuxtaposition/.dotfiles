{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  options = {wayland.enable = lib.mkEnableOption "enables wayland module";};

  config = lib.mkIf config.wayland.enable {
    home.packages = with pkgs; [
      swww # wallpaper manager
      wl-clipboard # command-line copy/paste utilities for wayland
      slurp # select a region in a wayland compositor
      grim # grab images from a wayland compositor
      swayidle
      qt5.qtwayland
      qt6.qtwayland
      wdisplays
    ];

    # Wallpapers folder
    home.file."${config.home.homeDirectory}/Wallpapers" = {
      source =
        config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/.dotfiles/Wallpapers";
    };

    home.sessionVariables = {
      # XDG Specifications
      XDG_SESSION = "wayland";
      XDG_SESSION_TYPE = "wayland";
      # QT, GDK, SL2, Clutter: use wayland if available, fallback to x11 if not
      QT_QPA_PLATFORM = "wayland";
      GDK_BACKEND = "wayland";
      SDL_VIDEODRIVER = "wayland";
      CLUTTER_BACKEND = "wayland";
      EGL_PLATFORM = "wayland";
      # Hint electron apps to use wayland
      NIXOS_OZONE_WL = "1";
      # use legacy DRM instead of atomic mode setting
      WLR_DRM_NO_ATOMIC = "1";
      # Firefox
      MOZ_ENABLE_WAYLAND = "1";
      MOZ_USE_XINPUT2 = "1";
      # QT envs
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
      # Fix disappearing cursor
      WLR_NO_HARDWARE_CURSORS = "1";
    };

    programs.swaylock = {
      enable = true;
      settings = {
        color = "1e1e2e";
        bs-hl-color = "f5e0dc";
        caps-lock-bs-hl-color = "f5e0dc";
        caps-lock-key-hl-color = "a6e3a1";
        inside-color = "00000000";
        inside-clear-color = "00000000";
        inside-caps-lock-color = "00000000";
        inside-ver-color = "00000000";
        inside-wrong-color = "00000000";
        key-hl-color = "a6e3a1";
        layout-bg-color = "00000000";
        layout-border-color = "00000000";
        layout-text-color = "cdd6f4";
        line-color = "00000000";
        line-clear-color = "00000000";
        line-caps-lock-color = "00000000";
        line-ver-color = "00000000";
        line-wrong-color = "00000000";
        ring-color = "b4befe";
        ring-clear-color = "f5e0dc";
        ring-caps-lock-color = "fab387";
        ring-ver-color = "89b4fa";
        ring-wrong-color = "eba0ac";
        separator-color = "00000000";
        text-color = "cdd6f4";
        text-clear-color = "f5e0dc";
        text-caps-lock-color = "fab387";
        text-ver-color = "89b4fa";
        text-wrong-color = "eba0ac";
        image = "~/Wallpapers/WRztVWQ.jpg";
      };
    };
  };
}
