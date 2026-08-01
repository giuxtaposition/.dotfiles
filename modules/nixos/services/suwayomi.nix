# Suwayomi-server — manga library (Tachiyomi-compatible)
#
# Runs as a Podman container using upstream image (ships CEF + Xvfb +
# all Chromium deps baked in). Native JAR on NixOS is unworkable because
# KCEF spawns `jcef_helper`, a raw ELF that hits NixOS's stub-ld.
#
# Uses host networking so it can reach the FlareSolverr NixOS service
# on 127.0.0.1:8191. WebUI on port 4567.
#
# Storage:
#   /var/lib/suwayomi   → Tachidesk state (DB, cache, extensions)
#   /media/Manga        → downloads (shared with `media` group, setgid
#                         so files inherit the group for Jellyfin etc.)
{
  lib,
  config,
  ...
}: let
  mediaGid = 3000;
in {
  options = {suwayomi.enable = lib.mkEnableOption "Suwayomi-server manga library";};

  config = lib.mkIf config.suwayomi.enable {
    virtualisation = {
      podman.enable = lib.mkDefault true;
      oci-containers = {
        backend = lib.mkDefault "podman";
        containers.suwayomi = {
          image = "ghcr.io/suwayomi/suwayomi-server:latest";

          # Host networking — reach flaresolverr on 127.0.0.1:8191 without
          # extra network plumbing, and skip port publishing.
          extraOptions = [
            "--network=host"
            "--group-add=${toString mediaGid}"
          ];

          environment = {
            TZ = "Europe/Rome";
            PUID = "1000";
            PGID = toString mediaGid;
            UMASK = "002";

            BIND_IP = "0.0.0.0";
            BIND_PORT = "4567";

            DOWNLOAD_AS_CBZ = "true";
            AUTO_DOWNLOAD_NEW_CHAPTERS = "true";

            FLARESOLVERR_ENABLED = "true";
            FLARESOLVERR_URL = "http://127.0.0.1:8191";
            FLARESOLVERR_TIMEOUT = "60";
            FLARESOLVERR_SESSION_NAME = "suwayomi";
            FLARESOLVERR_SESSION_TTL = "15";
          };

          volumes = [
            "/var/lib/suwayomi:/home/suwayomi/.local/share/Tachidesk"
            "/media/Manga:/home/suwayomi/.local/share/Tachidesk/downloads"
          ];
        };
      };
    };

    # Pin the media group gid so we can pass it to the container via
    # --group-add and have new downloads inherit it via the setgid dir.
    users.groups.media.gid = mediaGid;

    # FlareSolverr — Cloudflare bypass proxy on host (localhost only)
    services.flaresolverr = {
      enable = true;
      port = 8191;
      openFirewall = false;
    };

    # WebUI reachable from LAN
    networking.firewall.allowedTCPPorts = [4567];

    # setgid on /media/Manga → files inherit media group so Jellyfin etc.
    # can read what suwayomi writes.
    systemd.tmpfiles.rules = [
      "d /var/lib/suwayomi 0755 1000 ${toString mediaGid} - -"
      "d /media/Manga 2775 1000 ${toString mediaGid} - -"
    ];
  };
}
