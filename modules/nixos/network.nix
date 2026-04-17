{
  lib,
  config,
  ...
}: {
  options = {network.enable = lib.mkEnableOption "enables network module";};

  config = lib.mkIf config.network.enable {
    networking.networkmanager.enable = true;
    users.users.giu.extraGroups = ["networkmanager"];
  };
}
