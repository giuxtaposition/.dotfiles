{pkgs, ...}: {
  imports = [./common.nix];

  programs = {
    niri.settings.outputs = {
      "DP-2" = {
        mode = {
          width = 1920;
          height = 1080;
          refresh = 144.0;
        };
        scale = 1.0;
        position = {
          x = 2560;
          y = 0;
        };
        variable-refresh-rate = true;
      };
      "DP-3" = {
        mode = {
          width = 3840;
          height = 2160;
          refresh = 160.0;
        };
        scale = 1.5;
        position = {
          x = 4480;
          y = 0;
        };
        variable-refresh-rate = true;
      };
    };

    ssh = {
      enable = true;
      matchBlocks = {
        "kumiko" = {
          hostname = "kumiko";
          user = "giu";
        };
      };
    };

    fish.shellAbbrs = {
      home-update = "cd /home/giu/.dotfiles && home-manager switch --flake .#giu@reina";
      nixos-update = "cd /home/giu/.dotfiles && sudo nixos-rebuild switch --flake .#reina";
    };
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

  coding = {
    enable = true;
    typescript.enable = true;
    lua.enable = true;
    nix.enable = true;
    bash.enable = true;
    markdown.enable = true;
  };
}
