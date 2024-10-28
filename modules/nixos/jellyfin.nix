{
  lib,
  config,
  pkgs,
  ...
}: {
  options = {jellyfin.enable = lib.mkEnableOption "enables jellyfin module";};

  config = lib.mkIf config.jellyfin.enable {
    users.groups.media = {};
    users.users.giu = {extraGroups = ["media"];};
    systemd.tmpfiles.rules = ["d /home/media 0770 - media - -"];
    services.jellyfin = {
      enable = true;
      openFirewall = true;
      group = "media";
    };
    users.users.jellyfin = {extraGroups = ["video" "render"];};
    environment.systemPackages = [pkgs.jellyfin pkgs.jellyfin-web pkgs.jellyfin-ffmpeg];

    services.cloudflared = {
      enable = true;
      user = "giu";
      tunnels = {
        "26c577c7-9e1b-4632-b4e9-e28392cc165a" = {
          credentialsFile = "${config.users.users.giu.home}/.cloudflared/26c577c7-9e1b-4632-b4e9-e28392cc165a.json";
          default = "http_status:404";
        };
      };
    };
  };
}
