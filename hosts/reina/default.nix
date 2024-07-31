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

  users.groups.media = { };
  users.users.giu = { extraGroups = [ "media" ]; };
  systemd.tmpfiles.rules = [ "d /home/media 0770 - media - -" ];
  services.jellyfin = {
    enable = true;
    openFirewall = true;
    group = "media";
  };
  environment.systemPackages =
    [ pkgs.jellyfin pkgs.jellyfin-web pkgs.jellyfin-ffmpeg ];
}
