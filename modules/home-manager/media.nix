{
  lib,
  config,
  pkgs,
  ...
}: {
  options.media.enable = lib.mkEnableOption "enables media creation tools";

  config = lib.mkIf config.media.enable {
    home.packages = with pkgs; [
      obs-studio
      shotcut
    ];
  };
}
