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

    home.sessionVariables = {
      DIRENV_LOG_FORMAT = "\\e[2mdirenv: %s\\e[0m";
    };
  };
}
