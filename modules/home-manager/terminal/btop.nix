{ config, pkgs, lib, ... }: {

  options = { btop.enable = lib.mkEnableOption "enables btop module"; };

  config = lib.mkIf config.btop.enable {
    programs.btop = {
      enable = true;
      package = pkgs.btop.override ({ rocmSupport = true; });
      catppuccin.enable = true;
    };

  };
}
