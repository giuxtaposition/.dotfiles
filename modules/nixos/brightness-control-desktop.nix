{
  lib,
  config,
  pkgs,
  ...
}: {
  options = {brightness-control-desktop.enable = lib.mkEnableOption "enables brightness-control-desktop module";};

  config = lib.mkIf config.brightness-control-desktop.enable {
    hardware.i2c.enable = true;

    environment.systemPackages = with pkgs; [
      ddcutil
      i2c-tools
    ];

    users.users.giu.extraGroups = ["i2c"];
  };
}
