# Immich — Self-hosted Photo/Video Management
#
# Package comes from nixpkgs-unstable: 26.05 ships Immich 2.x, which is EOL
# and marked insecure (CVE-2026-59258, CVE-2026-82272). The 26.05 module
# drives 3.x unchanged — it only needs `package.machine-learning`, which the
# unstable package still provides.
{
  lib,
  config,
  pkgs,
  ...
}: {
  options = {immich.enable = lib.mkEnableOption "Immich photo/video management";};

  config = lib.mkIf config.immich.enable {
    services.immich = {
      enable = true;
      package = pkgs.unstable.immich;
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
