{ config, pkgs, lib, ... }: {
  home.packages = with pkgs; [ bat ];

  home.file."${config.home.homeDirectory}/.config/bat/themes" = {
    source = "${pkgs.bat-catppuccin-theme.out}/bat-catppuccin-theme";
    onChange = ''
      bat cache --build
    '';
  };

  programs.bat = {
    enable = true;
    config = { theme = "Catppuccin-mocha"; };
  };

}
