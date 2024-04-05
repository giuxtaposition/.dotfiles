{ config, pkgs, lib, ... }: {

  options = { bat.enable = lib.mkEnableOption "enables bat module"; };

  config = lib.mkIf config.bat.enable {
    programs.bat = {
      enable = true;
      config = { theme = "Catppuccin Mocha"; };
    };

    home.file."${config.home.homeDirectory}/.config/bat/themes" = {
      source = "${pkgs.bat-catppuccin-theme.out}/bat-catppuccin-theme";
      onChange = ''
        bat cache --build
      '';
    };
  };
}
