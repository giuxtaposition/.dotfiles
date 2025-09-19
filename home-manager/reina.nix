{pkgs, ...}: {
  imports = [./common.nix];

  monitors = [
    {
      name = "DP-2";
      index = 0;
      width = 1920;
      height = 1080;
      refreshRate = 144;
      x = 0;
      workspace = "1";
      primary = true;
    }
    {
      name = "HDMI-A-1";
      index = 1;
      width = 1920;
      height = 1080;
      refreshRate = 60;
      x = 1920;
      workspace = "2";
    }
  ];

  home.sessionVariables = {
    WLR_BACKEND = "vulkan";
    WLR_RENDERER = "vulkan";
  };

  programs.fish.shellAbbrs = {
    home-update = "cd /home/giu/.dotfiles && home-manager switch --flake .#giu@reina";
    nixos-update = "cd /home/giu/.dotfiles && sudo nixos-rebuild switch --flake .#reina";
  };

  home.packages = with pkgs; [
    aseprite # Pixel Art Editor
    inkscape-with-extensions
    discord # Messaging App

    qmk
    qmk-udev-rules
    wvkbd

    calibre # Library Management
    ns-usbloader
    openrgb-with-all-plugins
    kdePackages.konversation
  ];

  coding.enable = true;
}
