{ config, pkgs, ... }: {
  imports = [ ./hardware-configuration.nix ../common.nix ];

  networking.hostName = "Reina";

  services.xserver.videoDrivers = [ "amd" ];

  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
  };

  ddcutil.enable = true;
  docker.enable = true;
  steam.enable = true;
  thunar.enable = true;
  fish.enable = true;
}
