{ lib, config, ... }: {

  options = { steam.enable = lib.mkEnableOption "enables steam module"; };

  config = lib.mkIf config.steam.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
  };
}
