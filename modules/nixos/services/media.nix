# Media server stack — Jellyfin, Sonarr, Radarr, Prowlarr
#
# These services share a 'media' group for cross-service file access:
#   - Jellyfin reads media files
#   - Sonarr/Radarr manage and hardlink downloads
#   - Prowlarr provides indexer management
#
# Jellyfin gets hardware transcoding access via render/video groups.
{
  lib,
  config,
  ...
}: {
  options = {media.enable = lib.mkEnableOption "media server services (Jellyfin, Sonarr, Radarr, Prowlarr)";};

  config = lib.mkIf config.media.enable {
    # Shared media group for cross-service file access
    users.groups.media = {};

    # Jellyfin media server
    services = {
      jellyfin = {
        enable = true;
        openFirewall = true; # Port 8096
        group = "media";
      };
      # Sonarr — TV show management
      sonarr = {
        enable = true;
        openFirewall = true; # Port 8989
        group = "media";
      };
      # Radarr — movie management
      radarr = {
        enable = true;
        openFirewall = true; # Port 7878
        group = "media";
      };
      # Prowlarr — indexer manager
      prowlarr = {
        enable = true;
        openFirewall = true; # Port 9696
      };
    };

    # Hardware acceleration for Jellyfin transcoding
    users.users.jellyfin.extraGroups = [
      "render" # Access to /dev/dri/renderD128
      "video" # Access to /dev/dri/card0
    ];

    # Data directories with correct ownership
    systemd.tmpfiles.rules = [
      "d /media 0775 root media -"
      "d /var/lib/jellyfin 0750 jellyfin media - -"
      "d /var/lib/sonarr 0750 sonarr media - -"
      "d /var/lib/radarr 0750 radarr media - -"
    ];
  };
}
