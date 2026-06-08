{
  lib,
  config,
  pkgs,
  ...
}: {
  options = {docker.enable = lib.mkEnableOption "enables docker module";};

  config = lib.mkIf config.docker.enable {
    virtualisation.docker = {
      enable = true;
      package = pkgs.docker_29;
    };
    users.users.giu.extraGroups = ["docker"];

    environment = {systemPackages = with pkgs; [docker_29 docker-compose];};
  };
}
