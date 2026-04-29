{pkgs, ...}: {
  imports = [./common.nix ./desktop.nix];

  media.enable = true;
  work.enable = true;
  gaming.enable = true;

  niri.extraConfig = ''
    output "DP-2" {
        mode "1920x1080@144.0"
        scale 1.0
        position x=2560 y=0
        variable-refresh-rate
    }

    output "DP-3" {
        mode "3840x2160@160.0"
        scale 1.5
        position x=4480 y=0
        variable-refresh-rate
    }
  '';

  programs = {
    ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks = {
        "kumiko" = {
          hostname = "kumiko.local";
          user = "giu";
        };
        "kumiko-ts" = {
          hostname = "kumiko"; # Tailscale MagicDNS — replace with IP if MagicDNS is not enabled
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
