{ pkgs, ... }: {
  imports = [ ./common.nix ];

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

  ags.keyboard_name = "36125:13370:splitkb.com_Aurora_Corne_rev1";

  programs.fish.shellAbbrs = {
    home-update = "z dot && home-manager switch --flake .#giu@reina";
    nixos-update = "z dot && sudo nixos-rebuild switch --flake .#reina";
  };

  home.packages = with pkgs; [
    aseprite # Pixel Art Editor
    discord # Messaging App

    qmk
    qmk-udev-rules
    wvkbd
    ventoy

    deluge # Torrent Client
    opera
    calibre # Library Management
  ];
  coding.enable = true;
}
