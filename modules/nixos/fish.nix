{
  lib,
  config,
  pkgs,
  ...
}: {
  options = {fish.enable = lib.mkEnableOption "enables fish shell module";};

  config = lib.mkIf config.fish.enable {
    programs.fish.enable = true;
    users.users.giu.shell = pkgs.fish;
  };
}
