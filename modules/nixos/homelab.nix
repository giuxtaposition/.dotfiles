{
  lib,
  config,
  pkgs,
  ...
}: let
in {
  options = {homelab.enable = lib.mkEnableOption "enables homelab module";};

  config = lib.mkIf config.homelab.enable {
    media_server.enable = true;
    services.homepage-dashboard = {
      enable = true;
      settings = {
        title = "Giu's Homelab";
        description = "Welcome to my homelab dashboard";
        theme = "dark";
        layout = {
          Media = {
            style = "row";
            columns = "4";
          };
        };
      };
      widgets = [
        {
          resources = {
            cpu = true;
            memory = true;
          };
        }
      ];
      services = [
        {
          "Media" = [
            {
              "Jellyfin" = {
                description = "Watch movies and series";
                href = "http://localhost:8096/web/#/home";
                icon = "jellyfin";
              };
            }
            {
              "Radarr" = {
                description = "Manage movies";
                href = "http://localhost:7878";
                icon = "radarr";
              };
            }

            {
              "Sonarr" = {
                description = "Manage TV series";
                href = "http://localhost:8989";
                icon = "sonarr";
              };
            }
            {
              "Prowlarr" = {
                description = "Manage indexers";
                href = "http://localhost:9696";
                icon = "prowlarr";
              };
            }
            {
              "Deluge" = {
                description = "Torrent client";
                href = "http://localhost:8112";
                icon = "deluge";
              };
            }
          ];
        }
      ];
    };
  };
}
