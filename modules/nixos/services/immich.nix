# Immich — Self-hosted Photo/Video Management
{
  lib,
  config,
  ...
}: {
  options = {immich.enable = lib.mkEnableOption "Immich photo/video management";};

  config = lib.mkIf config.immich.enable {
    services.immich = {
      enable = true;
      openFirewall = true; # Port 2283
      mediaLocation = "/media/immich";
      machine-learning.enable = true;
      host = "0.0.0.0";
    };

    systemd.tmpfiles.rules = [
      "d /media/immich 0770 immich immich - -"
    ];
  };
}
