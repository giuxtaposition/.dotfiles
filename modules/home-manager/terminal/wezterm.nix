{ config, pkgs, lib, ... }: {

  options = { wezterm.enable = lib.mkEnableOption "enables wezterm module"; };

  config = lib.mkIf config.wezterm.enable {
    home.packages = with pkgs; [ wezterm ];

    home.file."${config.home.homeDirectory}/.config/wezterm" = {
      source = config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/.dotfiles/.config/wezterm";
    };

    home.file."${config.home.homeDirectory}/.terminfo/w/wezterm" = {
      source = config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/.dotfiles/modules/home-manager/terminal/wezterm";
    };
  };
}
