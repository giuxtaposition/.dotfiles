{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {direnv.enable = lib.mkEnableOption "enables direnv module";};

  config = lib.mkIf config.direnv.enable {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      config = {
        global = {
          hide_env_diff = true;
        };
      };
    };
  };
}
