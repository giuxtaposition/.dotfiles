{
  lib,
  config,
  pkgs,
  ...
}: {
  options = {mpv.enable = lib.mkEnableOption "enables mpv module";};

  config = lib.mkIf config.mpv.enable {
    programs.mpv = {
      enable = true;
      scripts = with pkgs; [
        mpvScripts.occivink.crop
      ];
    };
  };
}
