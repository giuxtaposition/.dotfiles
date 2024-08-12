{ lib, config, ... }: {

  options = { network.enable = lib.mkEnableOption "enables network module"; };

  config = lib.mkIf config.network.enable {
    networking = {
      networkmanager.enable = true;
      extraHosts = ''
        127.0.0.1   calc-local.vitesicure.it
        127.0.0.1   calc-local.bridgebroker.it
        127.0.0.1   api-v2-local.vitesicure.it
        127.0.0.1   api-v2-local.bridgebroker.it
      '';
    };
    users.users.giu.extraGroups = [ "networkmanager" ];
  };
}
