{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {ghostty.enable = lib.mkEnableOption "enables ghostty module";};

  config = lib.mkIf config.ghostty.enable {
    home.packages = with pkgs; [
      unstable.ghostty
    ];

    home.file."${config.home.homeDirectory}/.config/ghostty" = {
      source =
        config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/.dotfiles/.config/ghostty";
    };
  };
}
