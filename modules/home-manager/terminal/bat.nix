{
  config,
  lib,
  ...
}: {
  options = {bat.enable = lib.mkEnableOption "enables bat module";};

  config = lib.mkIf config.bat.enable {
    programs.bat = {
      enable = true;
      catppuccin.enable = true;
    };
  };
}
