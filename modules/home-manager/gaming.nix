{
  lib,
  config,
  pkgs,
  ...
}: {
  options.gaming.enable = lib.mkEnableOption "enables gaming tools";

  config = lib.mkIf config.gaming.enable {
    home.packages = [pkgs.steam-run];
  };
}
