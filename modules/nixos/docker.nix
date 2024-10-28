{
  lib,
  config,
  pkgs,
  ...
}: {
  options = {docker.enable = lib.mkEnableOption "enables docker module";};

  config = lib.mkIf config.docker.enable {
    virtualisation.docker.enable = true;
    users.users.giu.extraGroups = ["docker"];

    environment = {systemPackages = with pkgs; [docker docker-compose];};
  };
}
