{ config, pkgs, lib, inputs, ... }: {

  home.packages = with pkgs; [
    socat # Utility for bidirectional data transfer between two independent data channels
    jaq # JSON data processing tool
  ];

  programs.eww = {
    enable = true;
    package = pkgs.eww-wayland;
    configDir = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/.dotfiles/.config/eww";
  };
}
