{ lib, config, pkgs, ... }:
let
  firefoxWorkScript = pkgs.writeScriptBin "firefoxWork" ''
    #! ${pkgs.bash}/bin/sh
    firefox -P "work"
  '';

  firefoxWork = pkgs.makeDesktopItem {
    name = "firefox-work-profile";
    desktopName = "Firefox Work Profile";
    exec = ''firefox -P "work"'';
    terminal = false;
    icon = "firefox";
  };
in {
  options = { coding.enable = lib.mkEnableOption "enables coding module"; };

  config = lib.mkIf config.coding.enable {
    home.sessionVariables = {
      MONGOMS_DISTRO =
        "ubuntu-22.04"; # MONGO MEMORY SERVER not supporting nixos
      CYPRESS_INSTALL_BINARY = "0";
      CYPRESS_RUN_BINARY = "${pkgs.cypress}/bin/Cypress";
    };

    nvim.enable = true;
    bat.enable = true;
    fish.enable = true;
    git.enable = true;
    wezterm.enable = true;

    home.packages = with pkgs; [
      chromium
      cypress
      jdk
      kotlin
      gradle
      nodePackages.node2nix
      bruno
      mongodb-compass
      sqlite
      nodePackages_latest.pnpm

      (firefoxWork)
      (firefoxWorkScript)
    ];
  };
}
