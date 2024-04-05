{ lib, config, ... }: {

  options = { docker.enable = lib.mkEnableOption "enables docker module"; };

  config = lib.mkIf config.docker.enable {
    virtualisation.docker.enable = true;
    users.users.giu.extraGroups = [ "docker" ];
  };
}
