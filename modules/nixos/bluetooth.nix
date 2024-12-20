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
    services.blueman.enable = true;
  };
}
