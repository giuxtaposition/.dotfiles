{
  lib,
  config,
  pkgs,
  ...
}: let
  mediaGroup = "media";
in {
  options = {media_server.enable = lib.mkEnableOption "enables media_server module";};

  config = lib.mkIf config.media_server.enable {
    users.groups = {
      ${mediaGroup} = {
        members = ["jellyfin" "radarr" "sonarr" "bazarr" "prowlarr"];
      };
    };
    users.users.giu = {extraGroups = [mediaGroup];};

    systemd.tmpfiles.rules = ["d /home/media 0770 - media - -"];
    users.users.jellyfin = {extraGroups = ["video" "render"];};
    environment.systemPackages = [pkgs.jellyfin pkgs.jellyfin-web pkgs.jellyfin-ffmpeg];

    services.jellyfin = {
      enable = true;
      openFirewall = true;
      group = mediaGroup;
    };
    services.radarr = {
      enable = true;
      group = mediaGroup;
      openFirewall = true;
    };
    services.sonarr = {
      enable = true;
      group = mediaGroup;
      openFirewall = true;
    };
    services.bazarr = {
      enable = true;
      group = mediaGroup;
      openFirewall = true;
    };
    services.prowlarr = {
      enable = true;
      openFirewall = true;
    };
    services.deluge = {
      enable = true;
      group = mediaGroup;
      web = {
        enable = true;
        openFirewall = true;
      };
    };

    services.cloudflared = {
      enable = true;
      tunnels = {
        "26c577c7-9e1b-4632-b4e9-e28392cc165a" = {
          credentialsFile = "${config.users.users.giu.home}/.cloudflared/26c577c7-9e1b-4632-b4e9-e28392cc165a.json";
          default = "http_status:404";
        };
      };
    };
  };
}
