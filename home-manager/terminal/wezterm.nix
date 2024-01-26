{ config, pkgs, ... }: {

  home.packages = with pkgs; [ wezterm ];

  home.file."${config.home.homeDirectory}/.config/wezterm" = {
    source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/.dotfiles/.config/wezterm";
  };

  home.file."${config.home.homeDirectory}/.terminfo/w/wezterm" = {
    source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/.dotfiles/home-manager/terminal/wezterm";
  };

}
