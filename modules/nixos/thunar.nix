{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {thunar.enable = lib.mkEnableOption "enables thunar module";};

  config = lib.mkIf config.thunar.enable {
    programs.thunar = {
      enable = true;
      plugins = with pkgs.xfce; [thunar-volman thunar-archive-plugin];
    };
    programs.xfconf.enable = true; # Save preferences
    services.gvfs.enable = true; # Mount, trash, and other functionalities
    services.tumbler.enable = true; # Thumbnail support for images
  };
}
