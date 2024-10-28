{
  lib,
  config,
  pkgs,
  ...
}: {
  options = {
    bluetooth.enable = lib.mkEnableOption "enables bluetooth shell module";
  };

  config = lib.mkIf config.bluetooth.enable {
    hardware.bluetooth = {
      enable = true;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
          Experimental = true;
        };
      };
      powerOnBoot = true; # powers up the default Bluetooth controller on boot
    };
    hardware.pulseaudio = {
      enable = true;
      extraConfig = ''
        load-module module-switch-on-connect
      '';
    };
    services.blueman.enable = true;
  };
}
